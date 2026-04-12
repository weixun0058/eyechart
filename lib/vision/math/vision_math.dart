import 'dart:math' as math;

import '../domain/vision_models.dart';

class VisionMath {
  const VisionMath._();

  static double marFromLogMar(double logMar) {
    return math.pow(10, logMar).toDouble();
  }

  static double logMarFromMar(double marArcmin) {
    _requirePositive(marArcmin, 'marArcmin');
    return _log10(marArcmin);
  }

  static double decimalFromLogMar(double logMar) {
    return math.pow(10, -logMar).toDouble();
  }

  static double logMarFromDecimal(double decimalAcuity) {
    _requirePositive(decimalAcuity, 'decimalAcuity');
    return -_log10(decimalAcuity);
  }

  static double fivePointFromLogMar(double logMar) {
    return 5.0 - logMar;
  }

  static double logMarFromFivePoint(double fivePointAcuity) {
    return 5.0 - fivePointAcuity;
  }

  static double fivePointFromDecimal(double decimalAcuity) {
    return fivePointFromLogMar(logMarFromDecimal(decimalAcuity));
  }

  static double decimalFromFivePoint(double fivePointAcuity) {
    return decimalFromLogMar(logMarFromFivePoint(fivePointAcuity));
  }

  static double arcminToRad(double arcmin) {
    return arcmin * math.pi / 10800;
  }

  static double detailAngleArcminFromLogMar(double logMar) {
    return marFromLogMar(logMar);
  }

  static double optotypeAngleArcminFromLogMar(double logMar) {
    return detailAngleArcminFromLogMar(logMar) * 5;
  }

  static double optotypeSizeMm({
    required double logMar,
    required double testDistanceMm,
  }) {
    _requirePositive(testDistanceMm, 'testDistanceMm');
    final angleRad = arcminToRad(optotypeAngleArcminFromLogMar(logMar));
    return 2 * testDistanceMm * math.tan(angleRad / 2);
  }

  static double detailSizeMm({
    required double logMar,
    required double testDistanceMm,
  }) {
    return optotypeSizeMm(
          logMar: logMar,
          testDistanceMm: testDistanceMm,
        ) /
        5;
  }

  static AcuityLevel createAcuityLevel(double logMar) {
    final marArcmin = marFromLogMar(logMar);
    return AcuityLevel(
      logMar: logMar,
      marArcmin: marArcmin,
      decimalAcuity: decimalFromLogMar(logMar),
      fivePointAcuity: fivePointFromLogMar(logMar),
      optotypeAngleArcmin: marArcmin * 5,
      detailAngleArcmin: marArcmin,
    );
  }

  static RenderMetrics calculateRenderMetrics({
    required double logMar,
    required double testDistanceMm,
    required ScreenProfile screenProfile,
    double minCriticalDetailPx = 3.0,
  }) {
    final optotypeMm = optotypeSizeMm(
      logMar: logMar,
      testDistanceMm: testDistanceMm,
    );
    final detailMm = optotypeMm / 5;
    final optotypeWidthPx = optotypeMm / screenProfile.pixelWidthMm;
    final optotypeHeightPx = optotypeMm / screenProfile.pixelHeightMm;
    final detailWidthPx = detailMm / screenProfile.pixelWidthMm;
    final detailHeightPx = detailMm / screenProfile.pixelHeightMm;
    final criticalDetailPx = math.min(detailWidthPx, detailHeightPx);

    return RenderMetrics(
      testDistanceMm: testDistanceMm,
      optotypeSizeMm: optotypeMm,
      detailSizeMm: detailMm,
      optotypeWidthPx: optotypeWidthPx,
      optotypeHeightPx: optotypeHeightPx,
      detailWidthPx: detailWidthPx,
      detailHeightPx: detailHeightPx,
      criticalDetailPx: criticalDetailPx,
      pixelLimitReached: criticalDetailPx < minCriticalDetailPx,
    );
  }

  static double minimumTestDistanceMm({
    required double logMar,
    required ScreenProfile screenProfile,
    double minCriticalDetailPx = 1.0,
  }) {
    _requirePositive(minCriticalDetailPx, 'minCriticalDetailPx');
    final requiredDetailMm =
        math.max(screenProfile.pixelWidthMm, screenProfile.pixelHeightMm) *
        minCriticalDetailPx;
    final detailAngleRad = arcminToRad(detailAngleArcminFromLogMar(logMar));
    return requiredDetailMm / (2 * math.tan(detailAngleRad / 2));
  }

  static bool isPixelLimitReached(
    RenderMetrics metrics,
    double minCriticalDetailPx,
  ) {
    return metrics.criticalDetailPx < minCriticalDetailPx;
  }

  static double mean(Iterable<double> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError.value(values, 'values', '不能为空');
    }

    final sum = list.reduce((a, b) => a + b);
    return sum / list.length;
  }

  static double median(Iterable<double> values) {
    final list = values.toList(growable: false)..sort();
    if (list.isEmpty) {
      throw ArgumentError.value(values, 'values', '不能为空');
    }

    final middleIndex = list.length ~/ 2;
    if (list.length.isOdd) {
      return list[middleIndex];
    }

    return (list[middleIndex - 1] + list[middleIndex]) / 2;
  }

  static double standardDeviation(Iterable<double> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError.value(values, 'values', '不能为空');
    }

    if (list.length == 1) {
      return 0;
    }

    final avg = mean(list);
    final squaredDiffSum = list
        .map((value) => math.pow(value - avg, 2).toDouble())
        .reduce((a, b) => a + b);

    return math.sqrt(squaredDiffSum / list.length);
  }

  static double _log10(double value) {
    return math.log(value) / math.ln10;
  }

  static void _requirePositive(double value, String name) {
    if (value <= 0) {
      throw ArgumentError.value(value, name, '必须大于 0');
    }
  }
}
