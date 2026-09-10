import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/corporate_wellness/domain/corporate_engine.dart';
import 'package:fitkarma/features/corporate_wellness/domain/corporate_models.dart';
import 'package:fitkarma/features/corporate_wellness/providers/corporate_provider.dart';

void main() {
  group('CorporateEngine Deterministic Tests', () {
    const engine = CorporateEngine();

    test('Computes optimal IRDAI dynamic premium discount & maximum savings',
        () {
      final rebate = engine.calculateInsurerRebate(
        insurer: InsurerPartner.hdfcErgo,
        policyNumber: 'HE-FIT-884920',
        baseAnnualPremiumInr: 24000.0,
        averageDailySteps: 11000.0,
        longevityScore: 88.0,
        shatapadiAdherencePercentage: 85.0,
        monthlyActiveDays: 22,
      );

      expect(rebate.calculatedDiscountPercentage, greaterThanOrEqualTo(24.0));
      expect(rebate.annualSavingsInr, greaterThan(5000.0));
      expect(rebate.riskTier, equals(InsurerRiskTier.preferredElite));
      expect(rebate.renewalDiscountCertificateId, contains('IRDAI-FK'));
    });

    test('Caps rebate percentage to insurer maximum allowable threshold', () {
      final rebate = engine.calculateInsurerRebate(
        insurer: InsurerPartner.iciciLombard, // Max discount: 20%
        policyNumber: 'ICICI-FIT-123456',
        baseAnnualPremiumInr: 30000.0,
        averageDailySteps: 15000.0,
        longevityScore: 95.0,
        shatapadiAdherencePercentage: 95.0,
        monthlyActiveDays: 28,
      );

      expect(rebate.calculatedDiscountPercentage, equals(20.0));
      expect(rebate.annualSavingsInr, equals(6000.0));
    });

    test('Generates deterministic corporate work email OTP and verifies', () {
      final otp = engine.generateWorkEmailOtp('rahul.s@tcs.com');
      expect(otp.length, equals(6));
      expect(
          engine.verifyWorkEmailOtp(enteredOtp: otp, expectedOtp: otp), isTrue);
      expect(engine.verifyWorkEmailOtp(enteredOtp: '000000', expectedOtp: otp),
          isFalse);
    });

    test('Evaluates workplace desk strain and triggers ergonomic alerts', () {
      final alerts = engine.evaluateWorkplaceErgonomics(
        continuousDeskMinutes: 55,
        dailyScreenTimeHours: 5,
      );

      expect(alerts.length, equals(3));
      expect(alerts.any((a) => a.title.contains('Desk Sedentary')), isTrue);
      expect(alerts.any((a) => a.title.contains('20-20-20')), isTrue);
      expect(alerts.any((a) => a.title.contains('Shatapadi')), isTrue);
    });
  });

  group('CorporateWellnessNotifier State Tests', () {
    test('Handles work email verification flow and insurer policy updates', () {
      final notifier = CorporateWellnessNotifier();
      expect(notifier.state.employeeProfile.isVerified, isTrue);
      expect(notifier.state.teamChallenges.length, equals(2));

      // Initiate work email verification
      notifier.initiateWorkEmailVerification(
          'priya@infosys.com', 'Infosys Ltd', 'Product');
      expect(notifier.state.employeeProfile.verificationStatus,
          equals(CorporateVerificationStatus.pendingWorkEmailOtp));
      expect(notifier.state.pendingOtp, isNotNull);

      final otp = notifier.state.pendingOtp!;
      final verified = notifier.verifyOtp(otp);
      expect(verified, isTrue);
      expect(notifier.state.employeeProfile.isVerified, isTrue);
      expect(notifier.state.employeeProfile.workEmail,
          equals('priya@infosys.com'));

      // Link Insurer Policy
      notifier.linkInsurerPolicy(
        insurer: InsurerPartner.starHealth,
        policyNumber: 'STAR-FIT-990011',
        baseAnnualPremium: 28000.0,
      );
      expect(notifier.state.insurerRebate.insurer,
          equals(InsurerPartner.starHealth));
      expect(
          notifier.state.insurerRebate.policyNumber, equals('STAR-FIT-990011'));
      expect(
          notifier.state.insurerRebate.annualSavingsInr, greaterThan(6000.0));

      // Unlink
      notifier.unlinkCorporate();
      expect(notifier.state.employeeProfile.verificationStatus,
          equals(CorporateVerificationStatus.unlinked));
    });
  });
}
