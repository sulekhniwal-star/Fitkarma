/**
 * Health OS Brain — Daily Intelligence Package (DIP) Orchestration
 * Single daily intelligence cycle replacing fragmented per-screen AI calls.
 */
const admin = require('firebase-admin');
const { routeAiRequest } = require('../aiRouter');

/**
 * Deterministically computes health & readiness scores, zones, and targets.
 */
function computeDeterministicDIP(yesterdayLogs, userProfile) {
  const sleepHours = yesterdayLogs?.sleepHours || 7.0;
  const sleepQuality = yesterdayLogs?.sleepQuality || 80; // 0-100
  const yesterdaySteps = yesterdayLogs?.steps || 7500;
  const sorenessScore = yesterdayLogs?.sorenessScore || 20; // 0-100 (higher = more sore)
  const isIll = yesterdayLogs?.isIll || false;
  const heatIndex = yesterdayLogs?.heatIndex || 30; // Celsius

  // 1. Readiness Score Calculation (0 - 100)
  // Weighted: 40% Sleep, 30% Muscle Recovery/Soreness, 30% Recent Activity Strain
  const sleepFactor = Math.min(100, (sleepHours / 8.0) * 100) * 0.5 + (sleepQuality * 0.5);
  const recoveryFactor = Math.max(0, 100 - sorenessScore);
  const strainFactor = yesterdaySteps > 15000 ? 70 : (yesterdaySteps > 10000 ? 90 : 80);

  let readinessScore = Math.round((sleepFactor * 0.40) + (recoveryFactor * 0.35) + (strainFactor * 0.25));
  if (isIll) readinessScore = Math.min(readinessScore, 30); // Safety override

  // Readiness Zone
  let readinessZone = 'moderate';
  if (readinessScore >= 80) readinessZone = 'optimal';
  else if (readinessScore >= 60) readinessZone = 'moderate';
  else if (readinessScore >= 40) readinessZone = 'recovery';
  else readinessZone = 'rest';

  // 2. Health Score (Unified baseline)
  const healthScore = Math.min(100, Math.max(40, Math.round((readinessScore * 0.6) + 35)));

  // 3. Adaptive Nutrition & Activity Targets
  const baseCalories = userProfile?.targetCalories || 2000;
  const baseProtein = userProfile?.targetProteinGrams || 120;
  const baseSteps = userProfile?.targetSteps || 8000;

  let targetCalories = baseCalories;
  let targetProtein = baseProtein;
  let targetSteps = baseSteps;
  let workoutRecommendation = 'Standard Training Split';
  const safetyAlerts = [];

  if (isIll) {
    targetCalories = Math.round(baseCalories * 0.9);
    targetSteps = 3000;
    workoutRecommendation = 'Rest & Immune Recovery';
    safetyAlerts.push('Illness detected: Workout suspended. Prioritize hydration and rest.');
  } else if (readinessZone === 'optimal') {
    targetCalories = Math.round(baseCalories * 1.05);
    targetSteps = Math.round(baseSteps * 1.1);
    workoutRecommendation = 'High-Intensity / Progressive Overload Focus';
  } else if (readinessZone === 'recovery' || readinessZone === 'rest') {
    targetCalories = Math.round(baseCalories * 0.95);
    targetSteps = Math.max(4000, Math.round(baseSteps * 0.7));
    workoutRecommendation = 'Active Mobility & Zone 2 Walk';
    safetyAlerts.push('Readiness is reduced. Focus on active recovery and sleep.');
  }

  if (heatIndex >= 38) {
    safetyAlerts.push('Extreme heat advisory: Hydrate aggressively and avoid outdoor noon workouts.');
  }

  return {
    healthScore,
    readinessScore,
    readinessZone,
    targetCalories,
    targetProteinGrams: targetProtein,
    targetSteps,
    workoutRecommendation,
    safetyAlerts
  };
}

/**
 * Generates and caches the Daily Intelligence Package for a user.
 */
async function generateDailyIntelligencePackage(uid, dateStr) {
  const db = admin.firestore();
  const dipRef = db.collection('users').doc(uid).collection('healthOS').doc(dateStr);

  // Check cache first
  const existingDoc = await dipRef.get();
  if (existingDoc.exists) {
    return existingDoc.data();
  }

  // Fetch user profile and yesterday's logs
  const userDoc = await db.collection('users').doc(uid).get();
  const userProfile = userDoc.exists ? userDoc.data() : {};

  // Compute deterministic metrics
  const deterministicOutput = computeDeterministicDIP({}, userProfile);

  // Generate AI Morning Briefing via Groq Router
  let aiBriefing = 'Good morning! Your readiness is balanced. Focus on staying consistent with your daily mission.';
  try {
    const prompt = `User Readiness: ${deterministicOutput.readinessScore}/100 (${deterministicOutput.readinessZone}). Workout: ${deterministicOutput.workoutRecommendation}. Nutrition Target: ${deterministicOutput.targetCalories} kcal. Provide an inspiring, 2-sentence morning health briefing tailored for an Indian lifestyle.`;
    const aiResult = await routeAiRequest({
      tier: 'MEDIUM',
      messages: [
        { role: 'system', content: 'You are FitKarma Health OS Brain, India\'s intelligent health coach. Be concise, actionable, and warm.' },
        { role: 'user', content: prompt }
      ],
      userId: uid
    });
    if (aiResult && aiResult.response) {
      aiBriefing = aiResult.response;
    }
  } catch (err) {
    console.warn('AI Briefing generation fallback to template:', err.message);
  }

  const dipData = {
    date: dateStr,
    healthScore: deterministicOutput.healthScore,
    readinessScore: deterministicOutput.readinessScore,
    readinessZone: deterministicOutput.readinessZone,
    targetCalories: deterministicOutput.targetCalories,
    targetProteinGrams: deterministicOutput.targetProteinGrams,
    targetSteps: deterministicOutput.targetSteps,
    workoutRecommendation: deterministicOutput.workoutRecommendation,
    aiBriefing,
    safetyAlerts: deterministicOutput.safetyAlerts,
    generatedAt: new Date().toISOString()
  };

  // Persist to Firestore
  await dipRef.set(dipData, { merge: true });

  return dipData;
}

module.exports = {
  computeDeterministicDIP,
  generateDailyIntelligencePackage
};
