import '../domain/vision_enums.dart';
import '../domain/vision_models.dart';
import '../math/vision_math.dart';

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

    if (nextCorrectCount >= config.requiredCorrectForStepDown) {
      stepDirection = StepDirection.down;
      nextLogMar = _clampLogMar(
        state.currentLogMar - config.stepLogMar,
        config,
      );
      persistedCorrectCount = 0;
      persistedWrongCount = 0;
    } else if (nextWrongCount >= config.allowedWrongForStepUp) {
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
      thresholdReached: reversals.length >= config.requiredReversalCount,
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
    return VisionMath.mean(slice);
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

  static EyeTestResult buildEyeTestResult({
    required EyeSide eyeSide,
    required List<QuestionRecord> questions,
    required List<ReversalPoint> reversals,
    required bool pixelLimitEncountered,
    int lastN = 4,
  }) {
    final estimatedLogMar = estimateThresholdLogMar(
      reversals,
      lastN: lastN,
    );
    final correctQuestions = questions.where((item) => item.isCorrect).length;
    final totalQuestions = questions.length;
    final accuracy =
        totalQuestions == 0 ? 0 : correctQuestions / totalQuestions;
    final meanResponseTimeMs = totalQuestions == 0
        ? 0
        : VisionMath.mean(
            questions.map((item) => item.responseTimeMs.toDouble()),
          );
    final reversalStdDev = calculateReversalStdDev(
      reversals,
      lastN: lastN,
    );

    return EyeTestResult(
      eyeSide: eyeSide,
      estimatedLogMar: estimatedLogMar,
      decimalAcuity: VisionMath.decimalFromLogMar(estimatedLogMar),
      fivePointAcuity: VisionMath.fivePointFromLogMar(estimatedLogMar),
      totalQuestions: totalQuestions,
      correctQuestions: correctQuestions,
      accuracy: accuracy,
      meanResponseTimeMs: meanResponseTimeMs,
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
}
