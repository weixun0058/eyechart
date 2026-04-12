import 'package:drift/native.dart';
import 'package:eyechart/app/providers/db_providers.dart';
import 'package:eyechart/app/test_session_controller.dart';
import 'package:eyechart/data/local/dao/test_session_dao.dart';
import 'package:eyechart/data/local/database.dart';
import 'package:eyechart/data/services/test_persistence_service.dart';
import 'package:eyechart/vision/domain/vision_enums.dart';
import 'package:eyechart/vision/domain/vision_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TestPersistenceService', () {
    late AppDatabase database;
    late TestSessionDao dao;
    late TestPersistenceService service;

    setUp(() {
      database = AppDatabase.connect(NativeDatabase.memory());
      dao = TestSessionDao(database);
      service = TestPersistenceService(dao);
    });

    tearDown(() async {
      await database.close();
    });

    test('保存完成的测试会话与题目记录', () async {
      final sessionState = _buildFinishedSessionState();
      final result = _buildEyeTestResult();

      final sessionId = await service.saveCompletedSession(
        sessionState: sessionState,
        result: result,
      );

      final savedSession = await dao.getSessionById(sessionId);
      final savedQuestions = await dao.getQuestionsBySessionId(sessionId);
      final allSessions = await dao.getAllSessions();

      expect(sessionId, equals('session-001'));
      expect(savedSession, isNotNull);
      expect(savedSession!.eyeSide, equals('right'));
      expect(savedSession.requiredReversalCount, equals(6));
      expect(savedSession.answerTimeLimitMs, equals(3000));
      expect(savedSession.minCriticalDetailPx, equals(3.0));
      expect(savedSession.totalQuestions, equals(2));
      expect(savedSession.correctQuestions, equals(1));
      expect(savedSession.endReason, equals('thresholdReached'));
      expect(savedQuestions, hasLength(2));
      expect(savedQuestions.first.questionIndex, equals(0));
      expect(savedQuestions.first.displayedDirection, equals('up'));
      expect(savedQuestions.last.userAnswer, equals('down'));
      expect(allSessions, hasLength(1));
    });

    test('未结束的测试会话不能保存', () async {
      final sessionState = _buildFinishedSessionState().copyWith(
        isFinished: false,
        endReason: null,
      );

      expect(
        () => service.saveCompletedSession(
          sessionState: sessionState,
          result: _buildEyeTestResult(),
        ),
        throwsStateError,
      );
    });

    test('保存后重新读取历史 provider 可以拿到最新记录', () async {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
        ],
      );
      addTearDown(container.dispose);

      final initialSessions = await container.read(testSessionsProvider.future);
      expect(initialSessions, isEmpty);

      await container.read(testPersistenceServiceProvider).saveCompletedSession(
            sessionState: _buildFinishedSessionState(),
            result: _buildEyeTestResult(),
          );

      container.invalidate(testSessionsProvider);
      final refreshedSessions = await container.read(testSessionsProvider.future);

      expect(refreshedSessions, hasLength(1));
      expect(refreshedSessions.single.id, equals('session-001'));
    });
  });
}

TestSessionState _buildFinishedSessionState() {
  final startedAt = DateTime(2026, 4, 10, 9, 0, 0);
  final firstShownAt = startedAt.add(const Duration(seconds: 1));
  final secondShownAt = startedAt.add(const Duration(seconds: 5));

  return TestSessionState(
    config: _buildTestConfig(),
    screenProfile: _buildScreenProfile(),
    staircaseState: const StaircaseState(
      currentLogMar: 0.3,
      consecutiveCorrectCount: 0,
      consecutiveWrongCount: 0,
      lastStepDirection: StepDirection.down,
      reversals: [
        ReversalPoint(
          questionIndex: 1,
          logMar: 0.3,
          previousDirection: StepDirection.up,
          currentDirection: StepDirection.down,
        ),
      ],
      thresholdReached: true,
    ),
    questions: [
      QuestionRecord(
        index: 0,
        eyeSide: EyeSide.right,
        testMode: TestMode.isolated,
        targetLogMar: 0.5,
        targetDecimalAcuity: 0.32,
        targetFivePointAcuity: 4.5,
        displayedDirection: OptotypeDirection.up,
        userAnswer: OptotypeDirection.up,
        isCorrect: true,
        isTimeout: false,
        responseTimeMs: 1200,
        renderMetrics: _buildRenderMetrics(),
        shownAt: firstShownAt,
        answeredAt: firstShownAt.add(const Duration(milliseconds: 1200)),
      ),
      QuestionRecord(
        index: 1,
        eyeSide: EyeSide.right,
        testMode: TestMode.isolated,
        targetLogMar: 0.4,
        targetDecimalAcuity: 0.4,
        targetFivePointAcuity: 4.6,
        displayedDirection: OptotypeDirection.left,
        userAnswer: OptotypeDirection.down,
        isCorrect: false,
        isTimeout: false,
        responseTimeMs: 1500,
        renderMetrics: _buildRenderMetrics(),
        shownAt: secondShownAt,
        answeredAt: secondShownAt.add(const Duration(milliseconds: 1500)),
      ),
    ],
    currentDirection: OptotypeDirection.left,
    startedAt: startedAt,
    questionShownAt: secondShownAt,
    isFinished: true,
    endReason: SessionEndReason.thresholdReached,
    pixelLimitEncountered: false,
    currentRenderMetrics: _buildRenderMetrics(),
  );
}

TestConfig _buildTestConfig() {
  return const TestConfig(
    id: 'session-001',
    eyeSide: EyeSide.right,
    testMode: TestMode.isolated,
    inputMode: InputMode.touchButtons,
    testDistanceMm: 400,
    startLogMar: 0.5,
    minLogMar: -0.3,
    maxLogMar: 1.0,
    stepLogMar: 0.1,
    requiredCorrectForStepDown: 3,
    allowedWrongForStepUp: 1,
    requiredReversalCount: 6,
    maxQuestionCount: 30,
    answerTimeLimitMs: 3000,
    minCriticalDetailPx: 3.0,
    enableEnvironmentCheck: true,
    enablePixelLimitProtection: true,
  );
}

ScreenProfile _buildScreenProfile() {
  final now = DateTime(2026, 4, 10, 8, 59, 0);
  return ScreenProfile(
    id: 'screen-001',
    deviceName: 'Pixel Test',
    screenWidthMm: 68,
    screenHeightMm: 151,
    screenWidthPx: 1080,
    screenHeightPx: 2400,
    devicePixelRatio: 3,
    isDpiAware: true,
    createdAt: now,
    updatedAt: now,
  );
}

RenderMetrics _buildRenderMetrics() {
  return const RenderMetrics(
    testDistanceMm: 400,
    optotypeSizeMm: 8,
    detailSizeMm: 1.6,
    optotypeWidthPx: 120,
    optotypeHeightPx: 120,
    detailWidthPx: 24,
    detailHeightPx: 24,
    criticalDetailPx: 4,
    pixelLimitReached: false,
  );
}

EyeTestResult _buildEyeTestResult() {
  return const EyeTestResult(
    eyeSide: EyeSide.right,
    estimatedLogMar: 0.3,
    decimalAcuity: 0.5,
    fivePointAcuity: 4.7,
    totalQuestions: 2,
    correctQuestions: 1,
    accuracy: 0.5,
    meanResponseTimeMs: 1350,
    reversalStdDev: 0.04,
    pixelLimitEncountered: false,
    retestRecommended: false,
  );
}
