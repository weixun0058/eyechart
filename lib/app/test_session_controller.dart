import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../vision/domain/vision_enums.dart';
import '../vision/domain/vision_models.dart';
import '../vision/math/vision_math.dart';
import '../vision/testing/staircase_estimator.dart';

class TestSessionState {
  final TestConfig config;
  final ScreenProfile screenProfile;
  final StaircaseState staircaseState;
  final List<QuestionRecord> questions;
  final OptotypeDirection currentDirection;
  final DateTime questionShownAt;
  final bool isFinished;
  final SessionEndReason? endReason;
  final bool pixelLimitEncountered;
  final RenderMetrics? currentRenderMetrics;

  const TestSessionState({
    required this.config,
    required this.screenProfile,
    required this.staircaseState,
    required this.questions,
    required this.currentDirection,
    required this.questionShownAt,
    this.isFinished = false,
    this.endReason,
    this.pixelLimitEncountered = false,
    this.currentRenderMetrics,
  });

  int get currentQuestionIndex => questions.length;

  double get currentLogMar => staircaseState.currentLogMar;

  double get currentDecimalAcuity =>
      VisionMath.decimalFromLogMar(currentLogMar);

  double get currentFivePointAcuity =>
      VisionMath.fivePointFromLogMar(currentLogMar);

  AcuityLevel get currentAcuityLevel =>
      VisionMath.createAcuityLevel(currentLogMar);

  TestSessionState copyWith({
    TestConfig? config,
    ScreenProfile? screenProfile,
    StaircaseState? staircaseState,
    List<QuestionRecord>? questions,
    OptotypeDirection? currentDirection,
    DateTime? questionShownAt,
    bool? isFinished,
    SessionEndReason? endReason,
    bool? pixelLimitEncountered,
    RenderMetrics? currentRenderMetrics,
  }) {
    return TestSessionState(
      config: config ?? this.config,
      screenProfile: screenProfile ?? this.screenProfile,
      staircaseState: staircaseState ?? this.staircaseState,
      questions: questions ?? this.questions,
      currentDirection: currentDirection ?? this.currentDirection,
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
    final initialState = StaircaseEstimator.initialState(config);
    final direction = _generateRandomDirection();
    final renderMetrics = VisionMath.calculateRenderMetrics(
      logMar: initialState.currentLogMar,
      testDistanceMm: config.testDistanceMm,
      screenProfile: screenProfile,
      minCriticalDetailPx: config.minCriticalDetailPx,
    );

    state = TestSessionState(
      config: config,
      screenProfile: screenProfile,
      staircaseState: initialState,
      questions: const [],
      currentDirection: direction,
      questionShownAt: DateTime.now(),
      currentRenderMetrics: renderMetrics,
    );
  }

  OptotypeDirection _generateRandomDirection() {
    const directions = OptotypeDirection.values;
    return directions[_random.nextInt(directions.length)];
  }

  bool checkPixelLimit() {
    if (state == null) return false;
    if (!state!.config.enablePixelLimitProtection) return false;

    final metrics = VisionMath.calculateRenderMetrics(
      logMar: state!.currentLogMar,
      testDistanceMm: state!.config.testDistanceMm,
      screenProfile: state!.screenProfile,
      minCriticalDetailPx: state!.config.minCriticalDetailPx,
    );

    return metrics.pixelLimitReached;
  }

  AnswerResult submitAnswer(OptotypeDirection userAnswer) {
    if (state == null || state!.isFinished) {
      return AnswerResult.invalid;
    }

    final isCorrect = userAnswer == state!.currentDirection;
    final answeredAt = DateTime.now();
    final responseTimeMs =
        answeredAt.difference(state!.questionShownAt).inMilliseconds;
    final isTimeout = responseTimeMs > state!.config.answerTimeLimitMs;

    final questionRecord = QuestionRecord(
      index: state!.questions.length,
      eyeSide: state!.config.eyeSide,
      testMode: state!.config.testMode,
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

    final newStaircaseState = StaircaseEstimator.applyAnswer(
      state: state!.staircaseState,
      config: state!.config,
      isCorrect: isCorrect,
      questionIndex: questionRecord.index,
    );

    final pixelLimitReached = checkPixelLimit();

    SessionEndReason? endReason;
    bool isFinished = false;

    if (newStaircaseState.thresholdReached) {
      endReason = SessionEndReason.thresholdReached;
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
        staircaseState: newStaircaseState,
        questions: updatedQuestions,
        isFinished: true,
        endReason: endReason,
        pixelLimitEncountered: pixelLimitReached,
      );
      return isCorrect ? AnswerResult.correctFinished : AnswerResult.wrongFinished;
    }

    final nextDirection = _generateRandomDirection();
    final nextRenderMetrics = VisionMath.calculateRenderMetrics(
      logMar: newStaircaseState.currentLogMar,
      testDistanceMm: state!.config.testDistanceMm,
      screenProfile: state!.screenProfile,
      minCriticalDetailPx: state!.config.minCriticalDetailPx,
    );

    state = state!.copyWith(
      staircaseState: newStaircaseState,
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

    return StaircaseEstimator.buildEyeTestResult(
      eyeSide: state!.config.eyeSide,
      questions: state!.questions,
      reversals: state!.staircaseState.reversals,
      pixelLimitEncountered: state!.pixelLimitEncountered,
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
