import '../models/predictive_health_models.dart';

class ClinicalLabIntelligenceEngine {
  const ClinicalLabIntelligenceEngine();

  /// Interprets individual raw biomarker and evaluates status relative to standard reference ranges
  LabBiomarkerResult evaluateBiomarker({
    required String markerKey,
    required String name,
    required String nameHindi,
    required double value,
    required String unit,
    required double referenceMin,
    required double referenceMax,
    bool lowerIsBetter = true,
  }) {
    LabMarkerStatus status;
    String interp;
    String interpHi;

    if (value >= referenceMin && value <= referenceMax) {
      status = LabMarkerStatus.optimal;
      interp = '$name is optimal ($value $unit), well within healthy reference parameters.';
      interpHi = '$name का स्तर सामान्य और स्वस्थ सीमा ($value $unit) में है।';
    } else if (value > referenceMax) {
      final excess = value - referenceMax;
      if (excess > (referenceMax * 0.35)) {
        status = LabMarkerStatus.critical;
        interp = '$name is significantly elevated ($value $unit). Medical consultation strongly advised.';
        interpHi = '$name अत्यधिक बढ़ा हुआ है ($value $unit)। डॉक्टर से सलाह लें।';
      } else {
        status = LabMarkerStatus.borderline;
        interp = '$name is slightly above ideal reference range ($value $unit). Lifestyle & dietary adjustments recommended.';
        interpHi = '$name सामान्य से थोड़ा अधिक है ($value $unit)। आहार में सुधार करें।';
      }
    } else {
      final deficit = referenceMin - value;
      if (deficit > (referenceMin * 0.40)) {
        status = LabMarkerStatus.critical;
        interp = '$name is severely low ($value $unit). Supplementation/consultation recommended.';
        interpHi = '$name अत्यधिक कम है ($value $unit)। सप्लीमेंट व परामर्श आवश्यक है।';
      } else {
        status = LabMarkerStatus.borderline;
        interp = '$name is slightly below optimal range ($value $unit).';
        interpHi = '$name सामान्य से थोड़ा कम है ($value $unit)।';
      }
    }

    return LabBiomarkerResult(
      markerKey: markerKey,
      name: name,
      nameHindi: nameHindi,
      value: value,
      unit: unit,
      referenceMin: referenceMin,
      referenceMax: referenceMax,
      status: status,
      interpretation: interp,
      interpretationHindi: interpHi,
    );
  }

  /// Synthesizes comprehensive lab panel analysis and executive summary
  ClinicalLabReport analyzeLabReport({
    required String id,
    required String userId,
    required String labName,
    required DateTime testDate,
    required List<LabBiomarkerResult> results,
    required DateTime uploadedAt,
  }) {
    final abnormalCount = results.where((r) => r.status == LabMarkerStatus.abnormal || r.status == LabMarkerStatus.critical).length;
    final borderlineCount = results.where((r) => r.status == LabMarkerStatus.borderline).length;

    String summary;
    String summaryHi;

    if (abnormalCount == 0 && borderlineCount == 0) {
      summary = 'All tested biomarkers are in the optimal physiological range. Excellent metabolic and cardiovascular health.';
      summaryHi = 'सभी टेस्ट किए गए बायोमार्कर्स पूर्णतः सामान्य सीमा में हैं। आपका स्वास्थ्य उत्कृष्ट है।';
    } else if (abnormalCount > 0) {
      summary = '$abnormalCount biomarker(s) require clinical review and targeted lifestyle intervention.';
      summaryHi = '$abnormalCount बायोमार्कर में असंतुलन पाया गया है। आहार सुधार और डॉक्टर परामर्श की सलाह दी जाती है।';
    } else {
      summary = '$borderlineCount biomarker(s) are borderline. Early dietary & physical activity optimizations can restore optimal levels.';
      summaryHi = '$borderlineCount बायोमार्कर सीमा रेखा पर हैं। दैनिक जीवनशैली में छोटे सुधारों से इन्हें सामान्य किया जा सकता है।';
    }

    return ClinicalLabReport(
      id: id,
      userId: userId,
      labName: labName,
      testDate: testDate,
      results: results,
      executiveSummary: summary,
      executiveSummaryHindi: summaryHi,
      uploadedAt: uploadedAt,
    );
  }
}
