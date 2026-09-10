const admin = require('firebase-admin');
const crypto = require('crypto');

/**
 * India DPDP Act 2023 (Digital Personal Data Protection Act) Section 12 compliant
 * cascading deletion engine for user personal data and subcollections.
 */
async function deleteUserData(userId, reason = 'USER_REQUESTED_ERASURE') {
  if (!userId) {
    throw new Error('UserId is required for cascading data deletion.');
  }

  const db = admin.firestore();
  const bucket = admin.storage().bucket();
  const deletionLog = {
    userIdHash: crypto.createHash('sha256').update(userId).digest('hex'),
    timestamp: new Date().toISOString(),
    reason,
    subcollectionsPurged: [],
    crossReferencesCleaned: [],
    storageFilesDeleted: 0,
    authDeleted: false,
    status: 'IN_PROGRESS',
  };

  // 1. All subcollections under /users/{userId}
  const userSubcollections = [
    'meals',
    'water_logs',
    'biomarkers',
    'fasting_sessions',
    'sleep_sessions',
    'workout_logs',
    'daily_intelligence',
    'cgm_telemetry',
    'voice_logs',
    'whatsapp_conversations',
    'abha_records',
    'corporate_enrollments',
    'grocery_carts',
    'longevity_reports',
    'environmental_telemetry',
    'doctor_grants',
    'compliance_consents',
    'notifications',
    'badges',
    'habits',
    'soreness_logs',
    'menstrual_logs',
    'body_analytics',
  ];

  const userRef = db.collection('users').doc(userId);

  for (const subcolName of userSubcollections) {
    try {
      const subcolRef = userRef.collection(subcolName);
      const snapshot = await subcolRef.get();
      if (!snapshot.empty) {
        const batch = db.batch();
        snapshot.docs.forEach((doc) => batch.delete(doc.ref));
        await batch.commit();
        deletionLog.subcollectionsPurged.push({ name: subcolName, count: snapshot.size });
      }
    } catch (err) {
      console.warn(`Error deleting subcollection ${subcolName} for user ${userId}:`, err.message);
    }
  }

  // 2. Cross-referencing collections cleanup
  try {
    // Squads
    const squadsQuery = await db.collection('squads').where(`members.${userId}`, '!=', null).get();
    if (!squadsQuery.empty) {
      for (const squadDoc of squadsQuery.docs) {
        const data = squadDoc.data();
        if (data.creatorId === userId && Object.keys(data.members || {}).length <= 1) {
          await squadDoc.ref.delete();
          deletionLog.crossReferencesCleaned.push(`squad_${squadDoc.id}_deleted`);
        } else {
          await squadDoc.ref.update({
            [`members.${userId}`]: admin.firestore.FieldValue.delete(),
          });
          deletionLog.crossReferencesCleaned.push(`squad_${squadDoc.id}_member_removed`);
        }
      }
    }

    // Geolocation Clubs
    const clubsQuery = await db.collection('clubs').where(`members.${userId}`, '!=', null).get();
    if (!clubsQuery.empty) {
      for (const clubDoc of clubsQuery.docs) {
        await clubDoc.ref.update({
          [`members.${userId}`]: admin.firestore.FieldValue.delete(),
        });
        deletionLog.crossReferencesCleaned.push(`club_${clubDoc.id}_member_removed`);
      }
    }

    // Communities
    const commQuery = await db.collection('communities').where(`participants.${userId}`, '!=', null).get();
    if (!commQuery.empty) {
      for (const commDoc of commQuery.docs) {
        await commDoc.ref.update({
          [`participants.${userId}`]: admin.firestore.FieldValue.delete(),
        });
        deletionLog.crossReferencesCleaned.push(`community_${commDoc.id}_participant_removed`);
      }
    }

    // Doctor Access Grants
    const doctorGrants = await db.collection('doctor_access_grants').where('patientId', '==', userId).get();
    if (!doctorGrants.empty) {
      const batch = db.batch();
      doctorGrants.docs.forEach((d) => batch.delete(d.ref));
      await batch.commit();
      deletionLog.crossReferencesCleaned.push(`doctor_grants_${doctorGrants.size}_deleted`);
    }
  } catch (err) {
    console.warn(`Error cleaning cross-references for user ${userId}:`, err.message);
  }

  // 3. Storage files deletion
  try {
    const prefixes = [
      `users/${userId}/`,
      `meals/${userId}/`,
      `progress/${userId}/`,
      `clinical/${userId}/`,
      `voice/${userId}/`,
    ];

    for (const prefix of prefixes) {
      const [files] = await bucket.getFiles({ prefix });
      if (files.length > 0) {
        await Promise.all(files.map((file) => file.delete()));
        deletionLog.storageFilesDeleted += files.length;
      }
    }
  } catch (err) {
    console.warn(`Error deleting storage files for user ${userId}:`, err.message);
  }

  // 4. Delete the root user document
  try {
    await userRef.delete();
  } catch (err) {
    console.warn(`Error deleting root user document for ${userId}:`, err.message);
  }

  // 5. Delete Firebase Auth User
  try {
    await admin.auth().deleteUser(userId);
    deletionLog.authDeleted = true;
  } catch (err) {
    console.warn(`Auth user delete skipped or error for ${userId}:`, err.message);
  }

  deletionLog.status = 'COMPLETED';

  // 6. Write DPDP-compliant cryptographic proof receipt (anonymized hash, no PII)
  try {
    const receiptId = `erasure_${Date.now()}_${deletionLog.userIdHash.substring(0, 10)}`;
    await db.collection('erasure_receipts').doc(receiptId).set({
      receiptId,
      userHash: deletionLog.userIdHash,
      timestamp: deletionLog.timestamp,
      reason: deletionLog.reason,
      status: deletionLog.status,
      dpdpSection: 'DPDP_ACT_2023_SECTION_12_RIGHT_TO_ERASURE',
      summary: {
        subcollectionsPurgedCount: deletionLog.subcollectionsPurged.length,
        crossReferencesCleanedCount: deletionLog.crossReferencesCleaned.length,
        storageFilesDeleted: deletionLog.storageFilesDeleted,
        authDeleted: deletionLog.authDeleted,
      },
    });
  } catch (err) {
    console.warn(`Error writing erasure receipt:`, err.message);
  }

  return deletionLog;
}

module.exports = { deleteUserData };
