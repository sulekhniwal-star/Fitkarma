import '../models/social_models.dart';

class FamilyHealthMonitoringEngine {
  const FamilyHealthMonitoringEngine();

  /// Evaluates elderly parent / family member biometrics and determines alert level
  FamilyMemberHealth evaluateHealthStatus({
    required String id,
    required String userId,
    required String relativeUserId,
    required String relativeName,
    required String relation,
    required int age,
    double? systolicBp,
    double? diastolicBp,
    double? fastingGlucoseMgDl,
    int? todaySteps,
    required DateTime recordedAt,
  }) {
    HealthAlertLevel alertLevel = HealthAlertLevel.normal;
    String? messageEn;
    String? messageHi;

    // Check Blood Pressure (Hypertensive Urgency / Crisis)
    if (systolicBp != null && diastolicBp != null) {
      if (systolicBp >= 180 || diastolicBp >= 120) {
        alertLevel = HealthAlertLevel.urgentConsultation;
        messageEn = '$relativeName\'s Blood Pressure is in the hypertensive crisis zone ($systolicBp/$diastolicBp mmHg). Seek immediate medical evaluation.';
        messageHi = '$relativeName का रक्तचाप अत्यधिक उच्च स्तर पर है ($systolicBp/$diastolicBp mmHg)। तुरंत डॉक्टर से परामर्श लें।';
      } else if (systolicBp >= 140 || diastolicBp >= 90) {
        alertLevel = HealthAlertLevel.attentionNeeded;
        messageEn = '$relativeName\'s Blood Pressure is elevated ($systolicBp/$diastolicBp mmHg). Ensure low sodium intake and hydration.';
        messageHi = '$relativeName का रक्तचाप सामान्य से अधिक है ($systolicBp/$diastolicBp mmHg)। नमक कम रखें और पर्याप्त पानी पिएं।';
      }
    }

    // Check Fasting Blood Glucose
    if (fastingGlucoseMgDl != null && alertLevel != HealthAlertLevel.urgentConsultation) {
      if (fastingGlucoseMgDl >= 200) {
        alertLevel = HealthAlertLevel.urgentConsultation;
        messageEn = '$relativeName\'s fasting glucose is significantly high (${fastingGlucoseMgDl.toInt()} mg/dL). Doctor consultation advised.';
        messageHi = '$relativeName का फास्टिंग शुगर स्तर बहुत अधिक है (${fastingGlucoseMgDl.toInt()} mg/dL)। चिकित्सक से संपर्क करें।';
      } else if (fastingGlucoseMgDl >= 126) {
        alertLevel = alertLevel == HealthAlertLevel.normal ? HealthAlertLevel.attentionNeeded : alertLevel;
        messageEn ??= '$relativeName\'s fasting glucose is elevated (${fastingGlucoseMgDl.toInt()} mg/dL). Consider post-meal walks.';
        messageHi ??= '$relativeName का शुगर स्तर सामान्य से अधिक है (${fastingGlucoseMgDl.toInt()} mg/dL)। भोजन के बाद हल्का टहलना लाभकारी रहेगा।';
      }
    }

    // Default normal message if all is stable
    if (alertLevel == HealthAlertLevel.normal) {
      messageEn = '$relativeName\'s vitals and daily activity are well within target ranges.';
      messageHi = '$relativeName के सभी स्वास्थ्य मानक पूर्णतः सामान्य और स्वस्थ हैं।';
    }

    return FamilyMemberHealth(
      id: id,
      userId: userId,
      relativeUserId: relativeUserId,
      relativeName: relativeName,
      relation: relation,
      age: age,
      latestSystolicBp: systolicBp,
      latestDiastolicBp: diastolicBp,
      latestFastingGlucoseMgDl: fastingGlucoseMgDl,
      todaySteps: todaySteps,
      alertLevel: alertLevel,
      alertMessage: messageEn,
      alertMessageHindi: messageHi,
      updatedAt: recordedAt,
    );
  }

  /// Create a cultural family blessing / care cheer
  FamilyBlessing createBlessing({
    required String id,
    required String senderId,
    required String senderName,
    required String recipientId,
    required String blessingType,
  }) {
    String hindiMsg;
    switch (blessingType.toLowerCase()) {
      case 'pranam':
        hindiMsg = 'सादर प्रणाम व स्वास्थ्य की मंगलकामनाएँ 🙏';
        break;
      case 'ashirwad':
        hindiMsg = 'सदा निरोगी और ऊर्जावान रहो! आशीर्वाद ✨';
        break;
      case 'chai cheer':
        hindiMsg = 'साथ में हर्बल काढ़ा/चाय का चीयर! ☕🌿';
        break;
      default:
        hindiMsg = 'आपके अच्छे स्वास्थ्य की हार्दिक प्रार्थना 🌸';
    }

    return FamilyBlessing(
      id: id,
      senderId: senderId,
      senderName: senderName,
      recipientId: recipientId,
      blessingType: blessingType,
      blessingHindi: hindiMsg,
      sentAt: DateTime.now(),
    );
  }
}
