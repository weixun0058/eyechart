import '../vision/domain/vision_models.dart';
import '../vision/domain/vision_enums.dart';

enum ConfidenceLevel {
  high,
  medium,
  low,
}

class ConfidenceAssessment {
  final ConfidenceLevel level;
  final String description;
  final String recommendation;
  final List<String> factors;

  const ConfidenceAssessment({
    required this.level,
    required this.description,
    required this.recommendation,
    required this.factors,
  });
}

class ResultInterpreter {
  static ConfidenceAssessment assessConfidence(EyeTestResult result) {
    final factors = <String>[];

    if (result.totalQuestions < 5) {
      factors.add('测试题量较少（${result.totalQuestions}题）');
    }

    if (result.accuracy < 0.6) {
      factors.add('正确率偏低（${(result.accuracy * 100).toStringAsFixed(1)}%）');
    }

    if (result.lineReversals.length >= 2) {
      final logMarValues = result.lineReversals.map((r) => r.logMar).toList();
      final range = logMarValues.reduce((a, b) => a > b ? a : b) -
          logMarValues.reduce((a, b) => a < b ? a : b);
      if (range > 0.3) {
        factors.add('行级反转波动较大');
      }
    }

    if (result.pixelLimitEncountered) {
      factors.add('测试受屏幕像素限制');
    }

    if (result.meanResponseTimeMs < 1000) {
      factors.add('答题速度过快');
    }

    final level = _determineConfidenceLevel(result, factors);
    final description = _getConfidenceDescription(level);
    final recommendation = _getRecommendation(level, result);

    return ConfidenceAssessment(
      level: level,
      description: description,
      recommendation: recommendation,
      factors: factors,
    );
  }

  static ConfidenceLevel _determineConfidenceLevel(
    EyeTestResult result,
    List<String> factors,
  ) {
    if (result.retestRecommended) {
      return ConfidenceLevel.low;
    }

    if (factors.isEmpty) {
      return ConfidenceLevel.high;
    }

    if (factors.length >= 3) {
      return ConfidenceLevel.low;
    }

    if (factors.any((f) =>
        f.contains('正确率偏低') ||
        f.contains('测试题量较少') ||
        f.contains('像素限制'))) {
      return ConfidenceLevel.medium;
    }

    return ConfidenceLevel.medium;
  }

  static String _getConfidenceDescription(ConfidenceLevel level) {
    switch (level) {
      case ConfidenceLevel.high:
        return '结果可信度高';
      case ConfidenceLevel.medium:
        return '结果可信度中等';
      case ConfidenceLevel.low:
        return '结果可信度较低';
    }
  }

  static String _getRecommendation(ConfidenceLevel level, EyeTestResult result) {
    switch (level) {
      case ConfidenceLevel.high:
        return '测试结果可靠，可作为参考依据。';
      case ConfidenceLevel.medium:
        return '建议在相同条件下重新测试以确认结果。';
      case ConfidenceLevel.low:
        return '强烈建议重新测试或进行专业眼科检查。';
    }
  }

  static String formatDecimalAcuity(double decimalAcuity) {
    if (decimalAcuity >= 1.0) {
      return decimalAcuity.toStringAsFixed(1);
    } else if (decimalAcuity >= 0.1) {
      return decimalAcuity.toStringAsFixed(2);
    } else {
      return decimalAcuity.toStringAsFixed(2);
    }
  }

  static String formatFivePointAcuity(double fivePointAcuity) {
    return fivePointAcuity.toStringAsFixed(1);
  }

  static String formatLogMar(double logMar) {
    return logMar.toStringAsFixed(3);
  }

  static String getEyeSideLabel(EyeSide eyeSide) {
    switch (eyeSide) {
      case EyeSide.left:
        return '左眼';
      case EyeSide.right:
        return '右眼';
      case EyeSide.both:
        return '双眼';
    }
  }

  static String getEndReasonLabel(SessionEndReason reason) {
    switch (reason) {
      case SessionEndReason.thresholdReached:
        return '阈值已确定';
      case SessionEndReason.maxQuestionsReached:
        return '达到最大题数';
      case SessionEndReason.bestAcuityReached:
        return '已达到最佳视力上限';
      case SessionEndReason.pixelLimitReached:
        return '达到屏幕像素限制';
      case SessionEndReason.userAborted:
        return '用户中止';
      case SessionEndReason.protocolCompleted:
        return '测试协议完成';
    }
  }

  static String getTestModeLabel(TestMode testMode) {
    switch (testMode) {
      case TestMode.isolated:
        return '孤立模式';
      case TestMode.crowded:
        return '拥挤模式';
    }
  }

  static String getAcuityInterpretation(double decimalAcuity) {
    if (decimalAcuity >= 1.0) {
      return '视力正常';
    } else if (decimalAcuity >= 0.5) {
      return '轻度视力下降';
    } else if (decimalAcuity >= 0.3) {
      return '中度视力下降';
    } else if (decimalAcuity >= 0.1) {
      return '重度视力下降';
    } else {
      return '严重视力障碍';
    }
  }

  static String formatTestDistance(double distanceMm) {
    if (distanceMm >= 1000) {
      final meters = distanceMm / 1000;
      return '${meters.toStringAsFixed(1)} 米';
    } else {
      return '${distanceMm.toInt()} 毫米';
    }
  }

  static String formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes > 0) {
      return '$minutes 分 $seconds 秒';
    } else {
      return '$seconds 秒';
    }
  }

  static String formatAccuracy(double accuracy) {
    return '${(accuracy * 100).toStringAsFixed(1)}%';
  }

  static String formatResponseTime(double meanResponseTimeMs) {
    if (meanResponseTimeMs >= 1000) {
      final seconds = meanResponseTimeMs / 1000;
      return '${seconds.toStringAsFixed(1)} 秒';
    } else {
      return '${meanResponseTimeMs.toInt()} 毫秒';
    }
  }
}

class ResultDisplayData {
  final EyeTestResult result;
  final ConfidenceAssessment confidence;
  final String decimalAcuityFormatted;
  final String fivePointAcuityFormatted;
  final String logMarFormatted;
  final String eyeSideLabel;
  final String acuityInterpretation;
  final String accuracyFormatted;
  final String responseTimeFormatted;

  ResultDisplayData({
    required this.result,
    required this.confidence,
    required this.decimalAcuityFormatted,
    required this.fivePointAcuityFormatted,
    required this.logMarFormatted,
    required this.eyeSideLabel,
    required this.acuityInterpretation,
    required this.accuracyFormatted,
    required this.responseTimeFormatted,
  });

  factory ResultDisplayData.fromResult(EyeTestResult result) {
    return ResultDisplayData(
      result: result,
      confidence: ResultInterpreter.assessConfidence(result),
      decimalAcuityFormatted:
          ResultInterpreter.formatDecimalAcuity(result.decimalAcuity),
      fivePointAcuityFormatted:
          ResultInterpreter.formatFivePointAcuity(result.fivePointAcuity),
      logMarFormatted:
          ResultInterpreter.formatLogMar(result.equivalentLogMar),
      eyeSideLabel: ResultInterpreter.getEyeSideLabel(result.eyeSide),
      acuityInterpretation:
          ResultInterpreter.getAcuityInterpretation(result.decimalAcuity),
      accuracyFormatted: ResultInterpreter.formatAccuracy(result.accuracy),
      responseTimeFormatted:
          ResultInterpreter.formatResponseTime(result.meanResponseTimeMs),
    );
  }
}
