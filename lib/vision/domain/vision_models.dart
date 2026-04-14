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

  // 新版测试参数（可配置）
  final int optotypesPerLine;
  final int consecutiveCorrectToPass;   // 前几题连续对直接通过行
  final int consecutiveWrongToFail;     // 连续错几题直接失败行
  final int maxErrorsPerLine;           // 整行最大错误数（完整测试时）
  final int requiredLineReversals;      // 需要几次下行→上行反转终止

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
    this.optotypesPerLine = 5,
    this.consecutiveCorrectToPass = 3,
    this.consecutiveWrongToFail = 2,
    this.maxErrorsPerLine = 1,
    this.requiredLineReversals = 3,
    this.maxQuestionCount = 999,
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
    int? optotypesPerLine,
    int? consecutiveCorrectToPass,
    int? consecutiveWrongToFail,
    int? maxErrorsPerLine,
    int? requiredLineReversals,
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
      optotypesPerLine: optotypesPerLine ?? this.optotypesPerLine,
      consecutiveCorrectToPass: consecutiveCorrectToPass ?? this.consecutiveCorrectToPass,
      consecutiveWrongToFail: consecutiveWrongToFail ?? this.consecutiveWrongToFail,
      maxErrorsPerLine: maxErrorsPerLine ?? this.maxErrorsPerLine,
      requiredLineReversals: requiredLineReversals ?? this.requiredLineReversals,
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
  final int lineIndex;
  final int optotypeIndexInLine;
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
    required this.lineIndex,
    required this.optotypeIndexInLine,
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

/// 逐题反转点（已废弃）
///
/// 请使用 [LineReversalPoint] 替代。
/// 保留此类仅用于迁移期兼容。
@Deprecated('请使用 LineReversalPoint 替代')
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

@Deprecated('请使用 LineProgressState 替代')
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

/// 行级反转点记录
class LineReversalPoint {
  final int lineIndex;
  final double logMar;
  final LineDirection previousDirection;
  final LineDirection currentDirection;
  final int correctCount;
  final int errorCount;

  const LineReversalPoint({
    required this.lineIndex,
    required this.logMar,
    required this.previousDirection,
    required this.currentDirection,
    required this.correctCount,
    required this.errorCount,
  });
}

/// 行级进度状态
class LineProgressState {
  final int currentLineIndex;
  final double currentLogMar;
  final int currentLinePresentedCount;
  final int currentLineCorrectCount;
  final int currentLineErrorCount;
  final int totalPresentedCount;
  final int totalCorrectCount;
  final LineDirection lineDirection;
  final int lineReversalCount;
  final bool protocolCompleted;

  // 新增：连续正确/错误计数（用于快速通过/失败判断）
  final int consecutiveCorrectCount;
  final int consecutiveWrongCount;

  // 新增：最终确定的视力值
  final double? determinedLogMar;

  const LineProgressState({
    required this.currentLineIndex,
    required this.currentLogMar,
    required this.currentLinePresentedCount,
    required this.currentLineCorrectCount,
    required this.currentLineErrorCount,
    required this.totalPresentedCount,
    required this.totalCorrectCount,
    required this.lineDirection,
    required this.lineReversalCount,
    required this.protocolCompleted,
    this.consecutiveCorrectCount = 0,
    this.consecutiveWrongCount = 0,
    this.determinedLogMar,
  });

  LineProgressState copyWith({
    int? currentLineIndex,
    double? currentLogMar,
    int? currentLinePresentedCount,
    int? currentLineCorrectCount,
    int? currentLineErrorCount,
    int? totalPresentedCount,
    int? totalCorrectCount,
    LineDirection? lineDirection,
    int? lineReversalCount,
    bool? protocolCompleted,
    int? consecutiveCorrectCount,
    int? consecutiveWrongCount,
    double? determinedLogMar,
  }) {
    return LineProgressState(
      currentLineIndex: currentLineIndex ?? this.currentLineIndex,
      currentLogMar: currentLogMar ?? this.currentLogMar,
      currentLinePresentedCount:
          currentLinePresentedCount ?? this.currentLinePresentedCount,
      currentLineCorrectCount:
          currentLineCorrectCount ?? this.currentLineCorrectCount,
      currentLineErrorCount:
          currentLineErrorCount ?? this.currentLineErrorCount,
      totalPresentedCount: totalPresentedCount ?? this.totalPresentedCount,
      totalCorrectCount: totalCorrectCount ?? this.totalCorrectCount,
      lineDirection: lineDirection ?? this.lineDirection,
      lineReversalCount: lineReversalCount ?? this.lineReversalCount,
      protocolCompleted: protocolCompleted ?? this.protocolCompleted,
      consecutiveCorrectCount: consecutiveCorrectCount ?? this.consecutiveCorrectCount,
      consecutiveWrongCount: consecutiveWrongCount ?? this.consecutiveWrongCount,
      determinedLogMar: determinedLogMar ?? this.determinedLogMar,
    );
  }
}

class EyeTestResult {
  final EyeSide eyeSide;
  final TestMode testMode;

  // ETDRS 风格结果
  final double equivalentLogMar;
  final double decimalAcuity;
  final double fivePointAcuity;
  final int etdrsLetterScore;
  final double bestLineLogMar;
  final List<LineReversalPoint> lineReversals;

  final int totalQuestions;
  final int correctQuestions;
  final double accuracy;
  final double meanResponseTimeMs;

  // 废弃的阶梯法字段（仅兼容保留）
  @Deprecated('阶梯法已废弃，此字段不再使用')
  final double? estimatedLogMar;
  @Deprecated('阶梯法已废弃，此字段不再使用')
  final double? reversalStdDev;

  final bool pixelLimitEncountered;
  final bool retestRecommended;

  const EyeTestResult({
    required this.eyeSide,
    required this.testMode,
    required this.equivalentLogMar,
    required this.decimalAcuity,
    required this.fivePointAcuity,
    required this.etdrsLetterScore,
    required this.bestLineLogMar,
    required this.lineReversals,
    required this.totalQuestions,
    required this.correctQuestions,
    required this.accuracy,
    required this.meanResponseTimeMs,
    @Deprecated('阶梯法已废弃，此字段不再使用') this.estimatedLogMar,
    @Deprecated('阶梯法已废弃，此字段不再使用') this.reversalStdDev,
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
