import '../domain/vision_enums.dart';
import '../domain/vision_models.dart';
import '../math/vision_math.dart';

/// 自适应行级测试引擎（新版）
///
/// 核心逻辑：
/// - 前3题全对 → 快速通过，下行到下一行
/// - 任意位置连续2错 → 快速失败，上行到上一行
/// - 前3题只有1错 → 答完5题再判断（错误数≤1则通过）
/// - 只统计下行→上行的反转，达到3次终止
class AdaptiveLineEngine {
  const AdaptiveLineEngine._();

  /// 创建初始状态
  static LineProgressState initialState(TestConfig config) {
    return LineProgressState(
      currentLineIndex: _logMarToLineIndex(config.startLogMar, config),
      currentLogMar: config.startLogMar,
      currentLinePresentedCount: 0,
      currentLineCorrectCount: 0,
      currentLineErrorCount: 0,
      totalPresentedCount: 0,
      totalCorrectCount: 0,
      lineDirection: LineDirection.down,
      lineReversalCount: 0,
      protocolCompleted: false,
      // 新增：记录连续正确/错误数
      consecutiveCorrectCount: 0,
      consecutiveWrongCount: 0,
      // 新增：记录最终确定的视力值
      determinedLogMar: null,
    );
  }

  /// 处理答题结果，返回新状态
  static LineProgressState applyAnswer({
    required LineProgressState state,
    required TestConfig config,
    required bool isCorrect,
  }) {
    // 更新统计
    final newLinePresentedCount = state.currentLinePresentedCount + 1;
    final newLineCorrectCount = state.currentLineCorrectCount + (isCorrect ? 1 : 0);
    final newLineErrorCount = state.currentLineErrorCount + (isCorrect ? 0 : 1);
    final newTotalPresentedCount = state.totalPresentedCount + 1;
    final newTotalCorrectCount = state.totalCorrectCount + (isCorrect ? 1 : 0);

    // 更新连续计数
    final newConsecutiveCorrect = isCorrect ? state.consecutiveCorrectCount + 1 : 0;
    final newConsecutiveWrong = isCorrect ? 0 : state.consecutiveWrongCount + 1;

    // 检查快速通过条件：前3题全对
    if (newLinePresentedCount <= config.consecutiveCorrectToPass &&
        newConsecutiveCorrect >= config.consecutiveCorrectToPass) {
      // 快速通过：前3题全对
      return _moveToNextLine(
        state: state,
        config: config,
        newLinePresentedCount: newLinePresentedCount,
        newLineCorrectCount: newLineCorrectCount,
        newLineErrorCount: newLineErrorCount,
        newTotalPresentedCount: newTotalPresentedCount,
        newTotalCorrectCount: newTotalCorrectCount,
        determinedLogMar: state.currentLogMar, // 视力暂定为当前行
      );
    }

    // 检查快速失败条件：任意位置连续2错
    if (newConsecutiveWrong >= config.consecutiveWrongToFail) {
      // 快速失败：连续2错
      return _reverseToPreviousLine(
        state: state,
        config: config,
        newLinePresentedCount: newLinePresentedCount,
        newLineCorrectCount: newLineCorrectCount,
        newLineErrorCount: newLineErrorCount,
        newTotalPresentedCount: newTotalPresentedCount,
        newTotalCorrectCount: newTotalCorrectCount,
        determinedLogMar: _getPreviousLineLogMar(state, config), // 视力暂定为上一级
      );
    }

    // 前3题只有1错的情况：必须答完5题
    if (newLinePresentedCount < config.optotypesPerLine) {
      // 继续当前行
      return state.copyWith(
        currentLinePresentedCount: newLinePresentedCount,
        currentLineCorrectCount: newLineCorrectCount,
        currentLineErrorCount: newLineErrorCount,
        totalPresentedCount: newTotalPresentedCount,
        totalCorrectCount: newTotalCorrectCount,
        consecutiveCorrectCount: newConsecutiveCorrect,
        consecutiveWrongCount: newConsecutiveWrong,
      );
    }

    // 答完5题，判断结果
    final linePassed = newLineErrorCount <= config.maxErrorsPerLine;

    if (linePassed) {
      // 行通过，下行到下一行
      return _moveToNextLine(
        state: state,
        config: config,
        newLinePresentedCount: newLinePresentedCount,
        newLineCorrectCount: newLineCorrectCount,
        newLineErrorCount: newLineErrorCount,
        newTotalPresentedCount: newTotalPresentedCount,
        newTotalCorrectCount: newTotalCorrectCount,
        determinedLogMar: state.currentLogMar,
      );
    } else {
      // 行失败，上行到上一行
      return _reverseToPreviousLine(
        state: state,
        config: config,
        newLinePresentedCount: newLinePresentedCount,
        newLineCorrectCount: newLineCorrectCount,
        newLineErrorCount: newLineErrorCount,
        newTotalPresentedCount: newTotalPresentedCount,
        newTotalCorrectCount: newTotalCorrectCount,
        determinedLogMar: _getPreviousLineLogMar(state, config),
      );
    }
  }

  /// 移动到下一行（下行）
  static LineProgressState _moveToNextLine({
    required LineProgressState state,
    required TestConfig config,
    required int newLinePresentedCount,
    required int newLineCorrectCount,
    required int newLineErrorCount,
    required int newTotalPresentedCount,
    required int newTotalCorrectCount,
    required double determinedLogMar,
  }) {
    final nextLineIndex = state.currentLineIndex + 1;
    final nextLogMar = _lineIndexToLogMar(nextLineIndex, config);

    // 检查是否超出范围
    if (nextLogMar < config.minLogMar) {
      // 已达到最好视力，测试完成
      return state.copyWith(
        currentLinePresentedCount: newLinePresentedCount,
        currentLineCorrectCount: newLineCorrectCount,
        currentLineErrorCount: newLineErrorCount,
        totalPresentedCount: newTotalPresentedCount,
        totalCorrectCount: newTotalCorrectCount,
        determinedLogMar: determinedLogMar,
        protocolCompleted: true,
      );
    }

    return state.copyWith(
      currentLineIndex: nextLineIndex,
      currentLogMar: nextLogMar,
      currentLinePresentedCount: 0,
      currentLineCorrectCount: 0,
      currentLineErrorCount: 0,
      totalPresentedCount: newTotalPresentedCount,
      totalCorrectCount: newTotalCorrectCount,
      lineDirection: LineDirection.down,
      consecutiveCorrectCount: 0,
      consecutiveWrongCount: 0,
      determinedLogMar: determinedLogMar,
    );
  }

  /// 反转到上一行（上行）- 只统计下行→上行的反转
  static LineProgressState _reverseToPreviousLine({
    required LineProgressState state,
    required TestConfig config,
    required int newLinePresentedCount,
    required int newLineCorrectCount,
    required int newLineErrorCount,
    required int newTotalPresentedCount,
    required int newTotalCorrectCount,
    required double determinedLogMar,
  }) {
    // 只统计下行→上行的反转
    final newReversalCount = state.lineDirection == LineDirection.down
        ? state.lineReversalCount + 1
        : state.lineReversalCount;

    // 检查是否达到终止条件
    if (newReversalCount >= config.requiredLineReversals) {
      return state.copyWith(
        currentLinePresentedCount: newLinePresentedCount,
        currentLineCorrectCount: newLineCorrectCount,
        currentLineErrorCount: newLineErrorCount,
        totalPresentedCount: newTotalPresentedCount,
        totalCorrectCount: newTotalCorrectCount,
        lineReversalCount: newReversalCount,
        determinedLogMar: determinedLogMar,
        protocolCompleted: true,
      );
    }

    final prevLineIndex = state.currentLineIndex - 1;
    final prevLogMar = _lineIndexToLogMar(prevLineIndex, config);

    // 检查是否超出范围
    if (prevLogMar > config.maxLogMar) {
      return state.copyWith(
        currentLinePresentedCount: newLinePresentedCount,
        currentLineCorrectCount: newLineCorrectCount,
        currentLineErrorCount: newLineErrorCount,
        totalPresentedCount: newTotalPresentedCount,
        totalCorrectCount: newTotalCorrectCount,
        lineDirection: LineDirection.up,
        lineReversalCount: newReversalCount,
        determinedLogMar: determinedLogMar,
        protocolCompleted: true,
      );
    }

    return state.copyWith(
      currentLineIndex: prevLineIndex,
      currentLogMar: prevLogMar,
      currentLinePresentedCount: 0,
      currentLineCorrectCount: 0,
      currentLineErrorCount: 0,
      totalPresentedCount: newTotalPresentedCount,
      totalCorrectCount: newTotalCorrectCount,
      lineDirection: LineDirection.up,
      lineReversalCount: newReversalCount,
      consecutiveCorrectCount: 0,
      consecutiveWrongCount: 0,
      determinedLogMar: determinedLogMar,
    );
  }

  /// 获取上一行的 logMAR
  static double _getPreviousLineLogMar(LineProgressState state, TestConfig config) {
    final prevLineIndex = state.currentLineIndex - 1;
    return _lineIndexToLogMar(prevLineIndex, config);
  }

  /// 构建测试结果
  static EyeTestResult buildEyeTestResult({
    required EyeSide eyeSide,
    required TestMode testMode,
    required List<QuestionRecord> questions,
    required TestConfig config,
    required bool pixelLimitEncountered,
    required LineProgressState finalState,
  }) {
    final totalQuestions = questions.length;
    final correctQuestions = questions.where((q) => q.isCorrect).length;
    final accuracy = totalQuestions == 0 ? 0.0 : correctQuestions / totalQuestions;

    final meanResponseTimeMs = totalQuestions == 0
        ? 0.0
        : VisionMath.mean(
            questions.map((q) => q.responseTimeMs.toDouble()),
          );

    // 主结果：最终确定的视力值
    final determinedLogMar = finalState.determinedLogMar ?? config.startLogMar;
    final decimalAcuity = VisionMath.decimalFromLogMar(determinedLogMar);
    final fivePointAcuity = VisionMath.fivePointFromLogMar(determinedLogMar);

    // 参考值：ETDRS letterScore
    final letterScore = correctQuestions + 30;
    final equivalentLogMar = 1.7 - 0.02 * letterScore;

    // 收集行级反转点
    final lineReversals = _collectLineReversals(questions);

    // 判断是否需要重测
    final retestRecommended = _shouldRecommendRetest(lineReversals);

    return EyeTestResult(
      eyeSide: eyeSide,
      testMode: testMode,
      equivalentLogMar: equivalentLogMar,  // ETDRS参考值
      decimalAcuity: decimalAcuity,        // 主结果：小数视力
      fivePointAcuity: fivePointAcuity,    // 主结果：五分制
      etdrsLetterScore: letterScore,       // 参考值
      bestLineLogMar: determinedLogMar,    // 最终确定的视力
      lineReversals: lineReversals,
      totalQuestions: totalQuestions,
      correctQuestions: correctQuestions,
      accuracy: accuracy,
      meanResponseTimeMs: meanResponseTimeMs,
      pixelLimitEncountered: pixelLimitEncountered,
      retestRecommended: retestRecommended,
    );
  }

  /// 收集行级反转点
  static List<LineReversalPoint> _collectLineReversals(List<QuestionRecord> questions) {
    final reversals = <LineReversalPoint>[];
    if (questions.isEmpty) return reversals;

    // 按行分组
    final lineGroups = <int, List<QuestionRecord>>{};
    for (final question in questions) {
      lineGroups.putIfAbsent(question.lineIndex, () => []).add(question);
    }

    // 按行索引排序
    final sortedLineIndices = lineGroups.keys.toList()..sort();

    LineDirection? lastDirection;
    for (int i = 0; i < sortedLineIndices.length; i++) {
      final lineIndex = sortedLineIndices[i];
      final lineQuestions = lineGroups[lineIndex]!;

      // 确定该行的方向
      final correctCount = lineQuestions.where((q) => q.isCorrect).length;
      final errorCount = lineQuestions.length - correctCount;

      LineDirection currentDirection;
      if (i == 0) {
        currentDirection = LineDirection.down;
      } else if (lineIndex > sortedLineIndices[i - 1]) {
        currentDirection = LineDirection.down;
      } else {
        currentDirection = LineDirection.up;
      }

      // 只记录下行→上行的反转
      if (lastDirection == LineDirection.down && currentDirection == LineDirection.up) {
        reversals.add(
          LineReversalPoint(
            lineIndex: lineIndex,
            logMar: lineQuestions.first.targetLogMar,
            previousDirection: lastDirection!,
            currentDirection: currentDirection,
            correctCount: correctCount,
            errorCount: errorCount,
          ),
        );
      }

      lastDirection = currentDirection;
    }

    return reversals;
  }

  /// 判断是否建议重测
  static bool _shouldRecommendRetest(List<LineReversalPoint> reversals) {
    if (reversals.length < 2) return false;

    final logMarValues = reversals.map((r) => r.logMar).toList();
    final range = logMarValues.reduce((a, b) => a > b ? a : b) -
        logMarValues.reduce((a, b) => a < b ? a : b);

    return range > 0.3;
  }

  /// 将 logMAR 转换为行索引
  static int _logMarToLineIndex(double logMar, TestConfig config) {
    return ((config.maxLogMar - logMar) / config.stepLogMar).round();
  }

  /// 将行索引转换为 logMAR
  static double _lineIndexToLogMar(int lineIndex, TestConfig config) {
    return config.maxLogMar - lineIndex * config.stepLogMar;
  }
}
