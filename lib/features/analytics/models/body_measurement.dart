/// Body Measurement Log Model
class BodyMeasurementLog {
  final DateTime date;
  final double waistCm;
  final double chestCm;
  final double armsCm;
  final double thighsCm;

  const BodyMeasurementLog({
    required this.date,
    required this.waistCm,
    required this.chestCm,
    required this.armsCm,
    required this.thighsCm,
  });
}
