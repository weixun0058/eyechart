import 'vision_enums.dart';

class ScreenProfile {
  final String id;
  final String deviceName;
  final double screenWidthMm;
  final double screenHeightMm;
  final int screenWidthPx;
  final int screenHeightPx;
  final double devicePixelRatio;
  final bool isDpiAware;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScreenProfile({
    required this.id,
    required this.deviceName,
    required this.screenWidthMm,
    required this.screenHeightMm,
    required this.screenWidthPx,
    required this.screenHeightPx,
    required this.devicePixelRatio,
    required this.isDpiAware,
    required this.createdAt,
    required this.updatedAt,
  });

  double get pixelWidthMm => screenWidthMm / screenWidthPx;

  double get pixelHeightMm => screenHeightMm / screenHeightPx;
}

class CalibrationProfile {
  final String id;
  final String screenProfileId;
  final bool userEnteredPhysicalSize;
  final bool cardCalibrationUsed;
  final double? referenceObjectWidthMm;
  final double? referenceObjectHeightMm;
  final double calibrationScaleX;
  final double calibrationScaleY;
  final double confidenceScore;
  final DateTime createdAt;

  const CalibrationProfile({
    required this.id,
    required this.screenProfileId,
    required this.userEnteredPhysicalSize,
    required this.cardCalibrationUsed,
    required this.referenceObjectWidthMm,
    required this.referenceObjectHeightMm,
    required this.calibrationScaleX,
    required this.calibrationScaleY,
    required this.confidenceScore,
    required this.createdAt,
  });
}

class TestConfig {
  final String id;
  final EyeSide eyeSide;
  final TestMode testMode;
  final InputMode inputMode;
  final double testDistanceMm;
  final double startLogMar;
  final double minLogMar;
  final double maxLogMar;
  final double stepLogMar;
  final int requiredCorrectForStepDown;
  final int allowedWrongForStepUp;
  final int requiredReversalCount;
  final int maxQuestionCount;
  final int answerTimeLimitMs;
  final double minCriticalDetailPx;
  final bool enableEnvironmentCheck;
  final bool enablePixelLimitProtection;

  const TestConfig({
    required this.id,
    required this.eyeSide,
    required this.testMode,
    required this.inputMode,
    required this.testDistanceMm,
    required this.startLogMar,
    required this.minLogMar,
    required this.maxLogMar,
    required this.stepLogMar,
    required this.requiredCorrectForStepDown,
    required this.allowedWrongForStepUp,
    required this.requiredReversalCount,
    required this.maxQuestionCount,
    required this.answerTimeLimitMs,
    required this.minCriticalDetailPx,
    required this.enableEnvironmentCheck,
    required this.enablePixelLimitProtection,
  });

  TestConfig copyWith({
    String? id,
    EyeSide? eyeSide,
    TestMode? testMode,
    InputMode? inputMode,
    double? testDistanceMm,
    double? startLogMar,
    double? minLogMar,
    double? maxLogMar,
    double? stepLogMar,
    int? requiredCorrectForStepDown,
    int? allowedWrongForStepUp,
    int? requiredReversalCount,
    int? maxQuestionCount,
    int? answerTimeLimitMs,
    double? minCriticalDetailPx,
    bool? enableEnvironmentCheck,
    bool? enablePixelLimitProtection,
  }) {
    return TestConfig(
      id: id ?? this.id,
      eyeSide: eyeSide ?? this.eyeSide,
      testMode: testMode ?? this.testMode,
      inputMode: inputMode ?? this.inputMode,
      testDistanceMm: testDistanceMm ?? this.testDistanceMm,
      startLogMar: startLogMar ?? this.startLogMar,
      minLogMar: minLogMar ?? this.minLogMar,
      maxLogMar: maxLogMar ?? this.maxLogMar,
      stepLogMar: stepLogMar ?? this.stepLogMar,
      requiredCorrectForStepDown:
          requiredCorrectForStepDown ?? this.requiredCorrectForStepDown,
      allowedWrongForStepUp: allowedWrongForStepUp ?? this.allowedWrongForStepUp,
      requiredReversalCount: requiredReversalCount ?? this.requiredReversalCount,
      maxQuestionCount: maxQuestionCount ?? this.maxQuestionCount,
      answerTimeLimitMs: answerTimeLimitMs ?? this.answerTimeLimitMs,
      minCriticalDetailPx: minCriticalDetailPx ?? this.minCriticalDetailPx,
      enableEnvironmentCheck:
          enableEnvironmentCheck ?? this.enableEnvironmentCheck,
      enablePixelLimitProtection:
          enablePixelLimitProtection ?? this.enablePixelLimitProtection,
    );
  }
}

class AcuityLevel {
  final double logMar;
  final double marArcmin;
  final double decimalAcuity;
  final double fivePointAcuity;
  final double optotypeAngleArcmin;
  final double detailAngleArcmin;

  const AcuityLevel({
    required this.logMar,
    required this.marArcmin,
    required this.decimalAcuity,
    required this.fivePointAcuity,
    required this.optotypeAngleArcmin,
    required this.detailAngleArcmin,
  });
}

class RenderMetrics {
  final double testDistanceMm;
  final double optotypeSizeMm;
  final double detailSizeMm;
  final double optotypeWidthPx;
  final double optotypeHeightPx;
  final double detailWidthPx;
  final double detailHeightPx;
  final double criticalDetailPx;
  final bool pixelLimitReached;

  const RenderMetrics({
    required this.testDistanceMm,
    required this.optotypeSizeMm,
    required this.detailSizeMm,
    required this.optotypeWidthPx,
    required this.optotypeHeightPx,
    required this.detailWidthPx,
    required this.detailHeightPx,
    required this.criticalDetailPx,
    required this.pixelLimitReached,
  });
}

class QuestionRecord {
  final int index;
  final EyeSide eyeSide;
  final TestMode testMode;
  final double targetLogMar;
  final double targetDecimalAcuity;
  final double targetFivePointAcuity;
  final OptotypeDirection displayedDirection;
  final OptotypeDirection? userAnswer;
  final bool isCorrect;
  final bool isTimeout;
  final int responseTimeMs;
  final RenderMetrics renderMetrics;
  final DateTime shownAt;
  final DateTime answeredAt;

  const QuestionRecord({
    required this.index,
    required this.eyeSide,
    required this.testMode,
    required this.targetLogMar,
    required this.targetDecimalAcuity,
    required this.targetFivePointAcuity,
    required this.displayedDirection,
    required this.userAnswer,
    required this.isCorrect,
    required this.isTimeout,
    required this.responseTimeMs,
    required this.renderMetrics,
    required this.shownAt,
    required this.answeredAt,
  });
}

class ReversalPoint {
  final int questionIndex;
  final double logMar;
  final StepDirection previousDirection;
  final StepDirection currentDirection;

  const ReversalPoint({
    required this.questionIndex,
    required this.logMar,
    required this.previousDirection,
    required this.currentDirection,
  });
}

class StaircaseState {
  final double currentLogMar;
  final int consecutiveCorrectCount;
  final int consecutiveWrongCount;
  final StepDirection? lastStepDirection;
  final List<ReversalPoint> reversals;
  final bool thresholdReached;

  const StaircaseState({
    required this.currentLogMar,
    required this.consecutiveCorrectCount,
    required this.consecutiveWrongCount,
    required this.lastStepDirection,
    required this.reversals,
    required this.thresholdReached,
  });

  StaircaseState copyWith({
    double? currentLogMar,
    int? consecutiveCorrectCount,
    int? consecutiveWrongCount,
    StepDirection? lastStepDirection,
    List<ReversalPoint>? reversals,
    bool? thresholdReached,
  }) {
    return StaircaseState(
      currentLogMar: currentLogMar ?? this.currentLogMar,
      consecutiveCorrectCount:
          consecutiveCorrectCount ?? this.consecutiveCorrectCount,
      consecutiveWrongCount:
          consecutiveWrongCount ?? this.consecutiveWrongCount,
      lastStepDirection: lastStepDirection ?? this.lastStepDirection,
      reversals: reversals ?? this.reversals,
      thresholdReached: thresholdReached ?? this.thresholdReached,
    );
  }
}

class EyeTestResult {
  final EyeSide eyeSide;
  final double estimatedLogMar;
  final double decimalAcuity;
  final double fivePointAcuity;
  final int totalQuestions;
  final int correctQuestions;
  final double accuracy;
  final double meanResponseTimeMs;
  final double reversalStdDev;
  final bool pixelLimitEncountered;
  final bool retestRecommended;

  const EyeTestResult({
    required this.eyeSide,
    required this.estimatedLogMar,
    required this.decimalAcuity,
    required this.fivePointAcuity,
    required this.totalQuestions,
    required this.correctQuestions,
    required this.accuracy,
    required this.meanResponseTimeMs,
    required this.reversalStdDev,
    required this.pixelLimitEncountered,
    required this.retestRecommended,
  });
}

class TestSession {
  final String id;
  final String screenProfileId;
  final String calibrationProfileId;
  final TestConfig config;
  final SessionEndReason endReason;
  final List<QuestionRecord> questions;
  final List<EyeTestResult> eyeResults;
  final DateTime startedAt;
  final DateTime finishedAt;

  const TestSession({
    required this.id,
    required this.screenProfileId,
    required this.calibrationProfileId,
    required this.config,
    required this.endReason,
    required this.questions,
    required this.eyeResults,
    required this.startedAt,
    required this.finishedAt,
  });
}
