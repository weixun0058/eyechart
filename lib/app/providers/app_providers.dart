import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../eyechart_core.dart';

final screenProfileProvider =
    StateProvider<ScreenProfile?>((ref) => null);

final calibrationProfileProvider =
    StateProvider<CalibrationProfile?>((ref) => null);

final testConfigProvider = StateProvider<TestConfig?>((ref) {
  final screenProfile = ref.watch(screenProfileProvider);
  if (screenProfile == null) {
    return null;
  }

  return TestConfig(
    id: 'default',
    eyeSide: EyeSide.both,
    testMode: TestMode.isolated,
    inputMode: InputMode.touchButtons,
    testDistanceMm: 400,
    startLogMar: 0.7,
    minLogMar: -0.2,
    maxLogMar: 1.0,
    stepLogMar: 0.1,
    requiredCorrectForStepDown: 2,
    allowedWrongForStepUp: 1,
    requiredReversalCount: 4,
    maxQuestionCount: 30,
    answerTimeLimitMs: 10000,
    minCriticalDetailPx: 2.0,
    enableEnvironmentCheck: true,
    enablePixelLimitProtection: true,
  );
});

final staircaseStateProvider =
    StateProvider<StaircaseState?>((ref) => null);

final questionRecordsProvider =
    StateProvider<List<QuestionRecord>>((ref) => []);

final currentQuestionProvider = StateProvider<QuestionRecord?>((ref) => null);

final testSessionProvider = StateProvider<TestSession?>((ref) => null);

final isTestInProgressProvider = StateProvider<bool>((ref) {
  final session = ref.watch(testSessionProvider);
  return session != null;
});

class TestSessionNotifier extends StateNotifier<TestSession?> {
  TestSessionNotifier() : super(null);

  void startSession({
    required String screenProfileId,
    required String calibrationProfileId,
    required TestConfig config,
  }) {
    state = TestSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      screenProfileId: screenProfileId,
      calibrationProfileId: calibrationProfileId,
      config: config,
      endReason: SessionEndReason.userAborted,
      questions: [],
      eyeResults: [],
      startedAt: DateTime.now(),
      finishedAt: DateTime.now(),
    );
  }

  void addQuestion(QuestionRecord question) {
    if (state == null) return;
    state = TestSession(
      id: state!.id,
      screenProfileId: state!.screenProfileId,
      calibrationProfileId: state!.calibrationProfileId,
      config: state!.config,
      endReason: state!.endReason,
      questions: [...state!.questions, question],
      eyeResults: state!.eyeResults,
      startedAt: state!.startedAt,
      finishedAt: state!.finishedAt,
    );
  }

  void endSession({
    required SessionEndReason reason,
    required List<EyeTestResult> results,
  }) {
    if (state == null) return;
    state = TestSession(
      id: state!.id,
      screenProfileId: state!.screenProfileId,
      calibrationProfileId: state!.calibrationProfileId,
      config: state!.config,
      endReason: reason,
      questions: state!.questions,
      eyeResults: results,
      startedAt: state!.startedAt,
      finishedAt: DateTime.now(),
    );
  }

  void clearSession() {
    state = null;
  }
}

final testSessionNotifierProvider =
    StateNotifierProvider<TestSessionNotifier, TestSession?>(
  (ref) => TestSessionNotifier(),
);
