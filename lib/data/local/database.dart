import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('ScreenProfileRow')
class ScreenProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get deviceName => text()();
  RealColumn get screenWidthMm => real()();
  RealColumn get screenHeightMm => real()();
  IntColumn get screenWidthPx => integer()();
  IntColumn get screenHeightPx => integer()();
  RealColumn get devicePixelRatio => real()();
  BoolColumn get isDpiAware => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TestSessionRow')
class TestSessions extends Table {
  TextColumn get id => text()();
  TextColumn get screenProfileId => text().nullable()();
  TextColumn get calibrationProfileId => text().nullable()();
  TextColumn get eyeSide => text()();
  TextColumn get testMode => text()();
  TextColumn get inputMode => text()();
  RealColumn get testDistanceMm => real()();
  RealColumn get startLogMar => real()();
  RealColumn get minLogMar => real()();
  RealColumn get maxLogMar => real()();
  RealColumn get stepLogMar => real()();
  IntColumn get requiredCorrectForStepDown => integer()();
  IntColumn get allowedWrongForStepUp => integer()();
  IntColumn get requiredReversalCount => integer()();
  IntColumn get maxQuestionCount => integer()();
  IntColumn get answerTimeLimitMs => integer()();
  RealColumn get minCriticalDetailPx => real()();
  BoolColumn get enableEnvironmentCheck => boolean().withDefault(const Constant(false))();
  BoolColumn get enablePixelLimitProtection => boolean().withDefault(const Constant(true))();
  TextColumn get endReason => text()();
  RealColumn get estimatedLogMar => real().nullable()();
  RealColumn get decimalAcuity => real().nullable()();
  RealColumn get fivePointAcuity => real().nullable()();
  IntColumn get totalQuestions => integer().withDefault(const Constant(0))();
  IntColumn get correctQuestions => integer().withDefault(const Constant(0))();
  RealColumn get accuracy => real().nullable()();
  RealColumn get meanResponseTimeMs => real().nullable()();
  RealColumn get reversalStdDev => real().nullable()();
  BoolColumn get pixelLimitEncountered => boolean().withDefault(const Constant(false))();
  BoolColumn get retestRecommended => boolean().withDefault(const Constant(false))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuestionRecordRow')
class QuestionRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text()();
  IntColumn get questionIndex => integer()();
  TextColumn get eyeSide => text()();
  TextColumn get testMode => text()();
  RealColumn get targetLogMar => real()();
  RealColumn get targetDecimalAcuity => real()();
  RealColumn get targetFivePointAcuity => real()();
  TextColumn get displayedDirection => text()();
  TextColumn get userAnswer => text().nullable()();
  BoolColumn get isCorrect => boolean().withDefault(const Constant(false))();
  BoolColumn get isTimeout => boolean().withDefault(const Constant(false))();
  IntColumn get responseTimeMs => integer()();
  RealColumn get testDistanceMm => real()();
  RealColumn get optotypeSizeMm => real()();
  RealColumn get detailSizeMm => real()();
  RealColumn get optotypeWidthPx => real()();
  RealColumn get optotypeHeightPx => real()();
  RealColumn get detailWidthPx => real()();
  RealColumn get detailHeightPx => real()();
  RealColumn get criticalDetailPx => real()();
  BoolColumn get pixelLimitReached => boolean().withDefault(const Constant(false))();
  DateTimeColumn get shownAt => dateTime()();
  DateTimeColumn get answeredAt => dateTime()();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {sessionId, questionIndex}
      ];
}

@DriftDatabase(tables: [
  ScreenProfiles,
  TestSessions,
  QuestionRecords,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.connect(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'eyechart.db'));
    return NativeDatabase.createInBackground(file);
  });
}
