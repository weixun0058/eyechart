import 'package:drift/drift.dart';

import '../database.dart';

part 'screen_profile_dao.g.dart';

@DriftAccessor(tables: [ScreenProfiles])
class ScreenProfileDao extends DatabaseAccessor<AppDatabase>
    with _$ScreenProfileDaoMixin {
  ScreenProfileDao(super.db);

  Future<int> insert(ScreenProfilesCompanion profile) {
    return into(screenProfiles).insert(profile);
  }

  Future<int> updateProfile(ScreenProfileRow profile) {
    return (update(screenProfiles)..where((t) => t.id.equals(profile.id)))
        .write(ScreenProfilesCompanion(
      deviceName: Value(profile.deviceName),
      screenWidthMm: Value(profile.screenWidthMm),
      screenHeightMm: Value(profile.screenHeightMm),
      screenWidthPx: Value(profile.screenWidthPx),
      screenHeightPx: Value(profile.screenHeightPx),
      devicePixelRatio: Value(profile.devicePixelRatio),
      isDpiAware: Value(profile.isDpiAware),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<int> deleteById(String id) {
    return (delete(screenProfiles)..where((t) => t.id.equals(id))).go();
  }

  Future<ScreenProfileRow?> getById(String id) {
    return (select(screenProfiles)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ScreenProfileRow>> getAll() {
    return select(screenProfiles).get();
  }

  Future<ScreenProfileRow?> getActive() {
    return (select(screenProfiles)..where((t) => t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<void> setActive(String id) async {
    await (update(screenProfiles)..where((t) => t.isActive.equals(true)))
        .write(const ScreenProfilesCompanion(
      isActive: Value(false),
    ));

    await (update(screenProfiles)..where((t) => t.id.equals(id)))
        .write(const ScreenProfilesCompanion(
      isActive: Value(true),
    ));
  }

  Future<void> deactivateAll() async {
    await (update(screenProfiles)..where((t) => t.isActive.equals(true)))
        .write(const ScreenProfilesCompanion(
      isActive: Value(false),
    ));
  }

  Future<ScreenProfileRow?> getByDeviceName(String name) {
    return (select(screenProfiles)..where((t) => t.deviceName.equals(name)))
        .getSingleOrNull();
  }

  Stream<ScreenProfileRow?> watchActive() {
    return (select(screenProfiles)..where((t) => t.isActive.equals(true)))
        .watchSingleOrNull();
  }

  Stream<List<ScreenProfileRow>> watchAll() {
    return select(screenProfiles).watch();
  }
}
