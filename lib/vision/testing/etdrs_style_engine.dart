import '../domain/vision_enums.dart';
import '../domain/vision_models.dart';
import '../math/vision_math.dart';

/// ETDRS 风格测试引擎（适配自测场景）
///
/// 核心逻辑：
/// - 行级推进：每行 5 个视标
/// - 停止条件：某行错误数 > maxErrorsPerLine（默认 1，即错 2 个停止）
/// - 行级反转：以行为单位进行 2-3 次反转
/// - 结果计算：letterScore = totalCorrect + 30, logMAR = 1.7 - 0.02 × letterScore
class EtdrsStyleEngine {
  const EtdrsStyleEngine._();

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
    );
  }

  /// 处理答题结果，返回新状态
  static LineProgressState applyAnswer({
    required LineProgressState state,
    required TestConfig config,
    required bool isCorrect,
  }) {
    // 更新当前行统计
    final newLinePresentedCount = state.currentLinePresentedCount + 1;
    final newLineCorrectCount =
        state.currentLineCorrectCount + (isCorrect ? 1 : 0);
    final newLineErrorCount = state.currentLineErrorCount + (isCorrect ? 0 : 1);
    final newTotalPresentedCount = state.totalPresentedCount + 1;
    final newTotalCorrectCount =
        state.totalCorrectCount + (isCorrect ? 1 : 0);

    // 检查当前行是否完成或需要停止
    final lineCompleted = newLinePresentedCount >= config.optotypesPerLine;
    final lineFailed = newLineErrorCount > config.maxErrorsPerLine;

    // 如果当前行失败（错误数超过阈值），立即反转上行
    if (lineFailed) {
      return _reverseDirection(
        state: state,
        config: config,
        currentLinePresentedCount: newLinePresentedCount,
        currentLineCorrectCount: newLineCorrectCount,
        currentLineErrorCount: newLineErrorCount,
        totalPresentedCount: newTotalPresentedCount,
        totalCorrectCount: newTotalCorrectCount,
      );
    }

    // 如果当前行完成，检查是否通过
    if (lineCompleted) {
      // minCorrectPerLine 已废弃，使用 optotypesPerLine - maxErrorsPerLine 计算
      final minCorrectPerLine = config.optotypesPerLine - config.maxErrorsPerLine;
      final linePassed = newLineCorrectCount >= minCorrectPerLine;

      if (linePassed) {
        // 行通过，继续下行
        return _moveToNextLine(
          state: state,
          config: config,
          totalPresentedCount: newTotalPresentedCount,
          totalCorrectCount: newTotalCorrectCount,
        );
      } else {
        // 行未通过，反转上行
        return _reverseDirection(
          state: state,
          config: config,
          currentLinePresentedCount: newLinePresentedCount,
          currentLineCorrectCount: newLineCorrectCount,
          currentLineErrorCount: newLineErrorCount,
          totalPresentedCount: newTotalPresentedCount,
          totalCorrectCount: newTotalCorrectCount,
        );
      }
    }

    // 当前行未完成，继续当前行
    return state.copyWith(
      currentLinePresentedCount: newLinePresentedCount,
      currentLineCorrectCount: newLineCorrectCount,
      currentLineErrorCount: newLineErrorCount,
      totalPresentedCount: newTotalPresentedCount,
      totalCorrectCount: newTotalCorrectCount,
    );
  }

  /// 反转方向（下行→上行 或 上行→下行）
  static LineProgressState _reverseDirection({
    required LineProgressState state,
    required TestConfig config,
    required int currentLinePresentedCount,
    required int currentLineCorrectCount,
    required int currentLineErrorCount,
    required int totalPresentedCount,
    required int totalCorrectCount,
  }) {
    final newReversalCount = state.lineReversalCount + 1;
    final newDirection = state.lineDirection == LineDirection.down
        ? LineDirection.up
        : LineDirection.down;

    // 检查是否达到终止条件
    if (newReversalCount >= config.requiredLineReversals) {
      return state.copyWith(
        currentLinePresentedCount: currentLinePresentedCount,
        currentLineCorrectCount: currentLineCorrectCount,
        currentLineErrorCount: currentLineErrorCount,
        totalPresentedCount: totalPresentedCount,
        totalCorrectCount: totalCorrectCount,
        lineReversalCount: newReversalCount,
        protocolCompleted: true,
      );
    }

    // 根据新方向移动到相邻行
    if (newDirection == LineDirection.down) {
      // 原来是上行，现在反转为下行，移动到下一行
      final nextLineIndex = state.currentLineIndex + 1;
      final nextLogMar = _lineIndexToLogMar(nextLineIndex, config);

      if (nextLogMar < config.minLogMar) {
        // 已达到最小 logMAR，测试完成
        return state.copyWith(
          currentLinePresentedCount: currentLinePresentedCount,
          currentLineCorrectCount: currentLineCorrectCount,
          currentLineErrorCount: currentLineErrorCount,
          totalPresentedCount: totalPresentedCount,
          totalCorrectCount: totalCorrectCount,
          lineDirection: newDirection,
          lineReversalCount: newReversalCount,
          protocolCompleted: true,
        );
      }

      return state.copyWith(
        currentLineIndex: nextLineIndex,
        currentLogMar: nextLogMar,
        currentLinePresentedCount: 0,
        currentLineCorrectCount: 0,
        currentLineErrorCount: 0,
        totalPresentedCount: totalPresentedCount,
        totalCorrectCount: totalCorrectCount,
        lineDirection: newDirection,
        lineReversalCount: newReversalCount,
      );
    } else {
      // 原来是下行，现在反转为上行，移动到上一行
      final prevLineIndex = state.currentLineIndex - 1;
      final prevLogMar = _lineIndexToLogMar(prevLineIndex, config);

      if (prevLogMar > config.maxLogMar) {
        // 已达到最大 logMAR，测试完成
        return state.copyWith(
          currentLinePresentedCount: currentLinePresentedCount,
          currentLineCorrectCount: currentLineCorrectCount,
          currentLineErrorCount: currentLineErrorCount,
          totalPresentedCount: totalPresentedCount,
          totalCorrectCount: totalCorrectCount,
          lineDirection: newDirection,
          lineReversalCount: newReversalCount,
          protocolCompleted: true,
        );
      }

      return state.copyWith(
        currentLineIndex: prevLineIndex,
        currentLogMar: prevLogMar,
        currentLinePresentedCount: 0,
        currentLineCorrectCount: 0,
        currentLineErrorCount: 0,
        totalPresentedCount: totalPresentedCount,
        totalCorrectCount: totalCorrectCount,
        lineDirection: newDirection,
        lineReversalCount: newReversalCount,
      );
    }
  }

  /// 移动到下一行（下行）
  static LineProgressState _moveToNextLine({
    required LineProgressState state,
    required TestConfig config,
    required int totalPresentedCount,
    required int totalCorrectCount,
  }) {
    final nextLineIndex = state.currentLineIndex + 1;
    final nextLogMar = _lineIndexToLogMar(nextLineIndex, config);

    // 检查是否超出范围
    if (nextLogMar < config.minLogMar) {
      return state.copyWith(
        protocolCompleted: true,
      );
    }

    return state.copyWith(
      currentLineIndex: nextLineIndex,
      currentLogMar: nextLogMar,
      currentLinePresentedCount: 0,
      currentLineCorrectCount: 0,
      currentLineErrorCount: 0,
      totalPresentedCount: totalPresentedCount,
      totalCorrectCount: totalCorrectCount,
    );
  }

  /// 计算字母分数
  /// letterScore = totalCorrect + 30
  static int calculateLetterScore(int totalCorrect) {
    return totalCorrect + 30;
  }

  /// 计算等效 logMAR
  /// logMAR = 1.7 - 0.02 × letterScore
  static double calculateEquivalentLogMar(int letterScore) {
    return 1.7 - 0.02 * letterScore;
  }

  /// 计算最佳通过行的 logMAR
  static double calculateBestLineLogMar(
    List<QuestionRecord> questions,
    TestConfig config,
  ) {
    if (questions.isEmpty) {
      return config.startLogMar;
    }

    // 按行分组统计
    final lineStats = <int, _LineStats>{};
    for (final question in questions) {
      final stats = lineStats[question.lineIndex] ?? const _LineStats();
      lineStats[question.lineIndex] = stats.add(isCorrect: question.isCorrect);
    }

    // 找到通过的最小一行（最大行索引）
    int? bestLineIndex;
    for (final entry in lineStats.entries) {
      final stats = entry.value;
      // minCorrectPerLine 已废弃，使用 optotypesPerLine - maxErrorsPerLine 计算
      final minCorrectPerLine = config.optotypesPerLine - config.maxErrorsPerLine;
      if (stats.correctCount >= minCorrectPerLine) {
        if (bestLineIndex == null || entry.key > bestLineIndex) {
          bestLineIndex = entry.key;
        }
      }
    }

    if (bestLineIndex == null) {
      return config.startLogMar;
    }

    return _lineIndexToLogMar(bestLineIndex, config);
  }

  /// 收集行级反转点
  static List<LineReversalPoint> collectLineReversals(
    List<QuestionRecord> questions,
    TestConfig config,
  ) {
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

      // 检测反转
      if (lastDirection != null && lastDirection != currentDirection) {
        reversals.add(
          LineReversalPoint(
            lineIndex: lineIndex,
            logMar: lineQuestions.first.targetLogMar,
            previousDirection: lastDirection,
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

  /// 构建测试结果
  static EyeTestResult buildEyeTestResult({
    required EyeSide eyeSide,
    required TestMode testMode,
    required List<QuestionRecord> questions,
    required TestConfig config,
    required bool pixelLimitEncountered,
  }) {
    final totalQuestions = questions.length;
    final correctQuestions = questions.where((q) => q.isCorrect).length;
    final accuracy = totalQuestions == 0 ? 0.0 : correctQuestions / totalQuestions;

    final meanResponseTimeMs = totalQuestions == 0
        ? 0.0
        : VisionMath.mean(
            questions.map((q) => q.responseTimeMs.toDouble()),
          );

    // 计算 ETDRS 风格结果
    final letterScore = calculateLetterScore(correctQuestions);
    final equivalentLogMar = calculateEquivalentLogMar(letterScore);
    final decimalAcuity = VisionMath.decimalFromLogMar(equivalentLogMar);
    final fivePointAcuity = VisionMath.fivePointFromLogMar(equivalentLogMar);

    // 计算最佳行
    final bestLineLogMar = calculateBestLineLogMar(questions, config);

    // 收集行级反转点
    final lineReversals = collectLineReversals(questions, config);

    // 判断是否需要重测（根据行级反转的稳定性）
    final retestRecommended = _shouldRecommendRetest(lineReversals);

    return EyeTestResult(
      eyeSide: eyeSide,
      testMode: testMode,
      equivalentLogMar: equivalentLogMar,
      decimalAcuity: decimalAcuity,
      fivePointAcuity: fivePointAcuity,
      etdrsLetterScore: letterScore,
      bestLineLogMar: bestLineLogMar,
      lineReversals: lineReversals,
      totalQuestions: totalQuestions,
      correctQuestions: correctQuestions,
      accuracy: accuracy,
      meanResponseTimeMs: meanResponseTimeMs,
      pixelLimitEncountered: pixelLimitEncountered,
      retestRecommended: retestRecommended,
    );
  }

  /// 判断是否建议重测
  static bool _shouldRecommendRetest(List<LineReversalPoint> reversals) {
    if (reversals.length < 2) return false;

    // 如果反转点之间的 logMAR 差异过大，建议重测
    final logMarValues = reversals.map((r) => r.logMar).toList();
    final range = logMarValues.reduce((a, b) => a > b ? a : b) -
        logMarValues.reduce((a, b) => a < b ? a : b);

    return range > 0.3; // 差异超过 0.3 logMAR 建议重测
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

/// 行统计辅助类
class _LineStats {
  final int totalCount;
  final int correctCount;

  const _LineStats({
    this.totalCount = 0,
    this.correctCount = 0,
  });

  _LineStats add({required bool isCorrect}) {
    return _LineStats(
      totalCount: totalCount + 1,
      correctCount: correctCount + (isCorrect ? 1 : 0),
    );
  }
}
