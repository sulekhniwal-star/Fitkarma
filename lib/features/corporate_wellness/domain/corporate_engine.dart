import 'corporate_models.dart';

/// Pure Dart Deterministic Engine for Corporate Wellness Analytics,
/// IRDAI-Compliant Dynamic Health Insurance Premium Rebates, and Ergonomic Alerts.
class CorporateEngine {
  const CorporateEngine();

  /// Calculates dynamic annual health insurance premium discount according to IRDAI guidelines
  InsurerPremiumRebate calculateInsurerRebate({
    required InsurerPartner insurer,
    required String policyNumber,
    required double baseAnnualPremiumInr,
    required double averageDailySteps,
    required double longevityScore,
    required double shatapadiAdherencePercentage,
    required int monthlyActiveDays,
  }) {
    double discountPercentage = 0.0;

    // 1. Physical Movement & Step Cadence (up to 10%)
    if (averageDailySteps >= 10000) {
      discountPercentage += 10.0;
    } else if (averageDailySteps >= 8000) {
      discountPercentage += 7.5;
    } else if (averageDailySteps >= 6000) {
      discountPercentage += 4.5;
    } else {
      discountPercentage += 2.0;
    }

    // 2. Longevity Score & Biological Age Trajectory (up to 8%)
    if (longevityScore >= 85.0) {
      discountPercentage += 8.0;
    } else if (longevityScore >= 75.0) {
      discountPercentage += 5.5;
    } else if (longevityScore >= 60.0) {
      discountPercentage += 3.0;
    }

    // 3. Post-Meal Shatapadi Glycemic Protection (up to 5%)
    if (shatapadiAdherencePercentage >= 80.0) {
      discountPercentage += 5.0;
    } else if (shatapadiAdherencePercentage >= 60.0) {
      discountPercentage += 3.0;
    }

    // 4. Monthly Exercise Consistency (up to 7%)
    if (monthlyActiveDays >= 20) {
      discountPercentage += 7.0;
    } else if (monthlyActiveDays >= 14) {
      discountPercentage += 4.5;
    } else if (monthlyActiveDays >= 8) {
      discountPercentage += 2.0;
    }

    // Clamp by insurer max allowable discount
    final finalDiscountPercent = discountPercentage.clamp(0.0, insurer.maxDiscountPercent);
    final annualSavings = (baseAnnualPremiumInr * (finalDiscountPercent / 100.0));

    final InsurerRiskTier riskTier;
    if (finalDiscountPercent >= (insurer.maxDiscountPercent * 0.75)) {
      riskTier = InsurerRiskTier.preferredElite;
    } else if (finalDiscountPercent >= (insurer.maxDiscountPercent * 0.45)) {
      riskTier = InsurerRiskTier.standardPrime;
    } else {
      riskTier = InsurerRiskTier.elevatedRisk;
    }

    // Deterministic certificate ID
    final certId = 'IRDAI-FK-${policyNumber.replaceAll(RegExp(r'[^A-Z0-9]'), '')}-2026';

    return InsurerPremiumRebate(
      insurer: insurer,
      policyNumber: policyNumber,
      baseAnnualPremiumInr: baseAnnualPremiumInr,
      calculatedDiscountPercentage: double.parse(finalDiscountPercent.toStringAsFixed(1)),
      annualSavingsInr: double.parse(annualSavings.toStringAsFixed(0)),
      riskTier: riskTier,
      requiredMonthlyActiveDays: 20,
      completedActiveDays: monthlyActiveDays,
      renewalDiscountCertificateId: certId,
    );
  }

  /// Generates 6-digit corporate verification OTP for work email
  String generateWorkEmailOtp(String workEmail) {
    int hash = 5381;
    for (int i = 0; i < workEmail.length; i++) {
      hash = ((hash << 5) + hash) + workEmail.codeUnitAt(i);
    }
    final int otp = (hash.abs() % 900000) + 100000;
    return otp.toString();
  }

  /// Verifies work email OTP
  bool verifyWorkEmailOtp({required String enteredOtp, required String expectedOtp}) {
    return enteredOtp.trim() == expectedOtp.trim();
  }

  /// Evaluates workplace sedentary duration and generates ergonomic micro-alerts
  List<ErgonomicAlert> evaluateWorkplaceErgonomics({
    required int continuousDeskMinutes,
    required int dailyScreenTimeHours,
  }) {
    final List<ErgonomicAlert> alerts = [];

    // 1. Sedentary Cervical & Lumbar Alert
    if (continuousDeskMinutes >= 50) {
      alerts.add(
        const ErgonomicAlert(
          title: '50-Min Desk Sedentary Warning',
          regionalTitle: '५० मिनट निरंतर बैठक चेतावनी',
          actionPrompt: 'Stand up, perform 10 shoulder rolls, and do 20 seconds of spinal rotation.',
          regionalActionPrompt: 'उठें, कंधे घुमाएं व २० सेकंड रीढ़ का खिंचाव करें।',
          recommendedBreakSeconds: 120,
        ),
      );
    }

    // 2. 20-20-20 Eye Rest & Screen Glare Alert
    if (dailyScreenTimeHours >= 4) {
      alerts.add(
        const ErgonomicAlert(
          title: '20-20-20 Eye Rest Protocol',
          regionalTitle: '२०-२०-२० नेत्र विश्राम प्रोटोकॉल',
          actionPrompt: 'Look at an object 20 feet away for 20 seconds to relax ciliary eye muscles.',
          regionalActionPrompt: '२० फीट दूर किसी वस्तु पर २० सेकंड दृष्टि केंद्रित करें।',
          recommendedBreakSeconds: 20,
        ),
      );
    }

    // 3. Post-Lunch Workplace Shatapadi
    alerts.add(
      const ErgonomicAlert(
        title: 'Office Corridor Shatapadi Walk',
        regionalTitle: 'कार्यालय शतपावली स्मरण',
        actionPrompt: 'Take a brisk 5-minute walk around your office floor or campus after your meal.',
        regionalActionPrompt: 'भोजनोपरांत ५ मिनट कार्यालय परिसर में टहलें।',
        recommendedBreakSeconds: 300,
      ),
    );

    return alerts;
  }
}
