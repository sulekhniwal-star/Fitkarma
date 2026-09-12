import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../domain/models/predictive_health_models.dart';
import '../../domain/services/biological_age_engine.dart';
import '../../domain/services/cardiometabolic_risk_engine.dart';
import '../../domain/services/injury_risk_engine.dart';
import '../../domain/services/stress_detection_engine.dart';
import 'clinical_lab_intelligence_screen.dart';
import 'medication_tracker_screen.dart';
import 'doctor_share_screen.dart';

class PredictiveHealthDashboardScreen extends StatefulWidget {
  final String userId;
  final int chronologicalAge;

  const PredictiveHealthDashboardScreen({
    super.key,
    this.userId = 'demo-user-001',
    this.chronologicalAge = 32,
  });

  @override
  State<PredictiveHealthDashboardScreen> createState() =>
      _PredictiveHealthDashboardScreenState();
}

class _PredictiveHealthDashboardScreenState
    extends State<PredictiveHealthDashboardScreen> {
  final _bioAgeEngine = const BiologicalAgeEngine();
  final _cardioEngine = const CardiometabolicRiskEngine();
  final _injuryEngine = const InjuryRiskEngine();
  final _stressEngine = const StressDetectionEngine();

  late BiologicalAgeEstimate _bioAge;
  late HealthRiskProfile _riskProfile;
  late InjuryRiskAssessment _injuryAssessment;
  late StressIndex _stressIndex;

  @override
  void initState() {
    super.initState();
    _bioAge = _bioAgeEngine.calculateBiologicalAge(
      id: 'bio-1',
      userId: widget.userId,
      chronologicalAge: widget.chronologicalAge,
      restingHeartRateBpm: 58.0,
      hrvRmsddMs: 68.0,
      bmi: 22.4, // Asian-Indian optimal
      systolicBp: 118.0,
      averageDailySteps: 10400,
      averageSleepHours: 7.8,
      calculatedAt: DateTime.now(),
    );

    _riskProfile = _cardioEngine.evaluateRisk(
      gender: 'male',
      age: widget.chronologicalAge,
      waistCircumferenceCm: 82.0,
      systolicBp: 118.0,
      diastolicBp: 78.0,
      fastingGlucoseMgDl: 92.0,
      triglyceridesMgDl: 110.0,
      hdlCholesterolMgDl: 54.0,
      totalCholesterolMgDl: 175.0,
    );

    _injuryAssessment = _injuryEngine.evaluateWorkloadRatio(
      past7DaysLoadKg: 18500,
      past28DaysLoadKg: 70000, // Weekly avg = 17500 => ACWR = 1.06 (Sweet Spot)
    );

    _stressEngine.evaluateStress(
      todayNocturnalHrvMs: 70.0,
      baselineHrvMs: 65.0,
      todayRestingHrBpm: 57.0,
      baselineRestingHrBpm: 59.0,
      sleepEfficiencyPct: 0.92,
    );
    _stressIndex = _stressEngine.evaluateStress(
      todayNocturnalHrvMs: 70.0,
      baselineHrvMs: 65.0,
      todayRestingHrBpm: 57.0,
      baselineRestingHrBpm: 59.0,
      sleepEfficiencyPct: 0.92,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: BilingualLabel(
          english: 'Predictive Health & Longevity OS',
          hindi: 'भविष्यवाणी स्वास्थ्य व दीर्घायु',
          primaryStyle: AppTypography.h3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded, color: AppColors.primaryCyan),
            tooltip: 'Doctor Share Portal',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DoctorShareScreen(userId: widget.userId)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Biological Age Hero Bento Card
            _buildBiologicalAgeHero(),
            const SizedBox(height: 16),

            // 2. Quick Navigation Shortcut Bento
            _buildNavigationGrid(),
            const SizedBox(height: 16),

            // 3. 10-Year Cardiometabolic Risk & MetSyn Shield
            _buildCardioRiskCard(),
            const SizedBox(height: 16),

            // 4. ACWR Injury Risk & Recovery Stress Grid
            Row(
              children: [
                Expanded(child: _buildAcwrCard()),
                const SizedBox(width: 12),
                Expanded(child: _buildStressCard()),
              ],
            ),
            const SizedBox(height: 16),

            // 5. Itemized Biomarker Age Modifiers
            Text('Biomarker Age Impact Contributors', style: AppTypography.h3),
            const SizedBox(height: 12),
            _buildContributorsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBiologicalAgeHero() {
    final deltaYears = _bioAge.ageDelta;
    final isYounger = deltaYears <= 0;

    return BentoCard(
      isGlowing: true,
      glowColor: isYounger ? AppColors.primaryEmerald : AppColors.accentAmber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BIOLOGICAL AGE', style: AppTypography.label.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${_bioAge.biologicalAge}', style: AppTypography.heroMetric.copyWith(color: AppColors.primaryEmerald, fontSize: 44)),
                      const SizedBox(width: 6),
                      Text('years', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: (isYounger ? AppColors.primaryEmerald : AppColors.accentAmber).withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isYounger ? AppColors.primaryEmerald : AppColors.accentAmber),
                ),
                child: Text(
                  isYounger ? '${deltaYears.abs()} yrs YOUNGER ✨' : '${deltaYears} yrs OLDER ⚠️',
                  style: AppTypography.label.copyWith(
                    color: isYounger ? AppColors.primaryEmerald : AppColors.accentAmber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderGlass),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primaryCyan, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _bioAge.topImprovementAction,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }

  Widget _buildNavigationGrid() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ClinicalLabIntelligenceScreen(userId: widget.userId)),
              );
            },
            child: BentoCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.science_outlined, color: AppColors.primaryCyan, size: 24),
                  const SizedBox(height: 8),
                  Text('Lab Diagnostics', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text('HbA1c, Lipids, Vits', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MedicationTrackerScreen(userId: widget.userId)),
              );
            },
            child: BentoCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.medication_outlined, color: AppColors.accentAmber, size: 24),
                  const SizedBox(height: 8),
                  Text('Medication OS', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text('Timing & Food Alerts', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardioRiskCard() {
    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.monitor_heart_outlined, color: AppColors.primaryEmerald, size: 22),
                  const SizedBox(width: 8),
                  Text('Cardiometabolic 10-Yr Risk', style: AppTypography.h3.copyWith(fontSize: 16)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('LOW RISK (${_riskProfile.tenYearCardioRiskPercent}%)', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Metabolic Syndrome Shield: 0/5 criteria met. Asian-Indian waist circumference and glycemic biomarkers are optimal.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAcwrCard() {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ACWR INJURY METER', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${_injuryAssessment.acwr}', style: AppTypography.h2.copyWith(color: AppColors.primaryCyan)),
              const SizedBox(width: 4),
              const Icon(Icons.verified_rounded, size: 16, color: AppColors.primaryEmerald),
            ],
          ),
          const SizedBox(height: 4),
          Text('Sweet Spot (0.8–1.3)', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryEmerald)),
        ],
      ),
    );
  }

  Widget _buildStressCard() {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AUTONOMIC STRESS', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${_stressIndex.score.toInt()}/100', style: AppTypography.h2.copyWith(color: AppColors.primaryEmerald)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Restored & Parasympathetic', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryEmerald)),
        ],
      ),
    );
  }

  Widget _buildContributorsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bioAge.contributors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final c = _bioAge.contributors[index];
        final isProt = c.isProtective;

        return BentoCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.markerName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text(c.status, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isProt ? AppColors.primaryEmerald : AppColors.accentAmber).withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${isProt ? '-' : '+'}${c.impactYears.abs().toStringAsFixed(1)} yrs',
                  style: AppTypography.label.copyWith(
                    color: isProt ? AppColors.primaryEmerald : AppColors.accentAmber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
