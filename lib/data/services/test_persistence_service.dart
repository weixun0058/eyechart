import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/db_providers.dart';
import '../../app/test_session_controller.dart';
import '../../data/local/dao/test_session_dao.dart';
import '../../data/local/database.dart';
import '../../vision/domain/vision_models.dart';

final testPersistenceServiceProvider =
    Provider<TestPersistenceService>((ref) {
  return TestPersistenceService(ref.watch(testSessionDaoProvider));
});

class TestPersistenceService {
  final TestSessionDao _dao;

  TestPersistenceService(this._dao);

  Future<String> saveCompletedSession({
    required TestSessionState sessionState,
    required EyeTestResult result,
  }) async {
    final endReason = sessionState.endReason;
    if (!sessionState.isFinished || endReason == null) {
      throw StateError('测试未结束，无法保存结果');
    }

    final sessionId = sessionState.config.id;
    final finishedAt = sessionState.questions.isEmpty
        ? sessionState.startedAt
        : sessionState.questions.last.answeredAt;

    await _dao.insertSession(
      TestSessionsCompanion.insert(
        id: sessionId,
        screenProfileId: Value(sessionState.screenProfile.id),
        calibrationProfileId: const Value.absent(),
        eyeSide: _enumName(sessionState.config.eyeSide),
        testMode: _enumName(sessionState.config.testMode),
        inputMode: _enumName(sessionState.config.inputMode),
        testDistanceMm: sessionState.config.testDistanceMm,
        startLogMar: sessionState.config.startLogMar,
        minLogMar: sessionState.config.minLogMar,
        maxLogMar: sessionState.config.maxLogMar,
        stepLogMar: sessionState.config.stepLogMar,
        requiredCorrectForStepDown:
            sessionState.config.requiredCorrectForStepDown,
        allowedWrongForStepUp: sessionState.config.allowedWrongForStepUp,
        requiredReversalCount: sessionState.config.requiredReversalCount,
        maxQuestionCount: sessionState.config.maxQuestionCount,
        answerTimeLimitMs: sessionState.config.answerTimeLimitMs,
        minCriticalDetailPx: sessionState.config.minCriticalDetailPx,
        enableEnvironmentCheck: Value(
          sessionState.config.enableEnvironmentCheck,
        ),
        enablePixelLimitProtection: Value(
          sessionState.config.enablePixelLimitProtection,
        ),
        endReason: _enumName(endReason),
        estimatedLogMar: Value(result.estimatedLogMar),
        decimalAcuity: Value(result.decimalAcuity),
        fivePointAcuity: Value(result.fivePointAcuity),
        totalQuestions: Value(result.totalQuestions),
        correctQuestions: Value(result.correctQuestions),
        accuracy: Value(result.accuracy),
        meanResponseTimeMs: Value(result.meanResponseTimeMs),
        reversalStdDev: Value(result.reversalStdDev),
        pixelLimitEncountered: Value(result.pixelLimitEncountered),
        retestRecommended: Value(result.retestRecommended),
        startedAt: sessionState.startedAt,
        finishedAt: finishedAt,
      ),
    );

    await _dao.insertQuestionRecords(
      sessionState.questions
          .map(
            (question) => QuestionRecordsCompanion.insert(
              sessionId: sessionId,
              questionIndex: question.index,
              eyeSide: _enumName(question.eyeSide),
              testMode: _enumName(question.testMode),
              targetLogMar: question.targetLogMar,
              targetDecimalAcuity: question.targetDecimalAcuity,
              targetFivePointAcuity: question.targetFivePointAcuity,
              displayedDirection: _enumName(question.displayedDirection),
              userAnswer: Value(_nullableEnumName(question.userAnswer)),
              isCorrect: Value(question.isCorrect),
              isTimeout: Value(question.isTimeout),
              responseTimeMs: question.responseTimeMs,
              testDistanceMm: question.renderMetrics.testDistanceMm,
              optotypeSizeMm: question.renderMetrics.optotypeSizeMm,
              detailSizeMm: question.renderMetrics.detailSizeMm,
              optotypeWidthPx: question.renderMetrics.optotypeWidthPx,
              optotypeHeightPx: question.renderMetrics.optotypeHeightPx,
              detailWidthPx: question.renderMetrics.detailWidthPx,
              detailHeightPx: question.renderMetrics.detailHeightPx,
              criticalDetailPx: question.renderMetrics.criticalDetailPx,
              pixelLimitReached: Value(question.renderMetrics.pixelLimitReached),
              shownAt: question.shownAt,
              answeredAt: question.answeredAt,
            ),
          )
          .toList(),
    );

    return sessionId;
  }
}

String _enumName(Object value) => (value as Enum).name;

String? _nullableEnumName(Object? value) {
  if (value == null) {
    return null;
  }
  return (value as Enum).name;
}
