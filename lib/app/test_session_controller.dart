import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../vision/domain/vision_enums.dart';
import '../vision/domain/vision_models.dart';
import '../vision/math/vision_math.dart';
import '../vision/testing/adaptive_line_engine.dart';

class TestSessionState {
  final TestConfig config;
  final ScreenProfile screenProfile;
  final LineProgressState lineProgressState;
  final List<QuestionRecord> questions;
  final OptotypeDirection currentDirection;
  final DateTime startedAt;
  final DateTime questionShownAt;
  final bool isFinished;
  final SessionEndReason? endReason;
  final bool pixelLimitEncountered;
  final RenderMetrics? currentRenderMetrics;

  const TestSessionState({
    required this.config,
    required this.screenProfile,
    required this.lineProgressState,
    required this.questions,
    required this.currentDirection,
    required this.startedAt,
    required this.questionShownAt,
    this.isFinished = false,
    this.endReason,
    this.pixelLimitEncountered = false,
    this.currentRenderMetrics,
  });

  int get currentQuestionIndex => questions.length;

  double get currentLogMar => lineProgressState.currentLogMar;

  double get currentDecimalAcuity =>
      VisionMath.decimalFromLogMar(currentLogMar);

  double get currentFivePointAcuity =>
      VisionMath.fivePointFromLogMar(currentLogMar);

  AcuityLevel get currentAcuityLevel =>
      VisionMath.createAcuityLevel(currentLogMar);

  TestSessionState copyWith({
    TestConfig? config,
    ScreenProfile? screenProfile,
    LineProgressState? lineProgressState,
    List<QuestionRecord>? questions,
    OptotypeDirection? currentDirection,
    DateTime? startedAt,
    DateTime? questionShownAt,
    bool? isFinished,
    SessionEndReason? endReason,
    bool? pixelLimitEncountered,
    RenderMetrics? currentRenderMetrics,
  }) {
    return TestSessionState(
      config: config ?? this.config,
      screenProfile: screenProfile ?? this.screenProfile,
      lineProgressState: lineProgressState ?? this.lineProgressState,
      questions: questions ?? this.questions,
      currentDirection: currentDirection ?? this.currentDirection,
      startedAt: startedAt ?? this.startedAt,
      questionShownAt: questionShownAt ?? this.questionShownAt,
      isFinished: isFinished ?? this.isFinished,
      endReason: endReason ?? this.endReason,
      pixelLimitEncountered: pixelLimitEncountered ?? this.pixelLimitEncountered,
      currentRenderMetrics: currentRenderMetrics ?? this.currentRenderMetrics,
    );
  }
}

class TestSessionController extends StateNotifier<TestSessionState?> {
  final Random _random = Random();

  TestSessionController() : super(null);

  void startSession({
    required TestConfig config,
    required ScreenProfile screenProfile,
  }) {
    final initialState = AdaptiveLineEngine.initialState(config);
    final direction = _generateRandomDirection();
    final startedAt = DateTime.now();
    final renderMetrics = VisionMath.calculateRenderMetrics(
      logMar: initialState.currentLogMar,
      testDistanceMm: config.testDistanceMm,
      screenProfile: screenProfile,
      minCriticalDetailPx: config.minCriticalDetailPx,
    );

    state = TestSessionState(
      config: config,
      screenProfile: screenProfile,
      lineProgressState: initialState,
      questions: const [],
      currentDirection: direction,
      startedAt: startedAt,
      questionShownAt: startedAt,
      currentRenderMetrics: renderMetrics,
    );
  }

  OptotypeDirection _generateRandomDirection() {
    const directions = OptotypeDirection.values;
    return directions[_random.nextInt(directions.length)];
  }

  bool checkPixelLimit() {
    if (state == null) return false;
    return _isPixelLimitReachedAtLogMar(state!.currentLogMar);
  }

  bool _isPixelLimitReachedAtLogMar(double logMar) {
    if (state == null) return false;
    if (!state!.config.enablePixelLimitProtection) return false;

    final metrics = VisionMath.calculateRenderMetrics(
      logMar: logMar,
      testDistanceMm: state!.config.testDistanceMm,
      screenProfile: state!.screenProfile,
      minCriticalDetailPx: state!.config.minCriticalDetailPx,
    );

    return metrics.pixelLimitReached;
  }

  AnswerResult submitAnswer(OptotypeDirection userAnswer) {
    return _submitAnswerInternal(userAnswer: userAnswer);
  }

  AnswerResult submitCannotSee() {
    return _submitAnswerInternal(userAnswer: null);
  }

  AnswerResult _submitAnswerInternal({required OptotypeDirection? userAnswer}) {
    if (state == null || state!.isFinished) {
      return AnswerResult.invalid;
    }

    final isCorrect = userAnswer != null && userAnswer == state!.currentDirection;
    final answeredAt = DateTime.now();
    final responseTimeMs =
        answeredAt.difference(state!.questionShownAt).inMilliseconds;
    final isTimeout = responseTimeMs > state!.config.answerTimeLimitMs;

    // 计算当前行内序号
    final currentLineIndex = state!.lineProgressState.currentLineIndex;
    final optotypeIndexInLine = state!.lineProgressState.currentLinePresentedCount;

    final questionRecord = QuestionRecord(
      index: state!.questions.length,
      eyeSide: state!.config.eyeSide,
      testMode: state!.config.testMode,
      lineIndex: currentLineIndex,
      optotypeIndexInLine: optotypeIndexInLine,
      targetLogMar: state!.currentLogMar,
      targetDecimalAcuity: state!.currentDecimalAcuity,
      targetFivePointAcuity: state!.currentFivePointAcuity,
      displayedDirection: state!.currentDirection,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
      isTimeout: isTimeout,
      responseTimeMs: responseTimeMs,
      renderMetrics: state!.currentRenderMetrics!,
      shownAt: state!.questionShownAt,
      answeredAt: answeredAt,
    );

    final updatedQuestions = [...state!.questions, questionRecord];

    // 使用新版自适应行级引擎处理答题
    final newLineProgressState = AdaptiveLineEngine.applyAnswer(
      state: state!.lineProgressState,
      config: state!.config,
      isCorrect: isCorrect,
    );

    final nextRenderMetrics = VisionMath.calculateRenderMetrics(
      logMar: newLineProgressState.currentLogMar,
      testDistanceMm: state!.config.testDistanceMm,
      screenProfile: state!.screenProfile,
      minCriticalDetailPx: state!.config.minCriticalDetailPx,
    );
    final pixelLimitReached = nextRenderMetrics.pixelLimitReached;

    SessionEndReason? endReason;
    bool isFinished = false;

    if (newLineProgressState.protocolCompleted) {
      endReason = SessionEndReason.protocolCompleted;
      isFinished = true;
    } else if (updatedQuestions.length >= state!.config.maxQuestionCount) {
      endReason = SessionEndReason.maxQuestionsReached;
      isFinished = true;
    } else if (pixelLimitReached) {
      endReason = SessionEndReason.pixelLimitReached;
      isFinished = true;
    }

    if (isFinished) {
      state = state!.copyWith(
        lineProgressState: newLineProgressState,
        questions: updatedQuestions,
        isFinished: true,
        endReason: endReason,
        pixelLimitEncountered: pixelLimitReached,
        currentRenderMetrics: nextRenderMetrics,
      );
      return isCorrect ? AnswerResult.correctFinished : AnswerResult.wrongFinished;
    }

    final nextDirection = _generateRandomDirection();

    state = state!.copyWith(
      lineProgressState: newLineProgressState,
      questions: updatedQuestions,
      currentDirection: nextDirection,
      questionShownAt: DateTime.now(),
      currentRenderMetrics: nextRenderMetrics,
    );

    return isCorrect ? AnswerResult.correct : AnswerResult.wrong;
  }

  EyeTestResult buildResult() {
    if (state == null) {
      throw StateError('测试会话不存在');
    }

    return AdaptiveLineEngine.buildEyeTestResult(
      eyeSide: state!.config.eyeSide,
      testMode: state!.config.testMode,
      questions: state!.questions,
      config: state!.config,
      pixelLimitEncountered: state!.pixelLimitEncountered,
      finalState: state!.lineProgressState,
    );
  }

  void endSession() {
    if (state == null) return;

    state = state!.copyWith(
      isFinished: true,
      endReason: SessionEndReason.userAborted,
    );
  }

  void clearSession() {
    state = null;
  }
}

enum AnswerResult {
  correct,
  wrong,
  correctFinished,
  wrongFinished,
  invalid,
}

final testSessionControllerProvider =
    StateNotifierProvider<TestSessionController, TestSessionState?>(
  (ref) => TestSessionController(),
);
