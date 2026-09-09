import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/deepened_environmental_models.dart';
import '../domain/environmental_health_engine.dart';
import '../providers/deepened_environmental_provider.dart';

/// Screen displaying Deepened Environmental Health, Multi-Pollutant Speciation,
/// Cardiopulmonary Respiratory Stress, WBGT Thermal Strain, and Ayurvedic Ritu-Charya.
class DeepenedEnvironmentalScreen extends ConsumerWidget {
  const DeepenedEnvironmentalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(deepenedEnvironmentalProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Environmental Health OS',
          regionalText: 'गहन पर्यावरण व ऋतुचर्या स्वास्थ्य प्रणाली',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.karmaGreen),
            tooltip: 'Simulate Atmospheric Conditions',
            onPressed: () => _showAtmosphericSimulationModal(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Environmental Safety & Advisory Card
            _buildHeroSafetyCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Multi-Pollutant Speciation Grid Card
            _buildPollutantSpeciationCard(report.pollutants),
            const SizedBox(height: AppSpacing.md),

            // 3. Cardiopulmonary Exercise Stress & Training Mode Card
            _buildPulmonaryStressCard(report.pulmonaryStress),
            const SizedBox(height: AppSpacing.md),

            // 4. WBGT Thermal Strain & Electrolyte Loss Card
            _buildThermalStrainCard(report.thermalStrain),
            const SizedBox(height: AppSpacing.md),

            // 5. Ayurvedic Ritu-Charya Bioclimatic Guidance Card
            _buildRituCharyaCard(report.rituCharya),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSafetyCard(DeepenedEnvironmentalReport report) {
    final Color aqiColor = _getAqiColor(report.baseSnapshot.aqiCategory);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Atmospheric Safety Index',
                regionalText: 'पर्यावरणीय सुरक्षा व वायु गुणवत्ता',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: aqiColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: aqiColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'AQI ${report.baseSnapshot.aqi} • ${_getAqiLabel(report.baseSnapshot.aqiCategory)}',
                  style: TextStyle(
                    color: aqiColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: GlowingMetric(
                  value: report.environmentalSafetyIndex.toStringAsFixed(0),
                  unit: '/ 100',
                  label: 'Safety Score',
                  accentColor: report.environmentalSafetyIndex >= 75
                      ? AppColors.karmaGreen
                      : (report.environmentalSafetyIndex >= 50 ? AppColors.energyOrange : AppColors.alertRed),
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.surfaceElevated),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${report.baseSnapshot.temperatureC.toStringAsFixed(1)}°C | ${report.baseSnapshot.humidityPercent.toInt()}% Humidity',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'UV Index: ${report.baseSnapshot.uvIndex.toStringAsFixed(1)} (${report.baseSnapshot.uvCategory.name.toUpperCase()})',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      'Heat Index: ${report.baseSnapshot.heatIndexC.toStringAsFixed(1)}°C',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.focusBlue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withValues(alpha: 0.6),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              report.primaryActionAdvisory,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantSpeciationCard(PollutantBreakdown pollutants) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Multi-Pollutant Speciation (CPCB)',
                regionalText: 'वायु प्रदूषक घटक विश्लेषण',
              ),
              Icon(Icons.air, color: AppColors.focusBlue, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Granular chemical speciation tracking alveolar penetration and respiratory irritants.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildPollutantTile(
                name: 'PM 2.5',
                value: '${pollutants.pm25} µg/m³',
                status: pollutants.pm25 <= 30.0 ? 'Optimal' : (pollutants.pm25 <= 60.0 ? 'Moderate' : 'Unhealthy'),
                isSafe: pollutants.pm25 <= 60.0,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildPollutantTile(
                name: 'PM 10',
                value: '${pollutants.pm10} µg/m³',
                status: pollutants.pm10 <= 60.0 ? 'Optimal' : (pollutants.pm10 <= 100.0 ? 'Moderate' : 'Elevated'),
                isSafe: pollutants.pm10 <= 100.0,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildPollutantTile(
                name: 'NO₂ (Traffic)',
                value: '${pollutants.no2} ppb',
                status: pollutants.no2 <= 40.0 ? 'Normal' : 'Elevated',
                isSafe: pollutants.no2 <= 40.0,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildPollutantTile(
                name: 'Ozone (O₃)',
                value: '${pollutants.o3} ppb',
                status: pollutants.o3 <= 50.0 ? 'Low' : 'Oxidative',
                isSafe: pollutants.o3 <= 70.0,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _buildPollutantTile(
                name: 'SO₂ (Industrial)',
                value: '${pollutants.so2} ppb',
                status: pollutants.so2 <= 20.0 ? 'Safe' : 'Elevated',
                isSafe: pollutants.so2 <= 20.0,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildPollutantTile(
                name: 'CO (Carbon Monoxide)',
                value: '${pollutants.co} ppm',
                status: pollutants.co <= 2.0 ? 'Normal' : 'High',
                isSafe: pollutants.co <= 2.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantTile({
    required String name,
    required String value,
    required String status,
    required bool isSafe,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withValues(alpha: 0.4),
          borderRadius: AppRadii.radiusSm,
          border: Border.all(
            color: isSafe ? AppColors.glassBorder : AppColors.energyOrange.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: isSafe ? AppColors.karmaGreen : AppColors.energyOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulmonaryStressCard(CardioPulmonaryStressIndex stress) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Cardiopulmonary Exercise Clearance',
                regionalText: 'हृदय व श्वसन व्यायाम सुरक्षा स्तर',
              ),
              if (stress.hasThermalInversionWarning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.alertRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'Smog Inversion',
                    style: TextStyle(color: AppColors.alertRed, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated.withValues(alpha: 0.4),
                    borderRadius: AppRadii.radiusSm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Exercise Mode', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      const SizedBox(height: 2),
                      Text(
                        stress.recommendedMode.label,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated.withValues(alpha: 0.4),
                    borderRadius: AppRadii.radiusSm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Inhaled PM2.5 / Hr', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      const SizedBox(height: 2),
                      Text(
                        '${stress.inhaledPm25MicrogramsPerHour} µg',
                        style: TextStyle(
                          color: stress.inhaledPm25MicrogramsPerHour > 150.0 ? AppColors.alertRed : AppColors.focusBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated.withValues(alpha: 0.4),
                    borderRadius: AppRadii.radiusSm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mask Protection', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      const SizedBox(height: 2),
                      Text(
                        stress.maskTier.label.split(' ').first,
                        style: TextStyle(
                          color: stress.maskTier == ProtectiveMaskTier.none ? AppColors.karmaGreen : AppColors.energyOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withValues(alpha: 0.6),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              stress.clinicalRationale,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThermalStrainCard(ThermalStrainIndex thermal) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Thermal Strain & Electrolyte Loss',
                regionalText: 'तापीय प्रभाव व लवण ह्रास अनुमान',
              ),
              Icon(Icons.thermostat, color: AppColors.energyOrange, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildThermalMetric(
                  title: 'WBGT Index',
                  value: '${thermal.wbgtCelsius}°C',
                  isWarning: thermal.wbgtCelsius >= 28.0,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildThermalMetric(
                  title: 'Sweat Loss / Hr',
                  value: '${thermal.estimatedSweatLossPerHourMl.toInt()} mL',
                  isWarning: thermal.estimatedSweatLossPerHourMl >= 1200,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildThermalMetric(
                  title: 'Na+ Deficit',
                  value: '${thermal.sodiumLossMg} mg',
                  isWarning: thermal.sodiumLossMg >= 1000,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withValues(alpha: 0.6),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              thermal.heatIllnessRisk,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThermalMetric({
    required String title,
    required String value,
    required bool isWarning,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.4),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(
          color: isWarning ? AppColors.energyOrange.withValues(alpha: 0.4) : AppColors.glassBorder,
        ),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? AppColors.energyOrange : AppColors.karmaGreen,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRituCharyaCard(RituCharyaGuidance ritu) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'Ritu-Charya: ${ritu.season.name}',
                regionalText: ritu.season.regionalName,
              ),
              const Icon(Icons.eco, color: AppColors.karmaGreen, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Dosha Dynamic: ${ritu.season.doshaDynamic}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.focusBlue, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRituFeatureRow(
            icon: Icons.schedule,
            label: 'Workout Window',
            description: ritu.recommendedWorkoutWindow,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRituFeatureRow(
            icon: Icons.local_pharmacy_outlined,
            label: 'Respiratory Shield',
            description: ritu.herbalRespiratoryShield,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRituFeatureRow(
            icon: Icons.water_drop_outlined,
            label: 'Electrolyte Formula',
            description: ritu.hydrationElectrolyteFormula,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRituFeatureRow(
            icon: Icons.self_improvement,
            label: 'Airway Rejuvenation',
            description: ritu.postExposureAirwayCare,
          ),
        ],
      ),
    );
  }

  Widget _buildRituFeatureRow({
    required IconData icon,
    required String label,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.3),
        borderRadius: AppRadii.radiusSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAqiColor(AqiCategory cat) {
    switch (cat) {
      case AqiCategory.good:
        return AppColors.karmaGreen;
      case AqiCategory.satisfactory:
        return AppColors.focusBlue;
      case AqiCategory.moderate:
        return AppColors.energyOrange;
      case AqiCategory.poor:
        return const Color(0xFFFF7043);
      case AqiCategory.veryPoor:
        return AppColors.alertRed;
      case AqiCategory.severe:
        return const Color(0xFFD50000);
    }
  }

  String _getAqiLabel(AqiCategory cat) {
    switch (cat) {
      case AqiCategory.good:
        return 'Good';
      case AqiCategory.satisfactory:
        return 'Satisfactory';
      case AqiCategory.moderate:
        return 'Moderate';
      case AqiCategory.poor:
        return 'Poor';
      case AqiCategory.veryPoor:
        return 'Very Poor';
      case AqiCategory.severe:
        return 'Severe';
    }
  }

  void _showAtmosphericSimulationModal(BuildContext context, WidgetRef ref) {
    int simAqi = 135;
    double simTemp = 28.5;
    double simHumidity = 58.0;
    double simUv = 5.5;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Simulate Environment',
                        regionalText: 'पर्यावरणीय परिस्थिति सिमुलेशन',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSlider(
                    label: 'Air Quality Index (AQI): $simAqi',
                    value: simAqi.toDouble(),
                    min: 20.0,
                    max: 450.0,
                    onChanged: (val) => setState(() => simAqi = val.toInt()),
                  ),
                  _buildSlider(
                    label: 'Temperature: ${simTemp.toStringAsFixed(1)}°C',
                    value: simTemp,
                    min: 5.0,
                    max: 48.0,
                    onChanged: (val) => setState(() => simTemp = val),
                  ),
                  _buildSlider(
                    label: 'Relative Humidity: ${simHumidity.toInt()}%',
                    value: simHumidity,
                    min: 15.0,
                    max: 95.0,
                    onChanged: (val) => setState(() => simHumidity = val),
                  ),
                  _buildSlider(
                    label: 'UV Radiation Index: ${simUv.toStringAsFixed(1)}',
                    value: simUv,
                    min: 0.0,
                    max: 14.0,
                    onChanged: (val) => setState(() => simUv = val),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.karmaGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                      ),
                      onPressed: () {
                        ref.read(deepenedEnvironmentalProvider.notifier).updateAtmosphericReadings(
                              aqi: simAqi,
                              uvIndex: simUv,
                              temperatureC: simTemp,
                              humidityPercent: simHumidity,
                            );
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Apply Simulation',
                        style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.karmaGreen,
          inactiveColor: AppColors.surfaceElevated,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BilingualLabel(
              primaryText: 'Environmental Health Science',
              regionalText: 'पर्यावरणीय स्वास्थ्य व ऋतुचर्या दर्शन',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'FitKarma\'s Deepened Environmental Health OS dynamically models pollutant speciation (PM2.5, PM10, NO2, O3) and evaluates real-time cardiopulmonary burden during physical exercise. It detects winter thermal inversion smog traps and integrates the 6 classical Indian Ayurvedic seasons (Ritu-Charya) with calibrated herbal respiratory shields and electrolyte rehydration formulas.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
