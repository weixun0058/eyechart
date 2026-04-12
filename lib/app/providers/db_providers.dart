import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/dao/test_session_dao.dart';
import '../../data/local/database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final testSessionDaoProvider = Provider<TestSessionDao>((ref) {
  return TestSessionDao(ref.watch(appDatabaseProvider));
});

final testSessionsProvider = FutureProvider<List<TestSessionRow>>((ref) {
  return ref.watch(testSessionDaoProvider).getAllSessions();
});
