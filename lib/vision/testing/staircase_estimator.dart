import '../domain/vision_enums.dart';
import '../domain/vision_models.dart';
import '../math/vision_math.dart';

/// 阶梯法估计器（已废弃）
///
/// 请使用 [AdaptiveLineEngine] 替代。
/// 保留此类仅用于迁移期兼容。
@Deprecated('请使用 AdaptiveLineEngine 替代')
class StaircaseEstimator {
  const StaircaseEstimator._();

  static StaircaseState initialState(TestConfig config) {
    return StaircaseState(
      currentLogMar: config.startLogMar,
      consecutiveCorrectCount: 0,
      consecutiveWrongCount: 0,
      lastStepDirection: null,
      reversals: const [],
      thresholdReached: false,
    );
  }

  static StaircaseState applyAnswer({
    required StaircaseState state,
    required TestConfig config,
    required bool isCorrect,
    required int questionIndex,
  }) {
    final nextCorrectCount =
        isCorrect ? state.consecutiveCorrectCount + 1 : 0;
    final nextWrongCount = isCorrect ? 0 : state.consecutiveWrongCount + 1;

    StepDirection? stepDirection;
    double nextLogMar = state.currentLogMar;
    int persistedCorrectCount = nextCorrectCount;
    int persistedWrongCount = nextWrongCount;

    // 使用硬编码默认值，废弃参数已从 TestConfig 移除
    const requiredCorrectForStepDown = 3;
    const allowedWrongForStepUp = 1;
    const requiredReversalCount = 6;

    if (nextCorrectCount >= requiredCorrectForStepDown) {
      stepDirection = StepDirection.down;
      nextLogMar = _clampLogMar(
        state.currentLogMar - config.stepLogMar,
        config,
      );
      persistedCorrectCount = 0;
      persistedWrongCount = 0;
    } else if (nextWrongCount >= allowedWrongForStepUp) {
      stepDirection = StepDirection.up;
      nextLogMar = _clampLogMar(
        state.currentLogMar + config.stepLogMar,
        config,
      );
      persistedCorrectCount = 0;
      persistedWrongCount = 0;
    }

    final reversals = List<ReversalPoint>.from(state.reversals);
    if (stepDirection != null &&
        state.lastStepDirection != null &&
        stepDirection != state.lastStepDirection) {
      reversals.add(
        ReversalPoint(
          questionIndex: questionIndex,
          logMar: state.currentLogMar,
          previousDirection: state.lastStepDirection!,
          currentDirection: stepDirection,
        ),
      );
    }

    return StaircaseState(
      currentLogMar: nextLogMar,
      consecutiveCorrectCount: persistedCorrectCount,
      consecutiveWrongCount: persistedWrongCount,
      lastStepDirection: stepDirection ?? state.lastStepDirection,
      reversals: reversals,
      thresholdReached: reversals.length >= requiredReversalCount,
    );
  }

  static double estimateThresholdLogMar(
    List<ReversalPoint> reversals, {
    int lastN = 4,
  }) {
    if (reversals.isEmpty) {
      throw ArgumentError.value(reversals, 'reversals', '至少需要一个反转点');
    }

    final slice = _takeLast(reversals, lastN).map((item) => item.logMar);
    return VisionMath.median(slice);
  }

  static double calculateReversalStdDev(
    List<ReversalPoint> reversals, {
    int lastN = 4,
  }) {
    if (reversals.isEmpty) {
      return 0;
    }

    final slice = _takeLast(reversals, lastN).map((item) => item.logMar);
    return VisionMath.standardDeviation(slice);
  }

  static double? estimateConfirmedLineLogMar(
    List<QuestionRecord> questions, {
    int minSamplesPerLevel = 3,
    double minAccuracy = 0.6,
  }) {
    if (questions.isEmpty) {
      return null;
    }

    final statsByLevel = <int, _LevelStats>{};
    for (final item in questions) {
      final key = _logMarKey(item.targetLogMar);
      final stats = statsByLevel[key] ?? const _LevelStats();
      statsByLevel[key] = stats.add(isCorrect: item.isCorrect);
    }

    double? bestConfirmedLogMar;
    for (final entry in statsByLevel.entries) {
      final stats = entry.value;
      if (stats.total < minSamplesPerLevel) {
        continue;
      }
      if (stats.accuracy < minAccuracy) {
        continue;
      }

      final logMar = _logMarFromKey(entry.key);
      if (bestConfirmedLogMar == null || logMar < bestConfirmedLogMar) {
        bestConfirmedLogMar = logMar;
      }
    }

    return bestConfirmedLogMar;
  }

  static EyeTestResult buildEyeTestResult({
    required EyeSide eyeSide,
    required TestMode testMode,
    required List<QuestionRecord> questions,
    required List<ReversalPoint> reversals,
    required bool pixelLimitEncountered,
    int lastN = 4,
    int minSamplesPerLevel = 3,
    double minAccuracyForConfirmedLevel = 0.6,
  }) {
    final confirmedLineLogMar = estimateConfirmedLineLogMar(
      questions,
      minSamplesPerLevel: minSamplesPerLevel,
      minAccuracy: minAccuracyForConfirmedLevel,
    );

    final reversalBasedLogMar = reversals.isEmpty
        ? (confirmedLineLogMar ??
            (questions.isEmpty
                ? null
                : questions.map((q) => q.targetLogMar).reduce((a, b) => a < b ? a : b)))
        : estimateThresholdLogMar(
            reversals,
            lastN: lastN,
          );

    if (reversalBasedLogMar == null) {
      throw StateError('无法计算测试结果：缺少反转点与题目记录');
    }

    final estimatedLogMar = confirmedLineLogMar == null
        ? reversalBasedLogMar
        : (reversalBasedLogMar < confirmedLineLogMar
            ? reversalBasedLogMar
            : confirmedLineLogMar);

    final correctQuestions = questions.where((item) => item.isCorrect).length;
    final totalQuestions = questions.length;
    final accuracy =
        totalQuestions == 0 ? 0.0 : correctQuestions / totalQuestions;
    final meanResponseTimeMs = totalQuestions == 0
        ? 0.0
        : VisionMath.mean(
            questions.map((item) => item.responseTimeMs.toDouble()),
          );
    final reversalStdDev = calculateReversalStdDev(
      reversals,
      lastN: lastN,
    );

    return EyeTestResult(
      eyeSide: eyeSide,
      testMode: testMode,
      equivalentLogMar: estimatedLogMar,
      decimalAcuity: VisionMath.decimalFromLogMar(estimatedLogMar),
      fivePointAcuity: VisionMath.fivePointFromLogMar(estimatedLogMar),
      etdrsLetterScore: correctQuestions + 30,
      bestLineLogMar: confirmedLineLogMar ?? estimatedLogMar,
      lineReversals: const [],
      totalQuestions: totalQuestions,
      correctQuestions: correctQuestions,
      accuracy: accuracy,
      meanResponseTimeMs: meanResponseTimeMs,
      estimatedLogMar: estimatedLogMar,
      reversalStdDev: reversalStdDev,
      pixelLimitEncountered: pixelLimitEncountered,
      retestRecommended: reversalStdDev > 0.1,
    );
  }

  static double _clampLogMar(double value, TestConfig config) {
    if (value < config.minLogMar) {
      return config.minLogMar;
    }
    if (value > config.maxLogMar) {
      return config.maxLogMar;
    }
    return value;
  }

  static List<T> _takeLast<T>(List<T> items, int count) {
    final safeCount = count <= 0 ? 1 : count;
    if (items.length <= safeCount) {
      return List<T>.from(items);
    }
    return items.sublist(items.length - safeCount);
  }

  static int _logMarKey(double logMar) {
    return (logMar * 1000).round();
  }

  static double _logMarFromKey(int key) {
    return key / 1000.0;
  }
}

class _LevelStats {
  final int total;
  final int correct;

  const _LevelStats({
    this.total = 0,
    this.correct = 0,
  });

  double get accuracy => total == 0 ? 0.0 : correct / total;

  _LevelStats add({required bool isCorrect}) {
    return _LevelStats(
      total: total + 1,
      correct: correct + (isCorrect ? 1 : 0),
    );
  }
}
