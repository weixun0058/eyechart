import 'package:drift/drift.dart';

import '../database.dart';

part 'test_session_dao.g.dart';

@DriftAccessor(tables: [TestSessions, QuestionRecords])
class TestSessionDao extends DatabaseAccessor<AppDatabase>
    with _$TestSessionDaoMixin {
  TestSessionDao(super.db);

  Future<int> insertSession(TestSessionsCompanion session) {
    return into(testSessions).insert(session);
  }

  Future<int> updateSession(TestSessionRow session) {
    return (update(testSessions)..where((t) => t.id.equals(session.id)))
        .write(TestSessionsCompanion(
      endReason: Value(session.endReason),
      estimatedLogMar: Value(session.estimatedLogMar),
      decimalAcuity: Value(session.decimalAcuity),
      fivePointAcuity: Value(session.fivePointAcuity),
      totalQuestions: Value(session.totalQuestions),
      correctQuestions: Value(session.correctQuestions),
      accuracy: Value(session.accuracy),
      meanResponseTimeMs: Value(session.meanResponseTimeMs),
      reversalStdDev: Value(session.reversalStdDev),
      pixelLimitEncountered: Value(session.pixelLimitEncountered),
      retestRecommended: Value(session.retestRecommended),
      finishedAt: Value(session.finishedAt),
    ));
  }

  Future<int> deleteSession(String id) {
    return (delete(testSessions)..where((t) => t.id.equals(id))).go();
  }

  Future<TestSessionRow?> getSessionById(String id) {
    return (select(testSessions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TestSessionRow>> getAllSessions() {
    return (select(testSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<List<TestSessionRow>> getByDateRange(
      DateTime startDate, DateTime endDate) {
    return (select(testSessions)
          ..where((t) =>
              t.startedAt.isBiggerOrEqualValue(startDate) &
              t.startedAt.isSmallerOrEqualValue(endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<List<TestSessionRow>> getByEyeSide(String eyeSide) {
    return (select(testSessions)
          ..where((t) => t.eyeSide.equals(eyeSide))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<List<TestSessionRow>> getByEyeSideAndDateRange(
      String eyeSide, DateTime startDate, DateTime endDate) {
    return (select(testSessions)
          ..where((t) =>
              t.eyeSide.equals(eyeSide) &
              t.startedAt.isBiggerOrEqualValue(startDate) &
              t.startedAt.isSmallerOrEqualValue(endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<int> insertQuestionRecord(QuestionRecordsCompanion record) {
    return into(questionRecords).insert(record);
  }

  Future<int> insertQuestionRecords(List<QuestionRecordsCompanion> records) {
    return batch((batch) {
      batch.insertAll(questionRecords, records);
    });
  }

  Future<List<QuestionRecordRow>> getQuestionsBySessionId(String sessionId) {
    return (select(questionRecords)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.questionIndex)]))
        .get();
  }

  Future<int> deleteQuestionsBySessionId(String sessionId) {
    return (delete(questionRecords)..where((t) => t.sessionId.equals(sessionId)))
        .go();
  }

  Stream<List<TestSessionRow>> watchAllSessions() {
    return (select(testSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .watch();
  }

  Stream<TestSessionRow?> watchSessionById(String id) {
    return (select(testSessions)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<Map<String, dynamic>> getSessionStatistics(String eyeSide) async {
    final sessions = await getByEyeSide(eyeSide);

    if (sessions.isEmpty) {
      return {
        'count': 0,
        'avgDecimalAcuity': null,
        'avgFivePointAcuity': null,
        'bestDecimalAcuity': null,
        'worstDecimalAcuity': null,
      };
    }

    final decimalAcuities = sessions
        .where((s) => s.decimalAcuity != null)
        .map((s) => s.decimalAcuity!)
        .toList();

    if (decimalAcuities.isEmpty) {
      return {
        'count': sessions.length,
        'avgDecimalAcuity': null,
        'avgFivePointAcuity': null,
        'bestDecimalAcuity': null,
        'worstDecimalAcuity': null,
      };
    }

    return {
      'count': sessions.length,
      'avgDecimalAcuity':
          decimalAcuities.reduce((a, b) => a + b) / decimalAcuities.length,
      'avgFivePointAcuity': sessions
              .where((s) => s.fivePointAcuity != null)
              .map((s) => s.fivePointAcuity!)
              .toList()
              .reduce((a, b) => a + b) /
          sessions.where((s) => s.fivePointAcuity != null).length,
      'bestDecimalAcuity': decimalAcuities.reduce((a, b) => a > b ? a : b),
      'worstDecimalAcuity': decimalAcuities.reduce((a, b) => a < b ? a : b),
    };
  }
}
