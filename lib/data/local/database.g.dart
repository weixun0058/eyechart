// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ScreenProfilesTable extends ScreenProfiles
    with TableInfo<$ScreenProfilesTable, ScreenProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreenProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceNameMeta =
      const VerificationMeta('deviceName');
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
      'device_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _screenWidthMmMeta =
      const VerificationMeta('screenWidthMm');
  @override
  late final GeneratedColumn<double> screenWidthMm = GeneratedColumn<double>(
      'screen_width_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _screenHeightMmMeta =
      const VerificationMeta('screenHeightMm');
  @override
  late final GeneratedColumn<double> screenHeightMm = GeneratedColumn<double>(
      'screen_height_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _screenWidthPxMeta =
      const VerificationMeta('screenWidthPx');
  @override
  late final GeneratedColumn<int> screenWidthPx = GeneratedColumn<int>(
      'screen_width_px', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _screenHeightPxMeta =
      const VerificationMeta('screenHeightPx');
  @override
  late final GeneratedColumn<int> screenHeightPx = GeneratedColumn<int>(
      'screen_height_px', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _devicePixelRatioMeta =
      const VerificationMeta('devicePixelRatio');
  @override
  late final GeneratedColumn<double> devicePixelRatio = GeneratedColumn<double>(
      'device_pixel_ratio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isDpiAwareMeta =
      const VerificationMeta('isDpiAware');
  @override
  late final GeneratedColumn<bool> isDpiAware = GeneratedColumn<bool>(
      'is_dpi_aware', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_dpi_aware" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deviceName,
        screenWidthMm,
        screenHeightMm,
        screenWidthPx,
        screenHeightPx,
        devicePixelRatio,
        isDpiAware,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screen_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<ScreenProfileRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_name')) {
      context.handle(
          _deviceNameMeta,
          deviceName.isAcceptableOrUnknown(
              data['device_name']!, _deviceNameMeta));
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('screen_width_mm')) {
      context.handle(
          _screenWidthMmMeta,
          screenWidthMm.isAcceptableOrUnknown(
              data['screen_width_mm']!, _screenWidthMmMeta));
    } else if (isInserting) {
      context.missing(_screenWidthMmMeta);
    }
    if (data.containsKey('screen_height_mm')) {
      context.handle(
          _screenHeightMmMeta,
          screenHeightMm.isAcceptableOrUnknown(
              data['screen_height_mm']!, _screenHeightMmMeta));
    } else if (isInserting) {
      context.missing(_screenHeightMmMeta);
    }
    if (data.containsKey('screen_width_px')) {
      context.handle(
          _screenWidthPxMeta,
          screenWidthPx.isAcceptableOrUnknown(
              data['screen_width_px']!, _screenWidthPxMeta));
    } else if (isInserting) {
      context.missing(_screenWidthPxMeta);
    }
    if (data.containsKey('screen_height_px')) {
      context.handle(
          _screenHeightPxMeta,
          screenHeightPx.isAcceptableOrUnknown(
              data['screen_height_px']!, _screenHeightPxMeta));
    } else if (isInserting) {
      context.missing(_screenHeightPxMeta);
    }
    if (data.containsKey('device_pixel_ratio')) {
      context.handle(
          _devicePixelRatioMeta,
          devicePixelRatio.isAcceptableOrUnknown(
              data['device_pixel_ratio']!, _devicePixelRatioMeta));
    } else if (isInserting) {
      context.missing(_devicePixelRatioMeta);
    }
    if (data.containsKey('is_dpi_aware')) {
      context.handle(
          _isDpiAwareMeta,
          isDpiAware.isAcceptableOrUnknown(
              data['is_dpi_aware']!, _isDpiAwareMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScreenProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScreenProfileRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      deviceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_name'])!,
      screenWidthMm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}screen_width_mm'])!,
      screenHeightMm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}screen_height_mm'])!,
      screenWidthPx: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}screen_width_px'])!,
      screenHeightPx: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}screen_height_px'])!,
      devicePixelRatio: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}device_pixel_ratio'])!,
      isDpiAware: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dpi_aware'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ScreenProfilesTable createAlias(String alias) {
    return $ScreenProfilesTable(attachedDatabase, alias);
  }
}

class ScreenProfileRow extends DataClass
    implements Insertable<ScreenProfileRow> {
  final String id;
  final String deviceName;
  final double screenWidthMm;
  final double screenHeightMm;
  final int screenWidthPx;
  final int screenHeightPx;
  final double devicePixelRatio;
  final bool isDpiAware;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ScreenProfileRow(
      {required this.id,
      required this.deviceName,
      required this.screenWidthMm,
      required this.screenHeightMm,
      required this.screenWidthPx,
      required this.screenHeightPx,
      required this.devicePixelRatio,
      required this.isDpiAware,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_name'] = Variable<String>(deviceName);
    map['screen_width_mm'] = Variable<double>(screenWidthMm);
    map['screen_height_mm'] = Variable<double>(screenHeightMm);
    map['screen_width_px'] = Variable<int>(screenWidthPx);
    map['screen_height_px'] = Variable<int>(screenHeightPx);
    map['device_pixel_ratio'] = Variable<double>(devicePixelRatio);
    map['is_dpi_aware'] = Variable<bool>(isDpiAware);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScreenProfilesCompanion toCompanion(bool nullToAbsent) {
    return ScreenProfilesCompanion(
      id: Value(id),
      deviceName: Value(deviceName),
      screenWidthMm: Value(screenWidthMm),
      screenHeightMm: Value(screenHeightMm),
      screenWidthPx: Value(screenWidthPx),
      screenHeightPx: Value(screenHeightPx),
      devicePixelRatio: Value(devicePixelRatio),
      isDpiAware: Value(isDpiAware),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScreenProfileRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScreenProfileRow(
      id: serializer.fromJson<String>(json['id']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      screenWidthMm: serializer.fromJson<double>(json['screenWidthMm']),
      screenHeightMm: serializer.fromJson<double>(json['screenHeightMm']),
      screenWidthPx: serializer.fromJson<int>(json['screenWidthPx']),
      screenHeightPx: serializer.fromJson<int>(json['screenHeightPx']),
      devicePixelRatio: serializer.fromJson<double>(json['devicePixelRatio']),
      isDpiAware: serializer.fromJson<bool>(json['isDpiAware']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceName': serializer.toJson<String>(deviceName),
      'screenWidthMm': serializer.toJson<double>(screenWidthMm),
      'screenHeightMm': serializer.toJson<double>(screenHeightMm),
      'screenWidthPx': serializer.toJson<int>(screenWidthPx),
      'screenHeightPx': serializer.toJson<int>(screenHeightPx),
      'devicePixelRatio': serializer.toJson<double>(devicePixelRatio),
      'isDpiAware': serializer.toJson<bool>(isDpiAware),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScreenProfileRow copyWith(
          {String? id,
          String? deviceName,
          double? screenWidthMm,
          double? screenHeightMm,
          int? screenWidthPx,
          int? screenHeightPx,
          double? devicePixelRatio,
          bool? isDpiAware,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ScreenProfileRow(
        id: id ?? this.id,
        deviceName: deviceName ?? this.deviceName,
        screenWidthMm: screenWidthMm ?? this.screenWidthMm,
        screenHeightMm: screenHeightMm ?? this.screenHeightMm,
        screenWidthPx: screenWidthPx ?? this.screenWidthPx,
        screenHeightPx: screenHeightPx ?? this.screenHeightPx,
        devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
        isDpiAware: isDpiAware ?? this.isDpiAware,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ScreenProfileRow copyWithCompanion(ScreenProfilesCompanion data) {
    return ScreenProfileRow(
      id: data.id.present ? data.id.value : this.id,
      deviceName:
          data.deviceName.present ? data.deviceName.value : this.deviceName,
      screenWidthMm: data.screenWidthMm.present
          ? data.screenWidthMm.value
          : this.screenWidthMm,
      screenHeightMm: data.screenHeightMm.present
          ? data.screenHeightMm.value
          : this.screenHeightMm,
      screenWidthPx: data.screenWidthPx.present
          ? data.screenWidthPx.value
          : this.screenWidthPx,
      screenHeightPx: data.screenHeightPx.present
          ? data.screenHeightPx.value
          : this.screenHeightPx,
      devicePixelRatio: data.devicePixelRatio.present
          ? data.devicePixelRatio.value
          : this.devicePixelRatio,
      isDpiAware:
          data.isDpiAware.present ? data.isDpiAware.value : this.isDpiAware,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScreenProfileRow(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('screenWidthMm: $screenWidthMm, ')
          ..write('screenHeightMm: $screenHeightMm, ')
          ..write('screenWidthPx: $screenWidthPx, ')
          ..write('screenHeightPx: $screenHeightPx, ')
          ..write('devicePixelRatio: $devicePixelRatio, ')
          ..write('isDpiAware: $isDpiAware, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      deviceName,
      screenWidthMm,
      screenHeightMm,
      screenWidthPx,
      screenHeightPx,
      devicePixelRatio,
      isDpiAware,
      isActive,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenProfileRow &&
          other.id == this.id &&
          other.deviceName == this.deviceName &&
          other.screenWidthMm == this.screenWidthMm &&
          other.screenHeightMm == this.screenHeightMm &&
          other.screenWidthPx == this.screenWidthPx &&
          other.screenHeightPx == this.screenHeightPx &&
          other.devicePixelRatio == this.devicePixelRatio &&
          other.isDpiAware == this.isDpiAware &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ScreenProfilesCompanion extends UpdateCompanion<ScreenProfileRow> {
  final Value<String> id;
  final Value<String> deviceName;
  final Value<double> screenWidthMm;
  final Value<double> screenHeightMm;
  final Value<int> screenWidthPx;
  final Value<int> screenHeightPx;
  final Value<double> devicePixelRatio;
  final Value<bool> isDpiAware;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ScreenProfilesCompanion({
    this.id = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.screenWidthMm = const Value.absent(),
    this.screenHeightMm = const Value.absent(),
    this.screenWidthPx = const Value.absent(),
    this.screenHeightPx = const Value.absent(),
    this.devicePixelRatio = const Value.absent(),
    this.isDpiAware = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScreenProfilesCompanion.insert({
    required String id,
    required String deviceName,
    required double screenWidthMm,
    required double screenHeightMm,
    required int screenWidthPx,
    required int screenHeightPx,
    required double devicePixelRatio,
    this.isDpiAware = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        deviceName = Value(deviceName),
        screenWidthMm = Value(screenWidthMm),
        screenHeightMm = Value(screenHeightMm),
        screenWidthPx = Value(screenWidthPx),
        screenHeightPx = Value(screenHeightPx),
        devicePixelRatio = Value(devicePixelRatio),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ScreenProfileRow> custom({
    Expression<String>? id,
    Expression<String>? deviceName,
    Expression<double>? screenWidthMm,
    Expression<double>? screenHeightMm,
    Expression<int>? screenWidthPx,
    Expression<int>? screenHeightPx,
    Expression<double>? devicePixelRatio,
    Expression<bool>? isDpiAware,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceName != null) 'device_name': deviceName,
      if (screenWidthMm != null) 'screen_width_mm': screenWidthMm,
      if (screenHeightMm != null) 'screen_height_mm': screenHeightMm,
      if (screenWidthPx != null) 'screen_width_px': screenWidthPx,
      if (screenHeightPx != null) 'screen_height_px': screenHeightPx,
      if (devicePixelRatio != null) 'device_pixel_ratio': devicePixelRatio,
      if (isDpiAware != null) 'is_dpi_aware': isDpiAware,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScreenProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? deviceName,
      Value<double>? screenWidthMm,
      Value<double>? screenHeightMm,
      Value<int>? screenWidthPx,
      Value<int>? screenHeightPx,
      Value<double>? devicePixelRatio,
      Value<bool>? isDpiAware,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ScreenProfilesCompanion(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      screenWidthMm: screenWidthMm ?? this.screenWidthMm,
      screenHeightMm: screenHeightMm ?? this.screenHeightMm,
      screenWidthPx: screenWidthPx ?? this.screenWidthPx,
      screenHeightPx: screenHeightPx ?? this.screenHeightPx,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      isDpiAware: isDpiAware ?? this.isDpiAware,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (screenWidthMm.present) {
      map['screen_width_mm'] = Variable<double>(screenWidthMm.value);
    }
    if (screenHeightMm.present) {
      map['screen_height_mm'] = Variable<double>(screenHeightMm.value);
    }
    if (screenWidthPx.present) {
      map['screen_width_px'] = Variable<int>(screenWidthPx.value);
    }
    if (screenHeightPx.present) {
      map['screen_height_px'] = Variable<int>(screenHeightPx.value);
    }
    if (devicePixelRatio.present) {
      map['device_pixel_ratio'] = Variable<double>(devicePixelRatio.value);
    }
    if (isDpiAware.present) {
      map['is_dpi_aware'] = Variable<bool>(isDpiAware.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScreenProfilesCompanion(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('screenWidthMm: $screenWidthMm, ')
          ..write('screenHeightMm: $screenHeightMm, ')
          ..write('screenWidthPx: $screenWidthPx, ')
          ..write('screenHeightPx: $screenHeightPx, ')
          ..write('devicePixelRatio: $devicePixelRatio, ')
          ..write('isDpiAware: $isDpiAware, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestSessionsTable extends TestSessions
    with TableInfo<$TestSessionsTable, TestSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _screenProfileIdMeta =
      const VerificationMeta('screenProfileId');
  @override
  late final GeneratedColumn<String> screenProfileId = GeneratedColumn<String>(
      'screen_profile_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _calibrationProfileIdMeta =
      const VerificationMeta('calibrationProfileId');
  @override
  late final GeneratedColumn<String> calibrationProfileId =
      GeneratedColumn<String>('calibration_profile_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eyeSideMeta =
      const VerificationMeta('eyeSide');
  @override
  late final GeneratedColumn<String> eyeSide = GeneratedColumn<String>(
      'eye_side', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testModeMeta =
      const VerificationMeta('testMode');
  @override
  late final GeneratedColumn<String> testMode = GeneratedColumn<String>(
      'test_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputModeMeta =
      const VerificationMeta('inputMode');
  @override
  late final GeneratedColumn<String> inputMode = GeneratedColumn<String>(
      'input_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testDistanceMmMeta =
      const VerificationMeta('testDistanceMm');
  @override
  late final GeneratedColumn<double> testDistanceMm = GeneratedColumn<double>(
      'test_distance_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startLogMarMeta =
      const VerificationMeta('startLogMar');
  @override
  late final GeneratedColumn<double> startLogMar = GeneratedColumn<double>(
      'start_log_mar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _minLogMarMeta =
      const VerificationMeta('minLogMar');
  @override
  late final GeneratedColumn<double> minLogMar = GeneratedColumn<double>(
      'min_log_mar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxLogMarMeta =
      const VerificationMeta('maxLogMar');
  @override
  late final GeneratedColumn<double> maxLogMar = GeneratedColumn<double>(
      'max_log_mar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stepLogMarMeta =
      const VerificationMeta('stepLogMar');
  @override
  late final GeneratedColumn<double> stepLogMar = GeneratedColumn<double>(
      'step_log_mar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _requiredCorrectForStepDownMeta =
      const VerificationMeta('requiredCorrectForStepDown');
  @override
  late final GeneratedColumn<int> requiredCorrectForStepDown =
      GeneratedColumn<int>('required_correct_for_step_down', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _allowedWrongForStepUpMeta =
      const VerificationMeta('allowedWrongForStepUp');
  @override
  late final GeneratedColumn<int> allowedWrongForStepUp = GeneratedColumn<int>(
      'allowed_wrong_for_step_up', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _requiredReversalCountMeta =
      const VerificationMeta('requiredReversalCount');
  @override
  late final GeneratedColumn<int> requiredReversalCount = GeneratedColumn<int>(
      'required_reversal_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maxQuestionCountMeta =
      const VerificationMeta('maxQuestionCount');
  @override
  late final GeneratedColumn<int> maxQuestionCount = GeneratedColumn<int>(
      'max_question_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _answerTimeLimitMsMeta =
      const VerificationMeta('answerTimeLimitMs');
  @override
  late final GeneratedColumn<int> answerTimeLimitMs = GeneratedColumn<int>(
      'answer_time_limit_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minCriticalDetailPxMeta =
      const VerificationMeta('minCriticalDetailPx');
  @override
  late final GeneratedColumn<double> minCriticalDetailPx =
      GeneratedColumn<double>('min_critical_detail_px', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _enableEnvironmentCheckMeta =
      const VerificationMeta('enableEnvironmentCheck');
  @override
  late final GeneratedColumn<bool> enableEnvironmentCheck =
      GeneratedColumn<bool>('enable_environment_check', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("enable_environment_check" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _enablePixelLimitProtectionMeta =
      const VerificationMeta('enablePixelLimitProtection');
  @override
  late final GeneratedColumn<bool> enablePixelLimitProtection =
      GeneratedColumn<bool>('enable_pixel_limit_protection', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("enable_pixel_limit_protection" IN (0, 1))'),
          defaultValue: const Constant(true));
  static const VerificationMeta _endReasonMeta =
      const VerificationMeta('endReason');
  @override
  late final GeneratedColumn<String> endReason = GeneratedColumn<String>(
      'end_reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estimatedLogMarMeta =
      const VerificationMeta('estimatedLogMar');
  @override
  late final GeneratedColumn<double> estimatedLogMar = GeneratedColumn<double>(
      'estimated_log_mar', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _decimalAcuityMeta =
      const VerificationMeta('decimalAcuity');
  @override
  late final GeneratedColumn<double> decimalAcuity = GeneratedColumn<double>(
      'decimal_acuity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fivePointAcuityMeta =
      const VerificationMeta('fivePointAcuity');
  @override
  late final GeneratedColumn<double> fivePointAcuity = GeneratedColumn<double>(
      'five_point_acuity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _totalQuestionsMeta =
      const VerificationMeta('totalQuestions');
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
      'total_questions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctQuestionsMeta =
      const VerificationMeta('correctQuestions');
  @override
  late final GeneratedColumn<int> correctQuestions = GeneratedColumn<int>(
      'correct_questions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _meanResponseTimeMsMeta =
      const VerificationMeta('meanResponseTimeMs');
  @override
  late final GeneratedColumn<double> meanResponseTimeMs =
      GeneratedColumn<double>('mean_response_time_ms', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _reversalStdDevMeta =
      const VerificationMeta('reversalStdDev');
  @override
  late final GeneratedColumn<double> reversalStdDev = GeneratedColumn<double>(
      'reversal_std_dev', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pixelLimitEncounteredMeta =
      const VerificationMeta('pixelLimitEncountered');
  @override
  late final GeneratedColumn<bool> pixelLimitEncountered =
      GeneratedColumn<bool>('pixel_limit_encountered', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("pixel_limit_encountered" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _retestRecommendedMeta =
      const VerificationMeta('retestRecommended');
  @override
  late final GeneratedColumn<bool> retestRecommended = GeneratedColumn<bool>(
      'retest_recommended', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("retest_recommended" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
      'finished_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        screenProfileId,
        calibrationProfileId,
        eyeSide,
        testMode,
        inputMode,
        testDistanceMm,
        startLogMar,
        minLogMar,
        maxLogMar,
        stepLogMar,
        requiredCorrectForStepDown,
        allowedWrongForStepUp,
        requiredReversalCount,
        maxQuestionCount,
        answerTimeLimitMs,
        minCriticalDetailPx,
        enableEnvironmentCheck,
        enablePixelLimitProtection,
        endReason,
        estimatedLogMar,
        decimalAcuity,
        fivePointAcuity,
        totalQuestions,
        correctQuestions,
        accuracy,
        meanResponseTimeMs,
        reversalStdDev,
        pixelLimitEncountered,
        retestRecommended,
        startedAt,
        finishedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<TestSessionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('screen_profile_id')) {
      context.handle(
          _screenProfileIdMeta,
          screenProfileId.isAcceptableOrUnknown(
              data['screen_profile_id']!, _screenProfileIdMeta));
    }
    if (data.containsKey('calibration_profile_id')) {
      context.handle(
          _calibrationProfileIdMeta,
          calibrationProfileId.isAcceptableOrUnknown(
              data['calibration_profile_id']!, _calibrationProfileIdMeta));
    }
    if (data.containsKey('eye_side')) {
      context.handle(_eyeSideMeta,
          eyeSide.isAcceptableOrUnknown(data['eye_side']!, _eyeSideMeta));
    } else if (isInserting) {
      context.missing(_eyeSideMeta);
    }
    if (data.containsKey('test_mode')) {
      context.handle(_testModeMeta,
          testMode.isAcceptableOrUnknown(data['test_mode']!, _testModeMeta));
    } else if (isInserting) {
      context.missing(_testModeMeta);
    }
    if (data.containsKey('input_mode')) {
      context.handle(_inputModeMeta,
          inputMode.isAcceptableOrUnknown(data['input_mode']!, _inputModeMeta));
    } else if (isInserting) {
      context.missing(_inputModeMeta);
    }
    if (data.containsKey('test_distance_mm')) {
      context.handle(
          _testDistanceMmMeta,
          testDistanceMm.isAcceptableOrUnknown(
              data['test_distance_mm']!, _testDistanceMmMeta));
    } else if (isInserting) {
      context.missing(_testDistanceMmMeta);
    }
    if (data.containsKey('start_log_mar')) {
      context.handle(
          _startLogMarMeta,
          startLogMar.isAcceptableOrUnknown(
              data['start_log_mar']!, _startLogMarMeta));
    } else if (isInserting) {
      context.missing(_startLogMarMeta);
    }
    if (data.containsKey('min_log_mar')) {
      context.handle(
          _minLogMarMeta,
          minLogMar.isAcceptableOrUnknown(
              data['min_log_mar']!, _minLogMarMeta));
    } else if (isInserting) {
      context.missing(_minLogMarMeta);
    }
    if (data.containsKey('max_log_mar')) {
      context.handle(
          _maxLogMarMeta,
          maxLogMar.isAcceptableOrUnknown(
              data['max_log_mar']!, _maxLogMarMeta));
    } else if (isInserting) {
      context.missing(_maxLogMarMeta);
    }
    if (data.containsKey('step_log_mar')) {
      context.handle(
          _stepLogMarMeta,
          stepLogMar.isAcceptableOrUnknown(
              data['step_log_mar']!, _stepLogMarMeta));
    } else if (isInserting) {
      context.missing(_stepLogMarMeta);
    }
    if (data.containsKey('required_correct_for_step_down')) {
      context.handle(
          _requiredCorrectForStepDownMeta,
          requiredCorrectForStepDown.isAcceptableOrUnknown(
              data['required_correct_for_step_down']!,
              _requiredCorrectForStepDownMeta));
    } else if (isInserting) {
      context.missing(_requiredCorrectForStepDownMeta);
    }
    if (data.containsKey('allowed_wrong_for_step_up')) {
      context.handle(
          _allowedWrongForStepUpMeta,
          allowedWrongForStepUp.isAcceptableOrUnknown(
              data['allowed_wrong_for_step_up']!, _allowedWrongForStepUpMeta));
    } else if (isInserting) {
      context.missing(_allowedWrongForStepUpMeta);
    }
    if (data.containsKey('required_reversal_count')) {
      context.handle(
          _requiredReversalCountMeta,
          requiredReversalCount.isAcceptableOrUnknown(
              data['required_reversal_count']!, _requiredReversalCountMeta));
    } else if (isInserting) {
      context.missing(_requiredReversalCountMeta);
    }
    if (data.containsKey('max_question_count')) {
      context.handle(
          _maxQuestionCountMeta,
          maxQuestionCount.isAcceptableOrUnknown(
              data['max_question_count']!, _maxQuestionCountMeta));
    } else if (isInserting) {
      context.missing(_maxQuestionCountMeta);
    }
    if (data.containsKey('answer_time_limit_ms')) {
      context.handle(
          _answerTimeLimitMsMeta,
          answerTimeLimitMs.isAcceptableOrUnknown(
              data['answer_time_limit_ms']!, _answerTimeLimitMsMeta));
    } else if (isInserting) {
      context.missing(_answerTimeLimitMsMeta);
    }
    if (data.containsKey('min_critical_detail_px')) {
      context.handle(
          _minCriticalDetailPxMeta,
          minCriticalDetailPx.isAcceptableOrUnknown(
              data['min_critical_detail_px']!, _minCriticalDetailPxMeta));
    } else if (isInserting) {
      context.missing(_minCriticalDetailPxMeta);
    }
    if (data.containsKey('enable_environment_check')) {
      context.handle(
          _enableEnvironmentCheckMeta,
          enableEnvironmentCheck.isAcceptableOrUnknown(
              data['enable_environment_check']!, _enableEnvironmentCheckMeta));
    }
    if (data.containsKey('enable_pixel_limit_protection')) {
      context.handle(
          _enablePixelLimitProtectionMeta,
          enablePixelLimitProtection.isAcceptableOrUnknown(
              data['enable_pixel_limit_protection']!,
              _enablePixelLimitProtectionMeta));
    }
    if (data.containsKey('end_reason')) {
      context.handle(_endReasonMeta,
          endReason.isAcceptableOrUnknown(data['end_reason']!, _endReasonMeta));
    } else if (isInserting) {
      context.missing(_endReasonMeta);
    }
    if (data.containsKey('estimated_log_mar')) {
      context.handle(
          _estimatedLogMarMeta,
          estimatedLogMar.isAcceptableOrUnknown(
              data['estimated_log_mar']!, _estimatedLogMarMeta));
    }
    if (data.containsKey('decimal_acuity')) {
      context.handle(
          _decimalAcuityMeta,
          decimalAcuity.isAcceptableOrUnknown(
              data['decimal_acuity']!, _decimalAcuityMeta));
    }
    if (data.containsKey('five_point_acuity')) {
      context.handle(
          _fivePointAcuityMeta,
          fivePointAcuity.isAcceptableOrUnknown(
              data['five_point_acuity']!, _fivePointAcuityMeta));
    }
    if (data.containsKey('total_questions')) {
      context.handle(
          _totalQuestionsMeta,
          totalQuestions.isAcceptableOrUnknown(
              data['total_questions']!, _totalQuestionsMeta));
    }
    if (data.containsKey('correct_questions')) {
      context.handle(
          _correctQuestionsMeta,
          correctQuestions.isAcceptableOrUnknown(
              data['correct_questions']!, _correctQuestionsMeta));
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    }
    if (data.containsKey('mean_response_time_ms')) {
      context.handle(
          _meanResponseTimeMsMeta,
          meanResponseTimeMs.isAcceptableOrUnknown(
              data['mean_response_time_ms']!, _meanResponseTimeMsMeta));
    }
    if (data.containsKey('reversal_std_dev')) {
      context.handle(
          _reversalStdDevMeta,
          reversalStdDev.isAcceptableOrUnknown(
              data['reversal_std_dev']!, _reversalStdDevMeta));
    }
    if (data.containsKey('pixel_limit_encountered')) {
      context.handle(
          _pixelLimitEncounteredMeta,
          pixelLimitEncountered.isAcceptableOrUnknown(
              data['pixel_limit_encountered']!, _pixelLimitEncounteredMeta));
    }
    if (data.containsKey('retest_recommended')) {
      context.handle(
          _retestRecommendedMeta,
          retestRecommended.isAcceptableOrUnknown(
              data['retest_recommended']!, _retestRecommendedMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestSessionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      screenProfileId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}screen_profile_id']),
      calibrationProfileId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}calibration_profile_id']),
      eyeSide: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}eye_side'])!,
      testMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}test_mode'])!,
      inputMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_mode'])!,
      testDistanceMm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}test_distance_mm'])!,
      startLogMar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_log_mar'])!,
      minLogMar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_log_mar'])!,
      maxLogMar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_log_mar'])!,
      stepLogMar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}step_log_mar'])!,
      requiredCorrectForStepDown: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}required_correct_for_step_down'])!,
      allowedWrongForStepUp: attachedDatabase.typeMapping.read(DriftSqlType.int,
          data['${effectivePrefix}allowed_wrong_for_step_up'])!,
      requiredReversalCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}required_reversal_count'])!,
      maxQuestionCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}max_question_count'])!,
      answerTimeLimitMs: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}answer_time_limit_ms'])!,
      minCriticalDetailPx: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}min_critical_detail_px'])!,
      enableEnvironmentCheck: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}enable_environment_check'])!,
      enablePixelLimitProtection: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}enable_pixel_limit_protection'])!,
      endReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_reason'])!,
      estimatedLogMar: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}estimated_log_mar']),
      decimalAcuity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}decimal_acuity']),
      fivePointAcuity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}five_point_acuity']),
      totalQuestions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_questions'])!,
      correctQuestions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_questions'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy']),
      meanResponseTimeMs: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}mean_response_time_ms']),
      reversalStdDev: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}reversal_std_dev']),
      pixelLimitEncountered: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}pixel_limit_encountered'])!,
      retestRecommended: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}retest_recommended'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finished_at'])!,
    );
  }

  @override
  $TestSessionsTable createAlias(String alias) {
    return $TestSessionsTable(attachedDatabase, alias);
  }
}

class TestSessionRow extends DataClass implements Insertable<TestSessionRow> {
  final String id;
  final String? screenProfileId;
  final String? calibrationProfileId;
  final String eyeSide;
  final String testMode;
  final String inputMode;
  final double testDistanceMm;
  final double startLogMar;
  final double minLogMar;
  final double maxLogMar;
  final double stepLogMar;
  final int requiredCorrectForStepDown;
  final int allowedWrongForStepUp;
  final int requiredReversalCount;
  final int maxQuestionCount;
  final int answerTimeLimitMs;
  final double minCriticalDetailPx;
  final bool enableEnvironmentCheck;
  final bool enablePixelLimitProtection;
  final String endReason;
  final double? estimatedLogMar;
  final double? decimalAcuity;
  final double? fivePointAcuity;
  final int totalQuestions;
  final int correctQuestions;
  final double? accuracy;
  final double? meanResponseTimeMs;
  final double? reversalStdDev;
  final bool pixelLimitEncountered;
  final bool retestRecommended;
  final DateTime startedAt;
  final DateTime finishedAt;
  const TestSessionRow(
      {required this.id,
      this.screenProfileId,
      this.calibrationProfileId,
      required this.eyeSide,
      required this.testMode,
      required this.inputMode,
      required this.testDistanceMm,
      required this.startLogMar,
      required this.minLogMar,
      required this.maxLogMar,
      required this.stepLogMar,
      required this.requiredCorrectForStepDown,
      required this.allowedWrongForStepUp,
      required this.requiredReversalCount,
      required this.maxQuestionCount,
      required this.answerTimeLimitMs,
      required this.minCriticalDetailPx,
      required this.enableEnvironmentCheck,
      required this.enablePixelLimitProtection,
      required this.endReason,
      this.estimatedLogMar,
      this.decimalAcuity,
      this.fivePointAcuity,
      required this.totalQuestions,
      required this.correctQuestions,
      this.accuracy,
      this.meanResponseTimeMs,
      this.reversalStdDev,
      required this.pixelLimitEncountered,
      required this.retestRecommended,
      required this.startedAt,
      required this.finishedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || screenProfileId != null) {
      map['screen_profile_id'] = Variable<String>(screenProfileId);
    }
    if (!nullToAbsent || calibrationProfileId != null) {
      map['calibration_profile_id'] = Variable<String>(calibrationProfileId);
    }
    map['eye_side'] = Variable<String>(eyeSide);
    map['test_mode'] = Variable<String>(testMode);
    map['input_mode'] = Variable<String>(inputMode);
    map['test_distance_mm'] = Variable<double>(testDistanceMm);
    map['start_log_mar'] = Variable<double>(startLogMar);
    map['min_log_mar'] = Variable<double>(minLogMar);
    map['max_log_mar'] = Variable<double>(maxLogMar);
    map['step_log_mar'] = Variable<double>(stepLogMar);
    map['required_correct_for_step_down'] =
        Variable<int>(requiredCorrectForStepDown);
    map['allowed_wrong_for_step_up'] = Variable<int>(allowedWrongForStepUp);
    map['required_reversal_count'] = Variable<int>(requiredReversalCount);
    map['max_question_count'] = Variable<int>(maxQuestionCount);
    map['answer_time_limit_ms'] = Variable<int>(answerTimeLimitMs);
    map['min_critical_detail_px'] = Variable<double>(minCriticalDetailPx);
    map['enable_environment_check'] = Variable<bool>(enableEnvironmentCheck);
    map['enable_pixel_limit_protection'] =
        Variable<bool>(enablePixelLimitProtection);
    map['end_reason'] = Variable<String>(endReason);
    if (!nullToAbsent || estimatedLogMar != null) {
      map['estimated_log_mar'] = Variable<double>(estimatedLogMar);
    }
    if (!nullToAbsent || decimalAcuity != null) {
      map['decimal_acuity'] = Variable<double>(decimalAcuity);
    }
    if (!nullToAbsent || fivePointAcuity != null) {
      map['five_point_acuity'] = Variable<double>(fivePointAcuity);
    }
    map['total_questions'] = Variable<int>(totalQuestions);
    map['correct_questions'] = Variable<int>(correctQuestions);
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || meanResponseTimeMs != null) {
      map['mean_response_time_ms'] = Variable<double>(meanResponseTimeMs);
    }
    if (!nullToAbsent || reversalStdDev != null) {
      map['reversal_std_dev'] = Variable<double>(reversalStdDev);
    }
    map['pixel_limit_encountered'] = Variable<bool>(pixelLimitEncountered);
    map['retest_recommended'] = Variable<bool>(retestRecommended);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    return map;
  }

  TestSessionsCompanion toCompanion(bool nullToAbsent) {
    return TestSessionsCompanion(
      id: Value(id),
      screenProfileId: screenProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(screenProfileId),
      calibrationProfileId: calibrationProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(calibrationProfileId),
      eyeSide: Value(eyeSide),
      testMode: Value(testMode),
      inputMode: Value(inputMode),
      testDistanceMm: Value(testDistanceMm),
      startLogMar: Value(startLogMar),
      minLogMar: Value(minLogMar),
      maxLogMar: Value(maxLogMar),
      stepLogMar: Value(stepLogMar),
      requiredCorrectForStepDown: Value(requiredCorrectForStepDown),
      allowedWrongForStepUp: Value(allowedWrongForStepUp),
      requiredReversalCount: Value(requiredReversalCount),
      maxQuestionCount: Value(maxQuestionCount),
      answerTimeLimitMs: Value(answerTimeLimitMs),
      minCriticalDetailPx: Value(minCriticalDetailPx),
      enableEnvironmentCheck: Value(enableEnvironmentCheck),
      enablePixelLimitProtection: Value(enablePixelLimitProtection),
      endReason: Value(endReason),
      estimatedLogMar: estimatedLogMar == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedLogMar),
      decimalAcuity: decimalAcuity == null && nullToAbsent
          ? const Value.absent()
          : Value(decimalAcuity),
      fivePointAcuity: fivePointAcuity == null && nullToAbsent
          ? const Value.absent()
          : Value(fivePointAcuity),
      totalQuestions: Value(totalQuestions),
      correctQuestions: Value(correctQuestions),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      meanResponseTimeMs: meanResponseTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(meanResponseTimeMs),
      reversalStdDev: reversalStdDev == null && nullToAbsent
          ? const Value.absent()
          : Value(reversalStdDev),
      pixelLimitEncountered: Value(pixelLimitEncountered),
      retestRecommended: Value(retestRecommended),
      startedAt: Value(startedAt),
      finishedAt: Value(finishedAt),
    );
  }

  factory TestSessionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestSessionRow(
      id: serializer.fromJson<String>(json['id']),
      screenProfileId: serializer.fromJson<String?>(json['screenProfileId']),
      calibrationProfileId:
          serializer.fromJson<String?>(json['calibrationProfileId']),
      eyeSide: serializer.fromJson<String>(json['eyeSide']),
      testMode: serializer.fromJson<String>(json['testMode']),
      inputMode: serializer.fromJson<String>(json['inputMode']),
      testDistanceMm: serializer.fromJson<double>(json['testDistanceMm']),
      startLogMar: serializer.fromJson<double>(json['startLogMar']),
      minLogMar: serializer.fromJson<double>(json['minLogMar']),
      maxLogMar: serializer.fromJson<double>(json['maxLogMar']),
      stepLogMar: serializer.fromJson<double>(json['stepLogMar']),
      requiredCorrectForStepDown:
          serializer.fromJson<int>(json['requiredCorrectForStepDown']),
      allowedWrongForStepUp:
          serializer.fromJson<int>(json['allowedWrongForStepUp']),
      requiredReversalCount:
          serializer.fromJson<int>(json['requiredReversalCount']),
      maxQuestionCount: serializer.fromJson<int>(json['maxQuestionCount']),
      answerTimeLimitMs: serializer.fromJson<int>(json['answerTimeLimitMs']),
      minCriticalDetailPx:
          serializer.fromJson<double>(json['minCriticalDetailPx']),
      enableEnvironmentCheck:
          serializer.fromJson<bool>(json['enableEnvironmentCheck']),
      enablePixelLimitProtection:
          serializer.fromJson<bool>(json['enablePixelLimitProtection']),
      endReason: serializer.fromJson<String>(json['endReason']),
      estimatedLogMar: serializer.fromJson<double?>(json['estimatedLogMar']),
      decimalAcuity: serializer.fromJson<double?>(json['decimalAcuity']),
      fivePointAcuity: serializer.fromJson<double?>(json['fivePointAcuity']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      correctQuestions: serializer.fromJson<int>(json['correctQuestions']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      meanResponseTimeMs:
          serializer.fromJson<double?>(json['meanResponseTimeMs']),
      reversalStdDev: serializer.fromJson<double?>(json['reversalStdDev']),
      pixelLimitEncountered:
          serializer.fromJson<bool>(json['pixelLimitEncountered']),
      retestRecommended: serializer.fromJson<bool>(json['retestRecommended']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'screenProfileId': serializer.toJson<String?>(screenProfileId),
      'calibrationProfileId': serializer.toJson<String?>(calibrationProfileId),
      'eyeSide': serializer.toJson<String>(eyeSide),
      'testMode': serializer.toJson<String>(testMode),
      'inputMode': serializer.toJson<String>(inputMode),
      'testDistanceMm': serializer.toJson<double>(testDistanceMm),
      'startLogMar': serializer.toJson<double>(startLogMar),
      'minLogMar': serializer.toJson<double>(minLogMar),
      'maxLogMar': serializer.toJson<double>(maxLogMar),
      'stepLogMar': serializer.toJson<double>(stepLogMar),
      'requiredCorrectForStepDown':
          serializer.toJson<int>(requiredCorrectForStepDown),
      'allowedWrongForStepUp': serializer.toJson<int>(allowedWrongForStepUp),
      'requiredReversalCount': serializer.toJson<int>(requiredReversalCount),
      'maxQuestionCount': serializer.toJson<int>(maxQuestionCount),
      'answerTimeLimitMs': serializer.toJson<int>(answerTimeLimitMs),
      'minCriticalDetailPx': serializer.toJson<double>(minCriticalDetailPx),
      'enableEnvironmentCheck': serializer.toJson<bool>(enableEnvironmentCheck),
      'enablePixelLimitProtection':
          serializer.toJson<bool>(enablePixelLimitProtection),
      'endReason': serializer.toJson<String>(endReason),
      'estimatedLogMar': serializer.toJson<double?>(estimatedLogMar),
      'decimalAcuity': serializer.toJson<double?>(decimalAcuity),
      'fivePointAcuity': serializer.toJson<double?>(fivePointAcuity),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'correctQuestions': serializer.toJson<int>(correctQuestions),
      'accuracy': serializer.toJson<double?>(accuracy),
      'meanResponseTimeMs': serializer.toJson<double?>(meanResponseTimeMs),
      'reversalStdDev': serializer.toJson<double?>(reversalStdDev),
      'pixelLimitEncountered': serializer.toJson<bool>(pixelLimitEncountered),
      'retestRecommended': serializer.toJson<bool>(retestRecommended),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
    };
  }

  TestSessionRow copyWith(
          {String? id,
          Value<String?> screenProfileId = const Value.absent(),
          Value<String?> calibrationProfileId = const Value.absent(),
          String? eyeSide,
          String? testMode,
          String? inputMode,
          double? testDistanceMm,
          double? startLogMar,
          double? minLogMar,
          double? maxLogMar,
          double? stepLogMar,
          int? requiredCorrectForStepDown,
          int? allowedWrongForStepUp,
          int? requiredReversalCount,
          int? maxQuestionCount,
          int? answerTimeLimitMs,
          double? minCriticalDetailPx,
          bool? enableEnvironmentCheck,
          bool? enablePixelLimitProtection,
          String? endReason,
          Value<double?> estimatedLogMar = const Value.absent(),
          Value<double?> decimalAcuity = const Value.absent(),
          Value<double?> fivePointAcuity = const Value.absent(),
          int? totalQuestions,
          int? correctQuestions,
          Value<double?> accuracy = const Value.absent(),
          Value<double?> meanResponseTimeMs = const Value.absent(),
          Value<double?> reversalStdDev = const Value.absent(),
          bool? pixelLimitEncountered,
          bool? retestRecommended,
          DateTime? startedAt,
          DateTime? finishedAt}) =>
      TestSessionRow(
        id: id ?? this.id,
        screenProfileId: screenProfileId.present
            ? screenProfileId.value
            : this.screenProfileId,
        calibrationProfileId: calibrationProfileId.present
            ? calibrationProfileId.value
            : this.calibrationProfileId,
        eyeSide: eyeSide ?? this.eyeSide,
        testMode: testMode ?? this.testMode,
        inputMode: inputMode ?? this.inputMode,
        testDistanceMm: testDistanceMm ?? this.testDistanceMm,
        startLogMar: startLogMar ?? this.startLogMar,
        minLogMar: minLogMar ?? this.minLogMar,
        maxLogMar: maxLogMar ?? this.maxLogMar,
        stepLogMar: stepLogMar ?? this.stepLogMar,
        requiredCorrectForStepDown:
            requiredCorrectForStepDown ?? this.requiredCorrectForStepDown,
        allowedWrongForStepUp:
            allowedWrongForStepUp ?? this.allowedWrongForStepUp,
        requiredReversalCount:
            requiredReversalCount ?? this.requiredReversalCount,
        maxQuestionCount: maxQuestionCount ?? this.maxQuestionCount,
        answerTimeLimitMs: answerTimeLimitMs ?? this.answerTimeLimitMs,
        minCriticalDetailPx: minCriticalDetailPx ?? this.minCriticalDetailPx,
        enableEnvironmentCheck:
            enableEnvironmentCheck ?? this.enableEnvironmentCheck,
        enablePixelLimitProtection:
            enablePixelLimitProtection ?? this.enablePixelLimitProtection,
        endReason: endReason ?? this.endReason,
        estimatedLogMar: estimatedLogMar.present
            ? estimatedLogMar.value
            : this.estimatedLogMar,
        decimalAcuity:
            decimalAcuity.present ? decimalAcuity.value : this.decimalAcuity,
        fivePointAcuity: fivePointAcuity.present
            ? fivePointAcuity.value
            : this.fivePointAcuity,
        totalQuestions: totalQuestions ?? this.totalQuestions,
        correctQuestions: correctQuestions ?? this.correctQuestions,
        accuracy: accuracy.present ? accuracy.value : this.accuracy,
        meanResponseTimeMs: meanResponseTimeMs.present
            ? meanResponseTimeMs.value
            : this.meanResponseTimeMs,
        reversalStdDev:
            reversalStdDev.present ? reversalStdDev.value : this.reversalStdDev,
        pixelLimitEncountered:
            pixelLimitEncountered ?? this.pixelLimitEncountered,
        retestRecommended: retestRecommended ?? this.retestRecommended,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt ?? this.finishedAt,
      );
  TestSessionRow copyWithCompanion(TestSessionsCompanion data) {
    return TestSessionRow(
      id: data.id.present ? data.id.value : this.id,
      screenProfileId: data.screenProfileId.present
          ? data.screenProfileId.value
          : this.screenProfileId,
      calibrationProfileId: data.calibrationProfileId.present
          ? data.calibrationProfileId.value
          : this.calibrationProfileId,
      eyeSide: data.eyeSide.present ? data.eyeSide.value : this.eyeSide,
      testMode: data.testMode.present ? data.testMode.value : this.testMode,
      inputMode: data.inputMode.present ? data.inputMode.value : this.inputMode,
      testDistanceMm: data.testDistanceMm.present
          ? data.testDistanceMm.value
          : this.testDistanceMm,
      startLogMar:
          data.startLogMar.present ? data.startLogMar.value : this.startLogMar,
      minLogMar: data.minLogMar.present ? data.minLogMar.value : this.minLogMar,
      maxLogMar: data.maxLogMar.present ? data.maxLogMar.value : this.maxLogMar,
      stepLogMar:
          data.stepLogMar.present ? data.stepLogMar.value : this.stepLogMar,
      requiredCorrectForStepDown: data.requiredCorrectForStepDown.present
          ? data.requiredCorrectForStepDown.value
          : this.requiredCorrectForStepDown,
      allowedWrongForStepUp: data.allowedWrongForStepUp.present
          ? data.allowedWrongForStepUp.value
          : this.allowedWrongForStepUp,
      requiredReversalCount: data.requiredReversalCount.present
          ? data.requiredReversalCount.value
          : this.requiredReversalCount,
      maxQuestionCount: data.maxQuestionCount.present
          ? data.maxQuestionCount.value
          : this.maxQuestionCount,
      answerTimeLimitMs: data.answerTimeLimitMs.present
          ? data.answerTimeLimitMs.value
          : this.answerTimeLimitMs,
      minCriticalDetailPx: data.minCriticalDetailPx.present
          ? data.minCriticalDetailPx.value
          : this.minCriticalDetailPx,
      enableEnvironmentCheck: data.enableEnvironmentCheck.present
          ? data.enableEnvironmentCheck.value
          : this.enableEnvironmentCheck,
      enablePixelLimitProtection: data.enablePixelLimitProtection.present
          ? data.enablePixelLimitProtection.value
          : this.enablePixelLimitProtection,
      endReason: data.endReason.present ? data.endReason.value : this.endReason,
      estimatedLogMar: data.estimatedLogMar.present
          ? data.estimatedLogMar.value
          : this.estimatedLogMar,
      decimalAcuity: data.decimalAcuity.present
          ? data.decimalAcuity.value
          : this.decimalAcuity,
      fivePointAcuity: data.fivePointAcuity.present
          ? data.fivePointAcuity.value
          : this.fivePointAcuity,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctQuestions: data.correctQuestions.present
          ? data.correctQuestions.value
          : this.correctQuestions,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      meanResponseTimeMs: data.meanResponseTimeMs.present
          ? data.meanResponseTimeMs.value
          : this.meanResponseTimeMs,
      reversalStdDev: data.reversalStdDev.present
          ? data.reversalStdDev.value
          : this.reversalStdDev,
      pixelLimitEncountered: data.pixelLimitEncountered.present
          ? data.pixelLimitEncountered.value
          : this.pixelLimitEncountered,
      retestRecommended: data.retestRecommended.present
          ? data.retestRecommended.value
          : this.retestRecommended,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt:
          data.finishedAt.present ? data.finishedAt.value : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestSessionRow(')
          ..write('id: $id, ')
          ..write('screenProfileId: $screenProfileId, ')
          ..write('calibrationProfileId: $calibrationProfileId, ')
          ..write('eyeSide: $eyeSide, ')
          ..write('testMode: $testMode, ')
          ..write('inputMode: $inputMode, ')
          ..write('testDistanceMm: $testDistanceMm, ')
          ..write('startLogMar: $startLogMar, ')
          ..write('minLogMar: $minLogMar, ')
          ..write('maxLogMar: $maxLogMar, ')
          ..write('stepLogMar: $stepLogMar, ')
          ..write('requiredCorrectForStepDown: $requiredCorrectForStepDown, ')
          ..write('allowedWrongForStepUp: $allowedWrongForStepUp, ')
          ..write('requiredReversalCount: $requiredReversalCount, ')
          ..write('maxQuestionCount: $maxQuestionCount, ')
          ..write('answerTimeLimitMs: $answerTimeLimitMs, ')
          ..write('minCriticalDetailPx: $minCriticalDetailPx, ')
          ..write('enableEnvironmentCheck: $enableEnvironmentCheck, ')
          ..write('enablePixelLimitProtection: $enablePixelLimitProtection, ')
          ..write('endReason: $endReason, ')
          ..write('estimatedLogMar: $estimatedLogMar, ')
          ..write('decimalAcuity: $decimalAcuity, ')
          ..write('fivePointAcuity: $fivePointAcuity, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctQuestions: $correctQuestions, ')
          ..write('accuracy: $accuracy, ')
          ..write('meanResponseTimeMs: $meanResponseTimeMs, ')
          ..write('reversalStdDev: $reversalStdDev, ')
          ..write('pixelLimitEncountered: $pixelLimitEncountered, ')
          ..write('retestRecommended: $retestRecommended, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        screenProfileId,
        calibrationProfileId,
        eyeSide,
        testMode,
        inputMode,
        testDistanceMm,
        startLogMar,
        minLogMar,
        maxLogMar,
        stepLogMar,
        requiredCorrectForStepDown,
        allowedWrongForStepUp,
        requiredReversalCount,
        maxQuestionCount,
        answerTimeLimitMs,
        minCriticalDetailPx,
        enableEnvironmentCheck,
        enablePixelLimitProtection,
        endReason,
        estimatedLogMar,
        decimalAcuity,
        fivePointAcuity,
        totalQuestions,
        correctQuestions,
        accuracy,
        meanResponseTimeMs,
        reversalStdDev,
        pixelLimitEncountered,
        retestRecommended,
        startedAt,
        finishedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestSessionRow &&
          other.id == this.id &&
          other.screenProfileId == this.screenProfileId &&
          other.calibrationProfileId == this.calibrationProfileId &&
          other.eyeSide == this.eyeSide &&
          other.testMode == this.testMode &&
          other.inputMode == this.inputMode &&
          other.testDistanceMm == this.testDistanceMm &&
          other.startLogMar == this.startLogMar &&
          other.minLogMar == this.minLogMar &&
          other.maxLogMar == this.maxLogMar &&
          other.stepLogMar == this.stepLogMar &&
          other.requiredCorrectForStepDown == this.requiredCorrectForStepDown &&
          other.allowedWrongForStepUp == this.allowedWrongForStepUp &&
          other.requiredReversalCount == this.requiredReversalCount &&
          other.maxQuestionCount == this.maxQuestionCount &&
          other.answerTimeLimitMs == this.answerTimeLimitMs &&
          other.minCriticalDetailPx == this.minCriticalDetailPx &&
          other.enableEnvironmentCheck == this.enableEnvironmentCheck &&
          other.enablePixelLimitProtection == this.enablePixelLimitProtection &&
          other.endReason == this.endReason &&
          other.estimatedLogMar == this.estimatedLogMar &&
          other.decimalAcuity == this.decimalAcuity &&
          other.fivePointAcuity == this.fivePointAcuity &&
          other.totalQuestions == this.totalQuestions &&
          other.correctQuestions == this.correctQuestions &&
          other.accuracy == this.accuracy &&
          other.meanResponseTimeMs == this.meanResponseTimeMs &&
          other.reversalStdDev == this.reversalStdDev &&
          other.pixelLimitEncountered == this.pixelLimitEncountered &&
          other.retestRecommended == this.retestRecommended &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class TestSessionsCompanion extends UpdateCompanion<TestSessionRow> {
  final Value<String> id;
  final Value<String?> screenProfileId;
  final Value<String?> calibrationProfileId;
  final Value<String> eyeSide;
  final Value<String> testMode;
  final Value<String> inputMode;
  final Value<double> testDistanceMm;
  final Value<double> startLogMar;
  final Value<double> minLogMar;
  final Value<double> maxLogMar;
  final Value<double> stepLogMar;
  final Value<int> requiredCorrectForStepDown;
  final Value<int> allowedWrongForStepUp;
  final Value<int> requiredReversalCount;
  final Value<int> maxQuestionCount;
  final Value<int> answerTimeLimitMs;
  final Value<double> minCriticalDetailPx;
  final Value<bool> enableEnvironmentCheck;
  final Value<bool> enablePixelLimitProtection;
  final Value<String> endReason;
  final Value<double?> estimatedLogMar;
  final Value<double?> decimalAcuity;
  final Value<double?> fivePointAcuity;
  final Value<int> totalQuestions;
  final Value<int> correctQuestions;
  final Value<double?> accuracy;
  final Value<double?> meanResponseTimeMs;
  final Value<double?> reversalStdDev;
  final Value<bool> pixelLimitEncountered;
  final Value<bool> retestRecommended;
  final Value<DateTime> startedAt;
  final Value<DateTime> finishedAt;
  final Value<int> rowid;
  const TestSessionsCompanion({
    this.id = const Value.absent(),
    this.screenProfileId = const Value.absent(),
    this.calibrationProfileId = const Value.absent(),
    this.eyeSide = const Value.absent(),
    this.testMode = const Value.absent(),
    this.inputMode = const Value.absent(),
    this.testDistanceMm = const Value.absent(),
    this.startLogMar = const Value.absent(),
    this.minLogMar = const Value.absent(),
    this.maxLogMar = const Value.absent(),
    this.stepLogMar = const Value.absent(),
    this.requiredCorrectForStepDown = const Value.absent(),
    this.allowedWrongForStepUp = const Value.absent(),
    this.requiredReversalCount = const Value.absent(),
    this.maxQuestionCount = const Value.absent(),
    this.answerTimeLimitMs = const Value.absent(),
    this.minCriticalDetailPx = const Value.absent(),
    this.enableEnvironmentCheck = const Value.absent(),
    this.enablePixelLimitProtection = const Value.absent(),
    this.endReason = const Value.absent(),
    this.estimatedLogMar = const Value.absent(),
    this.decimalAcuity = const Value.absent(),
    this.fivePointAcuity = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctQuestions = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.meanResponseTimeMs = const Value.absent(),
    this.reversalStdDev = const Value.absent(),
    this.pixelLimitEncountered = const Value.absent(),
    this.retestRecommended = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TestSessionsCompanion.insert({
    required String id,
    this.screenProfileId = const Value.absent(),
    this.calibrationProfileId = const Value.absent(),
    required String eyeSide,
    required String testMode,
    required String inputMode,
    required double testDistanceMm,
    required double startLogMar,
    required double minLogMar,
    required double maxLogMar,
    required double stepLogMar,
    required int requiredCorrectForStepDown,
    required int allowedWrongForStepUp,
    required int requiredReversalCount,
    required int maxQuestionCount,
    required int answerTimeLimitMs,
    required double minCriticalDetailPx,
    this.enableEnvironmentCheck = const Value.absent(),
    this.enablePixelLimitProtection = const Value.absent(),
    required String endReason,
    this.estimatedLogMar = const Value.absent(),
    this.decimalAcuity = const Value.absent(),
    this.fivePointAcuity = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctQuestions = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.meanResponseTimeMs = const Value.absent(),
    this.reversalStdDev = const Value.absent(),
    this.pixelLimitEncountered = const Value.absent(),
    this.retestRecommended = const Value.absent(),
    required DateTime startedAt,
    required DateTime finishedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        eyeSide = Value(eyeSide),
        testMode = Value(testMode),
        inputMode = Value(inputMode),
        testDistanceMm = Value(testDistanceMm),
        startLogMar = Value(startLogMar),
        minLogMar = Value(minLogMar),
        maxLogMar = Value(maxLogMar),
        stepLogMar = Value(stepLogMar),
        requiredCorrectForStepDown = Value(requiredCorrectForStepDown),
        allowedWrongForStepUp = Value(allowedWrongForStepUp),
        requiredReversalCount = Value(requiredReversalCount),
        maxQuestionCount = Value(maxQuestionCount),
        answerTimeLimitMs = Value(answerTimeLimitMs),
        minCriticalDetailPx = Value(minCriticalDetailPx),
        endReason = Value(endReason),
        startedAt = Value(startedAt),
        finishedAt = Value(finishedAt);
  static Insertable<TestSessionRow> custom({
    Expression<String>? id,
    Expression<String>? screenProfileId,
    Expression<String>? calibrationProfileId,
    Expression<String>? eyeSide,
    Expression<String>? testMode,
    Expression<String>? inputMode,
    Expression<double>? testDistanceMm,
    Expression<double>? startLogMar,
    Expression<double>? minLogMar,
    Expression<double>? maxLogMar,
    Expression<double>? stepLogMar,
    Expression<int>? requiredCorrectForStepDown,
    Expression<int>? allowedWrongForStepUp,
    Expression<int>? requiredReversalCount,
    Expression<int>? maxQuestionCount,
    Expression<int>? answerTimeLimitMs,
    Expression<double>? minCriticalDetailPx,
    Expression<bool>? enableEnvironmentCheck,
    Expression<bool>? enablePixelLimitProtection,
    Expression<String>? endReason,
    Expression<double>? estimatedLogMar,
    Expression<double>? decimalAcuity,
    Expression<double>? fivePointAcuity,
    Expression<int>? totalQuestions,
    Expression<int>? correctQuestions,
    Expression<double>? accuracy,
    Expression<double>? meanResponseTimeMs,
    Expression<double>? reversalStdDev,
    Expression<bool>? pixelLimitEncountered,
    Expression<bool>? retestRecommended,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (screenProfileId != null) 'screen_profile_id': screenProfileId,
      if (calibrationProfileId != null)
        'calibration_profile_id': calibrationProfileId,
      if (eyeSide != null) 'eye_side': eyeSide,
      if (testMode != null) 'test_mode': testMode,
      if (inputMode != null) 'input_mode': inputMode,
      if (testDistanceMm != null) 'test_distance_mm': testDistanceMm,
      if (startLogMar != null) 'start_log_mar': startLogMar,
      if (minLogMar != null) 'min_log_mar': minLogMar,
      if (maxLogMar != null) 'max_log_mar': maxLogMar,
      if (stepLogMar != null) 'step_log_mar': stepLogMar,
      if (requiredCorrectForStepDown != null)
        'required_correct_for_step_down': requiredCorrectForStepDown,
      if (allowedWrongForStepUp != null)
        'allowed_wrong_for_step_up': allowedWrongForStepUp,
      if (requiredReversalCount != null)
        'required_reversal_count': requiredReversalCount,
      if (maxQuestionCount != null) 'max_question_count': maxQuestionCount,
      if (answerTimeLimitMs != null) 'answer_time_limit_ms': answerTimeLimitMs,
      if (minCriticalDetailPx != null)
        'min_critical_detail_px': minCriticalDetailPx,
      if (enableEnvironmentCheck != null)
        'enable_environment_check': enableEnvironmentCheck,
      if (enablePixelLimitProtection != null)
        'enable_pixel_limit_protection': enablePixelLimitProtection,
      if (endReason != null) 'end_reason': endReason,
      if (estimatedLogMar != null) 'estimated_log_mar': estimatedLogMar,
      if (decimalAcuity != null) 'decimal_acuity': decimalAcuity,
      if (fivePointAcuity != null) 'five_point_acuity': fivePointAcuity,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctQuestions != null) 'correct_questions': correctQuestions,
      if (accuracy != null) 'accuracy': accuracy,
      if (meanResponseTimeMs != null)
        'mean_response_time_ms': meanResponseTimeMs,
      if (reversalStdDev != null) 'reversal_std_dev': reversalStdDev,
      if (pixelLimitEncountered != null)
        'pixel_limit_encountered': pixelLimitEncountered,
      if (retestRecommended != null) 'retest_recommended': retestRecommended,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TestSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? screenProfileId,
      Value<String?>? calibrationProfileId,
      Value<String>? eyeSide,
      Value<String>? testMode,
      Value<String>? inputMode,
      Value<double>? testDistanceMm,
      Value<double>? startLogMar,
      Value<double>? minLogMar,
      Value<double>? maxLogMar,
      Value<double>? stepLogMar,
      Value<int>? requiredCorrectForStepDown,
      Value<int>? allowedWrongForStepUp,
      Value<int>? requiredReversalCount,
      Value<int>? maxQuestionCount,
      Value<int>? answerTimeLimitMs,
      Value<double>? minCriticalDetailPx,
      Value<bool>? enableEnvironmentCheck,
      Value<bool>? enablePixelLimitProtection,
      Value<String>? endReason,
      Value<double?>? estimatedLogMar,
      Value<double?>? decimalAcuity,
      Value<double?>? fivePointAcuity,
      Value<int>? totalQuestions,
      Value<int>? correctQuestions,
      Value<double?>? accuracy,
      Value<double?>? meanResponseTimeMs,
      Value<double?>? reversalStdDev,
      Value<bool>? pixelLimitEncountered,
      Value<bool>? retestRecommended,
      Value<DateTime>? startedAt,
      Value<DateTime>? finishedAt,
      Value<int>? rowid}) {
    return TestSessionsCompanion(
      id: id ?? this.id,
      screenProfileId: screenProfileId ?? this.screenProfileId,
      calibrationProfileId: calibrationProfileId ?? this.calibrationProfileId,
      eyeSide: eyeSide ?? this.eyeSide,
      testMode: testMode ?? this.testMode,
      inputMode: inputMode ?? this.inputMode,
      testDistanceMm: testDistanceMm ?? this.testDistanceMm,
      startLogMar: startLogMar ?? this.startLogMar,
      minLogMar: minLogMar ?? this.minLogMar,
      maxLogMar: maxLogMar ?? this.maxLogMar,
      stepLogMar: stepLogMar ?? this.stepLogMar,
      requiredCorrectForStepDown:
          requiredCorrectForStepDown ?? this.requiredCorrectForStepDown,
      allowedWrongForStepUp:
          allowedWrongForStepUp ?? this.allowedWrongForStepUp,
      requiredReversalCount:
          requiredReversalCount ?? this.requiredReversalCount,
      maxQuestionCount: maxQuestionCount ?? this.maxQuestionCount,
      answerTimeLimitMs: answerTimeLimitMs ?? this.answerTimeLimitMs,
      minCriticalDetailPx: minCriticalDetailPx ?? this.minCriticalDetailPx,
      enableEnvironmentCheck:
          enableEnvironmentCheck ?? this.enableEnvironmentCheck,
      enablePixelLimitProtection:
          enablePixelLimitProtection ?? this.enablePixelLimitProtection,
      endReason: endReason ?? this.endReason,
      estimatedLogMar: estimatedLogMar ?? this.estimatedLogMar,
      decimalAcuity: decimalAcuity ?? this.decimalAcuity,
      fivePointAcuity: fivePointAcuity ?? this.fivePointAcuity,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctQuestions: correctQuestions ?? this.correctQuestions,
      accuracy: accuracy ?? this.accuracy,
      meanResponseTimeMs: meanResponseTimeMs ?? this.meanResponseTimeMs,
      reversalStdDev: reversalStdDev ?? this.reversalStdDev,
      pixelLimitEncountered:
          pixelLimitEncountered ?? this.pixelLimitEncountered,
      retestRecommended: retestRecommended ?? this.retestRecommended,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (screenProfileId.present) {
      map['screen_profile_id'] = Variable<String>(screenProfileId.value);
    }
    if (calibrationProfileId.present) {
      map['calibration_profile_id'] =
          Variable<String>(calibrationProfileId.value);
    }
    if (eyeSide.present) {
      map['eye_side'] = Variable<String>(eyeSide.value);
    }
    if (testMode.present) {
      map['test_mode'] = Variable<String>(testMode.value);
    }
    if (inputMode.present) {
      map['input_mode'] = Variable<String>(inputMode.value);
    }
    if (testDistanceMm.present) {
      map['test_distance_mm'] = Variable<double>(testDistanceMm.value);
    }
    if (startLogMar.present) {
      map['start_log_mar'] = Variable<double>(startLogMar.value);
    }
    if (minLogMar.present) {
      map['min_log_mar'] = Variable<double>(minLogMar.value);
    }
    if (maxLogMar.present) {
      map['max_log_mar'] = Variable<double>(maxLogMar.value);
    }
    if (stepLogMar.present) {
      map['step_log_mar'] = Variable<double>(stepLogMar.value);
    }
    if (requiredCorrectForStepDown.present) {
      map['required_correct_for_step_down'] =
          Variable<int>(requiredCorrectForStepDown.value);
    }
    if (allowedWrongForStepUp.present) {
      map['allowed_wrong_for_step_up'] =
          Variable<int>(allowedWrongForStepUp.value);
    }
    if (requiredReversalCount.present) {
      map['required_reversal_count'] =
          Variable<int>(requiredReversalCount.value);
    }
    if (maxQuestionCount.present) {
      map['max_question_count'] = Variable<int>(maxQuestionCount.value);
    }
    if (answerTimeLimitMs.present) {
      map['answer_time_limit_ms'] = Variable<int>(answerTimeLimitMs.value);
    }
    if (minCriticalDetailPx.present) {
      map['min_critical_detail_px'] =
          Variable<double>(minCriticalDetailPx.value);
    }
    if (enableEnvironmentCheck.present) {
      map['enable_environment_check'] =
          Variable<bool>(enableEnvironmentCheck.value);
    }
    if (enablePixelLimitProtection.present) {
      map['enable_pixel_limit_protection'] =
          Variable<bool>(enablePixelLimitProtection.value);
    }
    if (endReason.present) {
      map['end_reason'] = Variable<String>(endReason.value);
    }
    if (estimatedLogMar.present) {
      map['estimated_log_mar'] = Variable<double>(estimatedLogMar.value);
    }
    if (decimalAcuity.present) {
      map['decimal_acuity'] = Variable<double>(decimalAcuity.value);
    }
    if (fivePointAcuity.present) {
      map['five_point_acuity'] = Variable<double>(fivePointAcuity.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctQuestions.present) {
      map['correct_questions'] = Variable<int>(correctQuestions.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (meanResponseTimeMs.present) {
      map['mean_response_time_ms'] = Variable<double>(meanResponseTimeMs.value);
    }
    if (reversalStdDev.present) {
      map['reversal_std_dev'] = Variable<double>(reversalStdDev.value);
    }
    if (pixelLimitEncountered.present) {
      map['pixel_limit_encountered'] =
          Variable<bool>(pixelLimitEncountered.value);
    }
    if (retestRecommended.present) {
      map['retest_recommended'] = Variable<bool>(retestRecommended.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestSessionsCompanion(')
          ..write('id: $id, ')
          ..write('screenProfileId: $screenProfileId, ')
          ..write('calibrationProfileId: $calibrationProfileId, ')
          ..write('eyeSide: $eyeSide, ')
          ..write('testMode: $testMode, ')
          ..write('inputMode: $inputMode, ')
          ..write('testDistanceMm: $testDistanceMm, ')
          ..write('startLogMar: $startLogMar, ')
          ..write('minLogMar: $minLogMar, ')
          ..write('maxLogMar: $maxLogMar, ')
          ..write('stepLogMar: $stepLogMar, ')
          ..write('requiredCorrectForStepDown: $requiredCorrectForStepDown, ')
          ..write('allowedWrongForStepUp: $allowedWrongForStepUp, ')
          ..write('requiredReversalCount: $requiredReversalCount, ')
          ..write('maxQuestionCount: $maxQuestionCount, ')
          ..write('answerTimeLimitMs: $answerTimeLimitMs, ')
          ..write('minCriticalDetailPx: $minCriticalDetailPx, ')
          ..write('enableEnvironmentCheck: $enableEnvironmentCheck, ')
          ..write('enablePixelLimitProtection: $enablePixelLimitProtection, ')
          ..write('endReason: $endReason, ')
          ..write('estimatedLogMar: $estimatedLogMar, ')
          ..write('decimalAcuity: $decimalAcuity, ')
          ..write('fivePointAcuity: $fivePointAcuity, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctQuestions: $correctQuestions, ')
          ..write('accuracy: $accuracy, ')
          ..write('meanResponseTimeMs: $meanResponseTimeMs, ')
          ..write('reversalStdDev: $reversalStdDev, ')
          ..write('pixelLimitEncountered: $pixelLimitEncountered, ')
          ..write('retestRecommended: $retestRecommended, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionRecordsTable extends QuestionRecords
    with TableInfo<$QuestionRecordsTable, QuestionRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionIndexMeta =
      const VerificationMeta('questionIndex');
  @override
  late final GeneratedColumn<int> questionIndex = GeneratedColumn<int>(
      'question_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _eyeSideMeta =
      const VerificationMeta('eyeSide');
  @override
  late final GeneratedColumn<String> eyeSide = GeneratedColumn<String>(
      'eye_side', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testModeMeta =
      const VerificationMeta('testMode');
  @override
  late final GeneratedColumn<String> testMode = GeneratedColumn<String>(
      'test_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetLogMarMeta =
      const VerificationMeta('targetLogMar');
  @override
  late final GeneratedColumn<double> targetLogMar = GeneratedColumn<double>(
      'target_log_mar', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetDecimalAcuityMeta =
      const VerificationMeta('targetDecimalAcuity');
  @override
  late final GeneratedColumn<double> targetDecimalAcuity =
      GeneratedColumn<double>('target_decimal_acuity', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetFivePointAcuityMeta =
      const VerificationMeta('targetFivePointAcuity');
  @override
  late final GeneratedColumn<double> targetFivePointAcuity =
      GeneratedColumn<double>('target_five_point_acuity', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _displayedDirectionMeta =
      const VerificationMeta('displayedDirection');
  @override
  late final GeneratedColumn<String> displayedDirection =
      GeneratedColumn<String>('displayed_direction', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userAnswerMeta =
      const VerificationMeta('userAnswer');
  @override
  late final GeneratedColumn<String> userAnswer = GeneratedColumn<String>(
      'user_answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isTimeoutMeta =
      const VerificationMeta('isTimeout');
  @override
  late final GeneratedColumn<bool> isTimeout = GeneratedColumn<bool>(
      'is_timeout', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_timeout" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _responseTimeMsMeta =
      const VerificationMeta('responseTimeMs');
  @override
  late final GeneratedColumn<int> responseTimeMs = GeneratedColumn<int>(
      'response_time_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _testDistanceMmMeta =
      const VerificationMeta('testDistanceMm');
  @override
  late final GeneratedColumn<double> testDistanceMm = GeneratedColumn<double>(
      'test_distance_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _optotypeSizeMmMeta =
      const VerificationMeta('optotypeSizeMm');
  @override
  late final GeneratedColumn<double> optotypeSizeMm = GeneratedColumn<double>(
      'optotype_size_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _detailSizeMmMeta =
      const VerificationMeta('detailSizeMm');
  @override
  late final GeneratedColumn<double> detailSizeMm = GeneratedColumn<double>(
      'detail_size_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _optotypeWidthPxMeta =
      const VerificationMeta('optotypeWidthPx');
  @override
  late final GeneratedColumn<double> optotypeWidthPx = GeneratedColumn<double>(
      'optotype_width_px', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _optotypeHeightPxMeta =
      const VerificationMeta('optotypeHeightPx');
  @override
  late final GeneratedColumn<double> optotypeHeightPx = GeneratedColumn<double>(
      'optotype_height_px', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _detailWidthPxMeta =
      const VerificationMeta('detailWidthPx');
  @override
  late final GeneratedColumn<double> detailWidthPx = GeneratedColumn<double>(
      'detail_width_px', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _detailHeightPxMeta =
      const VerificationMeta('detailHeightPx');
  @override
  late final GeneratedColumn<double> detailHeightPx = GeneratedColumn<double>(
      'detail_height_px', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _criticalDetailPxMeta =
      const VerificationMeta('criticalDetailPx');
  @override
  late final GeneratedColumn<double> criticalDetailPx = GeneratedColumn<double>(
      'critical_detail_px', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pixelLimitReachedMeta =
      const VerificationMeta('pixelLimitReached');
  @override
  late final GeneratedColumn<bool> pixelLimitReached = GeneratedColumn<bool>(
      'pixel_limit_reached', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pixel_limit_reached" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _shownAtMeta =
      const VerificationMeta('shownAt');
  @override
  late final GeneratedColumn<DateTime> shownAt = GeneratedColumn<DateTime>(
      'shown_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _answeredAtMeta =
      const VerificationMeta('answeredAt');
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
      'answered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        questionIndex,
        eyeSide,
        testMode,
        targetLogMar,
        targetDecimalAcuity,
        targetFivePointAcuity,
        displayedDirection,
        userAnswer,
        isCorrect,
        isTimeout,
        responseTimeMs,
        testDistanceMm,
        optotypeSizeMm,
        detailSizeMm,
        optotypeWidthPx,
        optotypeHeightPx,
        detailWidthPx,
        detailHeightPx,
        criticalDetailPx,
        pixelLimitReached,
        shownAt,
        answeredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_records';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionRecordRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('question_index')) {
      context.handle(
          _questionIndexMeta,
          questionIndex.isAcceptableOrUnknown(
              data['question_index']!, _questionIndexMeta));
    } else if (isInserting) {
      context.missing(_questionIndexMeta);
    }
    if (data.containsKey('eye_side')) {
      context.handle(_eyeSideMeta,
          eyeSide.isAcceptableOrUnknown(data['eye_side']!, _eyeSideMeta));
    } else if (isInserting) {
      context.missing(_eyeSideMeta);
    }
    if (data.containsKey('test_mode')) {
      context.handle(_testModeMeta,
          testMode.isAcceptableOrUnknown(data['test_mode']!, _testModeMeta));
    } else if (isInserting) {
      context.missing(_testModeMeta);
    }
    if (data.containsKey('target_log_mar')) {
      context.handle(
          _targetLogMarMeta,
          targetLogMar.isAcceptableOrUnknown(
              data['target_log_mar']!, _targetLogMarMeta));
    } else if (isInserting) {
      context.missing(_targetLogMarMeta);
    }
    if (data.containsKey('target_decimal_acuity')) {
      context.handle(
          _targetDecimalAcuityMeta,
          targetDecimalAcuity.isAcceptableOrUnknown(
              data['target_decimal_acuity']!, _targetDecimalAcuityMeta));
    } else if (isInserting) {
      context.missing(_targetDecimalAcuityMeta);
    }
    if (data.containsKey('target_five_point_acuity')) {
      context.handle(
          _targetFivePointAcuityMeta,
          targetFivePointAcuity.isAcceptableOrUnknown(
              data['target_five_point_acuity']!, _targetFivePointAcuityMeta));
    } else if (isInserting) {
      context.missing(_targetFivePointAcuityMeta);
    }
    if (data.containsKey('displayed_direction')) {
      context.handle(
          _displayedDirectionMeta,
          displayedDirection.isAcceptableOrUnknown(
              data['displayed_direction']!, _displayedDirectionMeta));
    } else if (isInserting) {
      context.missing(_displayedDirectionMeta);
    }
    if (data.containsKey('user_answer')) {
      context.handle(
          _userAnswerMeta,
          userAnswer.isAcceptableOrUnknown(
              data['user_answer']!, _userAnswerMeta));
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    }
    if (data.containsKey('is_timeout')) {
      context.handle(_isTimeoutMeta,
          isTimeout.isAcceptableOrUnknown(data['is_timeout']!, _isTimeoutMeta));
    }
    if (data.containsKey('response_time_ms')) {
      context.handle(
          _responseTimeMsMeta,
          responseTimeMs.isAcceptableOrUnknown(
              data['response_time_ms']!, _responseTimeMsMeta));
    } else if (isInserting) {
      context.missing(_responseTimeMsMeta);
    }
    if (data.containsKey('test_distance_mm')) {
      context.handle(
          _testDistanceMmMeta,
          testDistanceMm.isAcceptableOrUnknown(
              data['test_distance_mm']!, _testDistanceMmMeta));
    } else if (isInserting) {
      context.missing(_testDistanceMmMeta);
    }
    if (data.containsKey('optotype_size_mm')) {
      context.handle(
          _optotypeSizeMmMeta,
          optotypeSizeMm.isAcceptableOrUnknown(
              data['optotype_size_mm']!, _optotypeSizeMmMeta));
    } else if (isInserting) {
      context.missing(_optotypeSizeMmMeta);
    }
    if (data.containsKey('detail_size_mm')) {
      context.handle(
          _detailSizeMmMeta,
          detailSizeMm.isAcceptableOrUnknown(
              data['detail_size_mm']!, _detailSizeMmMeta));
    } else if (isInserting) {
      context.missing(_detailSizeMmMeta);
    }
    if (data.containsKey('optotype_width_px')) {
      context.handle(
          _optotypeWidthPxMeta,
          optotypeWidthPx.isAcceptableOrUnknown(
              data['optotype_width_px']!, _optotypeWidthPxMeta));
    } else if (isInserting) {
      context.missing(_optotypeWidthPxMeta);
    }
    if (data.containsKey('optotype_height_px')) {
      context.handle(
          _optotypeHeightPxMeta,
          optotypeHeightPx.isAcceptableOrUnknown(
              data['optotype_height_px']!, _optotypeHeightPxMeta));
    } else if (isInserting) {
      context.missing(_optotypeHeightPxMeta);
    }
    if (data.containsKey('detail_width_px')) {
      context.handle(
          _detailWidthPxMeta,
          detailWidthPx.isAcceptableOrUnknown(
              data['detail_width_px']!, _detailWidthPxMeta));
    } else if (isInserting) {
      context.missing(_detailWidthPxMeta);
    }
    if (data.containsKey('detail_height_px')) {
      context.handle(
          _detailHeightPxMeta,
          detailHeightPx.isAcceptableOrUnknown(
              data['detail_height_px']!, _detailHeightPxMeta));
    } else if (isInserting) {
      context.missing(_detailHeightPxMeta);
    }
    if (data.containsKey('critical_detail_px')) {
      context.handle(
          _criticalDetailPxMeta,
          criticalDetailPx.isAcceptableOrUnknown(
              data['critical_detail_px']!, _criticalDetailPxMeta));
    } else if (isInserting) {
      context.missing(_criticalDetailPxMeta);
    }
    if (data.containsKey('pixel_limit_reached')) {
      context.handle(
          _pixelLimitReachedMeta,
          pixelLimitReached.isAcceptableOrUnknown(
              data['pixel_limit_reached']!, _pixelLimitReachedMeta));
    }
    if (data.containsKey('shown_at')) {
      context.handle(_shownAtMeta,
          shownAt.isAcceptableOrUnknown(data['shown_at']!, _shownAtMeta));
    } else if (isInserting) {
      context.missing(_shownAtMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
          _answeredAtMeta,
          answeredAt.isAcceptableOrUnknown(
              data['answered_at']!, _answeredAtMeta));
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {sessionId, questionIndex},
      ];
  @override
  QuestionRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionRecordRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      questionIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}question_index'])!,
      eyeSide: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}eye_side'])!,
      testMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}test_mode'])!,
      targetLogMar: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_log_mar'])!,
      targetDecimalAcuity: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}target_decimal_acuity'])!,
      targetFivePointAcuity: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}target_five_point_acuity'])!,
      displayedDirection: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}displayed_direction'])!,
      userAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_answer']),
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      isTimeout: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_timeout'])!,
      responseTimeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}response_time_ms'])!,
      testDistanceMm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}test_distance_mm'])!,
      optotypeSizeMm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}optotype_size_mm'])!,
      detailSizeMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}detail_size_mm'])!,
      optotypeWidthPx: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}optotype_width_px'])!,
      optotypeHeightPx: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}optotype_height_px'])!,
      detailWidthPx: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}detail_width_px'])!,
      detailHeightPx: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}detail_height_px'])!,
      criticalDetailPx: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}critical_detail_px'])!,
      pixelLimitReached: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}pixel_limit_reached'])!,
      shownAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}shown_at'])!,
      answeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
    );
  }

  @override
  $QuestionRecordsTable createAlias(String alias) {
    return $QuestionRecordsTable(attachedDatabase, alias);
  }
}

class QuestionRecordRow extends DataClass
    implements Insertable<QuestionRecordRow> {
  final int id;
  final String sessionId;
  final int questionIndex;
  final String eyeSide;
  final String testMode;
  final double targetLogMar;
  final double targetDecimalAcuity;
  final double targetFivePointAcuity;
  final String displayedDirection;
  final String? userAnswer;
  final bool isCorrect;
  final bool isTimeout;
  final int responseTimeMs;
  final double testDistanceMm;
  final double optotypeSizeMm;
  final double detailSizeMm;
  final double optotypeWidthPx;
  final double optotypeHeightPx;
  final double detailWidthPx;
  final double detailHeightPx;
  final double criticalDetailPx;
  final bool pixelLimitReached;
  final DateTime shownAt;
  final DateTime answeredAt;
  const QuestionRecordRow(
      {required this.id,
      required this.sessionId,
      required this.questionIndex,
      required this.eyeSide,
      required this.testMode,
      required this.targetLogMar,
      required this.targetDecimalAcuity,
      required this.targetFivePointAcuity,
      required this.displayedDirection,
      this.userAnswer,
      required this.isCorrect,
      required this.isTimeout,
      required this.responseTimeMs,
      required this.testDistanceMm,
      required this.optotypeSizeMm,
      required this.detailSizeMm,
      required this.optotypeWidthPx,
      required this.optotypeHeightPx,
      required this.detailWidthPx,
      required this.detailHeightPx,
      required this.criticalDetailPx,
      required this.pixelLimitReached,
      required this.shownAt,
      required this.answeredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['question_index'] = Variable<int>(questionIndex);
    map['eye_side'] = Variable<String>(eyeSide);
    map['test_mode'] = Variable<String>(testMode);
    map['target_log_mar'] = Variable<double>(targetLogMar);
    map['target_decimal_acuity'] = Variable<double>(targetDecimalAcuity);
    map['target_five_point_acuity'] = Variable<double>(targetFivePointAcuity);
    map['displayed_direction'] = Variable<String>(displayedDirection);
    if (!nullToAbsent || userAnswer != null) {
      map['user_answer'] = Variable<String>(userAnswer);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    map['is_timeout'] = Variable<bool>(isTimeout);
    map['response_time_ms'] = Variable<int>(responseTimeMs);
    map['test_distance_mm'] = Variable<double>(testDistanceMm);
    map['optotype_size_mm'] = Variable<double>(optotypeSizeMm);
    map['detail_size_mm'] = Variable<double>(detailSizeMm);
    map['optotype_width_px'] = Variable<double>(optotypeWidthPx);
    map['optotype_height_px'] = Variable<double>(optotypeHeightPx);
    map['detail_width_px'] = Variable<double>(detailWidthPx);
    map['detail_height_px'] = Variable<double>(detailHeightPx);
    map['critical_detail_px'] = Variable<double>(criticalDetailPx);
    map['pixel_limit_reached'] = Variable<bool>(pixelLimitReached);
    map['shown_at'] = Variable<DateTime>(shownAt);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  QuestionRecordsCompanion toCompanion(bool nullToAbsent) {
    return QuestionRecordsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      questionIndex: Value(questionIndex),
      eyeSide: Value(eyeSide),
      testMode: Value(testMode),
      targetLogMar: Value(targetLogMar),
      targetDecimalAcuity: Value(targetDecimalAcuity),
      targetFivePointAcuity: Value(targetFivePointAcuity),
      displayedDirection: Value(displayedDirection),
      userAnswer: userAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(userAnswer),
      isCorrect: Value(isCorrect),
      isTimeout: Value(isTimeout),
      responseTimeMs: Value(responseTimeMs),
      testDistanceMm: Value(testDistanceMm),
      optotypeSizeMm: Value(optotypeSizeMm),
      detailSizeMm: Value(detailSizeMm),
      optotypeWidthPx: Value(optotypeWidthPx),
      optotypeHeightPx: Value(optotypeHeightPx),
      detailWidthPx: Value(detailWidthPx),
      detailHeightPx: Value(detailHeightPx),
      criticalDetailPx: Value(criticalDetailPx),
      pixelLimitReached: Value(pixelLimitReached),
      shownAt: Value(shownAt),
      answeredAt: Value(answeredAt),
    );
  }

  factory QuestionRecordRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionRecordRow(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      questionIndex: serializer.fromJson<int>(json['questionIndex']),
      eyeSide: serializer.fromJson<String>(json['eyeSide']),
      testMode: serializer.fromJson<String>(json['testMode']),
      targetLogMar: serializer.fromJson<double>(json['targetLogMar']),
      targetDecimalAcuity:
          serializer.fromJson<double>(json['targetDecimalAcuity']),
      targetFivePointAcuity:
          serializer.fromJson<double>(json['targetFivePointAcuity']),
      displayedDirection:
          serializer.fromJson<String>(json['displayedDirection']),
      userAnswer: serializer.fromJson<String?>(json['userAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      isTimeout: serializer.fromJson<bool>(json['isTimeout']),
      responseTimeMs: serializer.fromJson<int>(json['responseTimeMs']),
      testDistanceMm: serializer.fromJson<double>(json['testDistanceMm']),
      optotypeSizeMm: serializer.fromJson<double>(json['optotypeSizeMm']),
      detailSizeMm: serializer.fromJson<double>(json['detailSizeMm']),
      optotypeWidthPx: serializer.fromJson<double>(json['optotypeWidthPx']),
      optotypeHeightPx: serializer.fromJson<double>(json['optotypeHeightPx']),
      detailWidthPx: serializer.fromJson<double>(json['detailWidthPx']),
      detailHeightPx: serializer.fromJson<double>(json['detailHeightPx']),
      criticalDetailPx: serializer.fromJson<double>(json['criticalDetailPx']),
      pixelLimitReached: serializer.fromJson<bool>(json['pixelLimitReached']),
      shownAt: serializer.fromJson<DateTime>(json['shownAt']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'questionIndex': serializer.toJson<int>(questionIndex),
      'eyeSide': serializer.toJson<String>(eyeSide),
      'testMode': serializer.toJson<String>(testMode),
      'targetLogMar': serializer.toJson<double>(targetLogMar),
      'targetDecimalAcuity': serializer.toJson<double>(targetDecimalAcuity),
      'targetFivePointAcuity': serializer.toJson<double>(targetFivePointAcuity),
      'displayedDirection': serializer.toJson<String>(displayedDirection),
      'userAnswer': serializer.toJson<String?>(userAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'isTimeout': serializer.toJson<bool>(isTimeout),
      'responseTimeMs': serializer.toJson<int>(responseTimeMs),
      'testDistanceMm': serializer.toJson<double>(testDistanceMm),
      'optotypeSizeMm': serializer.toJson<double>(optotypeSizeMm),
      'detailSizeMm': serializer.toJson<double>(detailSizeMm),
      'optotypeWidthPx': serializer.toJson<double>(optotypeWidthPx),
      'optotypeHeightPx': serializer.toJson<double>(optotypeHeightPx),
      'detailWidthPx': serializer.toJson<double>(detailWidthPx),
      'detailHeightPx': serializer.toJson<double>(detailHeightPx),
      'criticalDetailPx': serializer.toJson<double>(criticalDetailPx),
      'pixelLimitReached': serializer.toJson<bool>(pixelLimitReached),
      'shownAt': serializer.toJson<DateTime>(shownAt),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  QuestionRecordRow copyWith(
          {int? id,
          String? sessionId,
          int? questionIndex,
          String? eyeSide,
          String? testMode,
          double? targetLogMar,
          double? targetDecimalAcuity,
          double? targetFivePointAcuity,
          String? displayedDirection,
          Value<String?> userAnswer = const Value.absent(),
          bool? isCorrect,
          bool? isTimeout,
          int? responseTimeMs,
          double? testDistanceMm,
          double? optotypeSizeMm,
          double? detailSizeMm,
          double? optotypeWidthPx,
          double? optotypeHeightPx,
          double? detailWidthPx,
          double? detailHeightPx,
          double? criticalDetailPx,
          bool? pixelLimitReached,
          DateTime? shownAt,
          DateTime? answeredAt}) =>
      QuestionRecordRow(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        questionIndex: questionIndex ?? this.questionIndex,
        eyeSide: eyeSide ?? this.eyeSide,
        testMode: testMode ?? this.testMode,
        targetLogMar: targetLogMar ?? this.targetLogMar,
        targetDecimalAcuity: targetDecimalAcuity ?? this.targetDecimalAcuity,
        targetFivePointAcuity:
            targetFivePointAcuity ?? this.targetFivePointAcuity,
        displayedDirection: displayedDirection ?? this.displayedDirection,
        userAnswer: userAnswer.present ? userAnswer.value : this.userAnswer,
        isCorrect: isCorrect ?? this.isCorrect,
        isTimeout: isTimeout ?? this.isTimeout,
        responseTimeMs: responseTimeMs ?? this.responseTimeMs,
        testDistanceMm: testDistanceMm ?? this.testDistanceMm,
        optotypeSizeMm: optotypeSizeMm ?? this.optotypeSizeMm,
        detailSizeMm: detailSizeMm ?? this.detailSizeMm,
        optotypeWidthPx: optotypeWidthPx ?? this.optotypeWidthPx,
        optotypeHeightPx: optotypeHeightPx ?? this.optotypeHeightPx,
        detailWidthPx: detailWidthPx ?? this.detailWidthPx,
        detailHeightPx: detailHeightPx ?? this.detailHeightPx,
        criticalDetailPx: criticalDetailPx ?? this.criticalDetailPx,
        pixelLimitReached: pixelLimitReached ?? this.pixelLimitReached,
        shownAt: shownAt ?? this.shownAt,
        answeredAt: answeredAt ?? this.answeredAt,
      );
  QuestionRecordRow copyWithCompanion(QuestionRecordsCompanion data) {
    return QuestionRecordRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      questionIndex: data.questionIndex.present
          ? data.questionIndex.value
          : this.questionIndex,
      eyeSide: data.eyeSide.present ? data.eyeSide.value : this.eyeSide,
      testMode: data.testMode.present ? data.testMode.value : this.testMode,
      targetLogMar: data.targetLogMar.present
          ? data.targetLogMar.value
          : this.targetLogMar,
      targetDecimalAcuity: data.targetDecimalAcuity.present
          ? data.targetDecimalAcuity.value
          : this.targetDecimalAcuity,
      targetFivePointAcuity: data.targetFivePointAcuity.present
          ? data.targetFivePointAcuity.value
          : this.targetFivePointAcuity,
      displayedDirection: data.displayedDirection.present
          ? data.displayedDirection.value
          : this.displayedDirection,
      userAnswer:
          data.userAnswer.present ? data.userAnswer.value : this.userAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      isTimeout: data.isTimeout.present ? data.isTimeout.value : this.isTimeout,
      responseTimeMs: data.responseTimeMs.present
          ? data.responseTimeMs.value
          : this.responseTimeMs,
      testDistanceMm: data.testDistanceMm.present
          ? data.testDistanceMm.value
          : this.testDistanceMm,
      optotypeSizeMm: data.optotypeSizeMm.present
          ? data.optotypeSizeMm.value
          : this.optotypeSizeMm,
      detailSizeMm: data.detailSizeMm.present
          ? data.detailSizeMm.value
          : this.detailSizeMm,
      optotypeWidthPx: data.optotypeWidthPx.present
          ? data.optotypeWidthPx.value
          : this.optotypeWidthPx,
      optotypeHeightPx: data.optotypeHeightPx.present
          ? data.optotypeHeightPx.value
          : this.optotypeHeightPx,
      detailWidthPx: data.detailWidthPx.present
          ? data.detailWidthPx.value
          : this.detailWidthPx,
      detailHeightPx: data.detailHeightPx.present
          ? data.detailHeightPx.value
          : this.detailHeightPx,
      criticalDetailPx: data.criticalDetailPx.present
          ? data.criticalDetailPx.value
          : this.criticalDetailPx,
      pixelLimitReached: data.pixelLimitReached.present
          ? data.pixelLimitReached.value
          : this.pixelLimitReached,
      shownAt: data.shownAt.present ? data.shownAt.value : this.shownAt,
      answeredAt:
          data.answeredAt.present ? data.answeredAt.value : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionRecordRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionIndex: $questionIndex, ')
          ..write('eyeSide: $eyeSide, ')
          ..write('testMode: $testMode, ')
          ..write('targetLogMar: $targetLogMar, ')
          ..write('targetDecimalAcuity: $targetDecimalAcuity, ')
          ..write('targetFivePointAcuity: $targetFivePointAcuity, ')
          ..write('displayedDirection: $displayedDirection, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('isTimeout: $isTimeout, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('testDistanceMm: $testDistanceMm, ')
          ..write('optotypeSizeMm: $optotypeSizeMm, ')
          ..write('detailSizeMm: $detailSizeMm, ')
          ..write('optotypeWidthPx: $optotypeWidthPx, ')
          ..write('optotypeHeightPx: $optotypeHeightPx, ')
          ..write('detailWidthPx: $detailWidthPx, ')
          ..write('detailHeightPx: $detailHeightPx, ')
          ..write('criticalDetailPx: $criticalDetailPx, ')
          ..write('pixelLimitReached: $pixelLimitReached, ')
          ..write('shownAt: $shownAt, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        sessionId,
        questionIndex,
        eyeSide,
        testMode,
        targetLogMar,
        targetDecimalAcuity,
        targetFivePointAcuity,
        displayedDirection,
        userAnswer,
        isCorrect,
        isTimeout,
        responseTimeMs,
        testDistanceMm,
        optotypeSizeMm,
        detailSizeMm,
        optotypeWidthPx,
        optotypeHeightPx,
        detailWidthPx,
        detailHeightPx,
        criticalDetailPx,
        pixelLimitReached,
        shownAt,
        answeredAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionRecordRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.questionIndex == this.questionIndex &&
          other.eyeSide == this.eyeSide &&
          other.testMode == this.testMode &&
          other.targetLogMar == this.targetLogMar &&
          other.targetDecimalAcuity == this.targetDecimalAcuity &&
          other.targetFivePointAcuity == this.targetFivePointAcuity &&
          other.displayedDirection == this.displayedDirection &&
          other.userAnswer == this.userAnswer &&
          other.isCorrect == this.isCorrect &&
          other.isTimeout == this.isTimeout &&
          other.responseTimeMs == this.responseTimeMs &&
          other.testDistanceMm == this.testDistanceMm &&
          other.optotypeSizeMm == this.optotypeSizeMm &&
          other.detailSizeMm == this.detailSizeMm &&
          other.optotypeWidthPx == this.optotypeWidthPx &&
          other.optotypeHeightPx == this.optotypeHeightPx &&
          other.detailWidthPx == this.detailWidthPx &&
          other.detailHeightPx == this.detailHeightPx &&
          other.criticalDetailPx == this.criticalDetailPx &&
          other.pixelLimitReached == this.pixelLimitReached &&
          other.shownAt == this.shownAt &&
          other.answeredAt == this.answeredAt);
}

class QuestionRecordsCompanion extends UpdateCompanion<QuestionRecordRow> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> questionIndex;
  final Value<String> eyeSide;
  final Value<String> testMode;
  final Value<double> targetLogMar;
  final Value<double> targetDecimalAcuity;
  final Value<double> targetFivePointAcuity;
  final Value<String> displayedDirection;
  final Value<String?> userAnswer;
  final Value<bool> isCorrect;
  final Value<bool> isTimeout;
  final Value<int> responseTimeMs;
  final Value<double> testDistanceMm;
  final Value<double> optotypeSizeMm;
  final Value<double> detailSizeMm;
  final Value<double> optotypeWidthPx;
  final Value<double> optotypeHeightPx;
  final Value<double> detailWidthPx;
  final Value<double> detailHeightPx;
  final Value<double> criticalDetailPx;
  final Value<bool> pixelLimitReached;
  final Value<DateTime> shownAt;
  final Value<DateTime> answeredAt;
  const QuestionRecordsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.questionIndex = const Value.absent(),
    this.eyeSide = const Value.absent(),
    this.testMode = const Value.absent(),
    this.targetLogMar = const Value.absent(),
    this.targetDecimalAcuity = const Value.absent(),
    this.targetFivePointAcuity = const Value.absent(),
    this.displayedDirection = const Value.absent(),
    this.userAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.isTimeout = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.testDistanceMm = const Value.absent(),
    this.optotypeSizeMm = const Value.absent(),
    this.detailSizeMm = const Value.absent(),
    this.optotypeWidthPx = const Value.absent(),
    this.optotypeHeightPx = const Value.absent(),
    this.detailWidthPx = const Value.absent(),
    this.detailHeightPx = const Value.absent(),
    this.criticalDetailPx = const Value.absent(),
    this.pixelLimitReached = const Value.absent(),
    this.shownAt = const Value.absent(),
    this.answeredAt = const Value.absent(),
  });
  QuestionRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int questionIndex,
    required String eyeSide,
    required String testMode,
    required double targetLogMar,
    required double targetDecimalAcuity,
    required double targetFivePointAcuity,
    required String displayedDirection,
    this.userAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.isTimeout = const Value.absent(),
    required int responseTimeMs,
    required double testDistanceMm,
    required double optotypeSizeMm,
    required double detailSizeMm,
    required double optotypeWidthPx,
    required double optotypeHeightPx,
    required double detailWidthPx,
    required double detailHeightPx,
    required double criticalDetailPx,
    this.pixelLimitReached = const Value.absent(),
    required DateTime shownAt,
    required DateTime answeredAt,
  })  : sessionId = Value(sessionId),
        questionIndex = Value(questionIndex),
        eyeSide = Value(eyeSide),
        testMode = Value(testMode),
        targetLogMar = Value(targetLogMar),
        targetDecimalAcuity = Value(targetDecimalAcuity),
        targetFivePointAcuity = Value(targetFivePointAcuity),
        displayedDirection = Value(displayedDirection),
        responseTimeMs = Value(responseTimeMs),
        testDistanceMm = Value(testDistanceMm),
        optotypeSizeMm = Value(optotypeSizeMm),
        detailSizeMm = Value(detailSizeMm),
        optotypeWidthPx = Value(optotypeWidthPx),
        optotypeHeightPx = Value(optotypeHeightPx),
        detailWidthPx = Value(detailWidthPx),
        detailHeightPx = Value(detailHeightPx),
        criticalDetailPx = Value(criticalDetailPx),
        shownAt = Value(shownAt),
        answeredAt = Value(answeredAt);
  static Insertable<QuestionRecordRow> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? questionIndex,
    Expression<String>? eyeSide,
    Expression<String>? testMode,
    Expression<double>? targetLogMar,
    Expression<double>? targetDecimalAcuity,
    Expression<double>? targetFivePointAcuity,
    Expression<String>? displayedDirection,
    Expression<String>? userAnswer,
    Expression<bool>? isCorrect,
    Expression<bool>? isTimeout,
    Expression<int>? responseTimeMs,
    Expression<double>? testDistanceMm,
    Expression<double>? optotypeSizeMm,
    Expression<double>? detailSizeMm,
    Expression<double>? optotypeWidthPx,
    Expression<double>? optotypeHeightPx,
    Expression<double>? detailWidthPx,
    Expression<double>? detailHeightPx,
    Expression<double>? criticalDetailPx,
    Expression<bool>? pixelLimitReached,
    Expression<DateTime>? shownAt,
    Expression<DateTime>? answeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (questionIndex != null) 'question_index': questionIndex,
      if (eyeSide != null) 'eye_side': eyeSide,
      if (testMode != null) 'test_mode': testMode,
      if (targetLogMar != null) 'target_log_mar': targetLogMar,
      if (targetDecimalAcuity != null)
        'target_decimal_acuity': targetDecimalAcuity,
      if (targetFivePointAcuity != null)
        'target_five_point_acuity': targetFivePointAcuity,
      if (displayedDirection != null) 'displayed_direction': displayedDirection,
      if (userAnswer != null) 'user_answer': userAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (isTimeout != null) 'is_timeout': isTimeout,
      if (responseTimeMs != null) 'response_time_ms': responseTimeMs,
      if (testDistanceMm != null) 'test_distance_mm': testDistanceMm,
      if (optotypeSizeMm != null) 'optotype_size_mm': optotypeSizeMm,
      if (detailSizeMm != null) 'detail_size_mm': detailSizeMm,
      if (optotypeWidthPx != null) 'optotype_width_px': optotypeWidthPx,
      if (optotypeHeightPx != null) 'optotype_height_px': optotypeHeightPx,
      if (detailWidthPx != null) 'detail_width_px': detailWidthPx,
      if (detailHeightPx != null) 'detail_height_px': detailHeightPx,
      if (criticalDetailPx != null) 'critical_detail_px': criticalDetailPx,
      if (pixelLimitReached != null) 'pixel_limit_reached': pixelLimitReached,
      if (shownAt != null) 'shown_at': shownAt,
      if (answeredAt != null) 'answered_at': answeredAt,
    });
  }

  QuestionRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? sessionId,
      Value<int>? questionIndex,
      Value<String>? eyeSide,
      Value<String>? testMode,
      Value<double>? targetLogMar,
      Value<double>? targetDecimalAcuity,
      Value<double>? targetFivePointAcuity,
      Value<String>? displayedDirection,
      Value<String?>? userAnswer,
      Value<bool>? isCorrect,
      Value<bool>? isTimeout,
      Value<int>? responseTimeMs,
      Value<double>? testDistanceMm,
      Value<double>? optotypeSizeMm,
      Value<double>? detailSizeMm,
      Value<double>? optotypeWidthPx,
      Value<double>? optotypeHeightPx,
      Value<double>? detailWidthPx,
      Value<double>? detailHeightPx,
      Value<double>? criticalDetailPx,
      Value<bool>? pixelLimitReached,
      Value<DateTime>? shownAt,
      Value<DateTime>? answeredAt}) {
    return QuestionRecordsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      questionIndex: questionIndex ?? this.questionIndex,
      eyeSide: eyeSide ?? this.eyeSide,
      testMode: testMode ?? this.testMode,
      targetLogMar: targetLogMar ?? this.targetLogMar,
      targetDecimalAcuity: targetDecimalAcuity ?? this.targetDecimalAcuity,
      targetFivePointAcuity:
          targetFivePointAcuity ?? this.targetFivePointAcuity,
      displayedDirection: displayedDirection ?? this.displayedDirection,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      isTimeout: isTimeout ?? this.isTimeout,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      testDistanceMm: testDistanceMm ?? this.testDistanceMm,
      optotypeSizeMm: optotypeSizeMm ?? this.optotypeSizeMm,
      detailSizeMm: detailSizeMm ?? this.detailSizeMm,
      optotypeWidthPx: optotypeWidthPx ?? this.optotypeWidthPx,
      optotypeHeightPx: optotypeHeightPx ?? this.optotypeHeightPx,
      detailWidthPx: detailWidthPx ?? this.detailWidthPx,
      detailHeightPx: detailHeightPx ?? this.detailHeightPx,
      criticalDetailPx: criticalDetailPx ?? this.criticalDetailPx,
      pixelLimitReached: pixelLimitReached ?? this.pixelLimitReached,
      shownAt: shownAt ?? this.shownAt,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (questionIndex.present) {
      map['question_index'] = Variable<int>(questionIndex.value);
    }
    if (eyeSide.present) {
      map['eye_side'] = Variable<String>(eyeSide.value);
    }
    if (testMode.present) {
      map['test_mode'] = Variable<String>(testMode.value);
    }
    if (targetLogMar.present) {
      map['target_log_mar'] = Variable<double>(targetLogMar.value);
    }
    if (targetDecimalAcuity.present) {
      map['target_decimal_acuity'] =
          Variable<double>(targetDecimalAcuity.value);
    }
    if (targetFivePointAcuity.present) {
      map['target_five_point_acuity'] =
          Variable<double>(targetFivePointAcuity.value);
    }
    if (displayedDirection.present) {
      map['displayed_direction'] = Variable<String>(displayedDirection.value);
    }
    if (userAnswer.present) {
      map['user_answer'] = Variable<String>(userAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (isTimeout.present) {
      map['is_timeout'] = Variable<bool>(isTimeout.value);
    }
    if (responseTimeMs.present) {
      map['response_time_ms'] = Variable<int>(responseTimeMs.value);
    }
    if (testDistanceMm.present) {
      map['test_distance_mm'] = Variable<double>(testDistanceMm.value);
    }
    if (optotypeSizeMm.present) {
      map['optotype_size_mm'] = Variable<double>(optotypeSizeMm.value);
    }
    if (detailSizeMm.present) {
      map['detail_size_mm'] = Variable<double>(detailSizeMm.value);
    }
    if (optotypeWidthPx.present) {
      map['optotype_width_px'] = Variable<double>(optotypeWidthPx.value);
    }
    if (optotypeHeightPx.present) {
      map['optotype_height_px'] = Variable<double>(optotypeHeightPx.value);
    }
    if (detailWidthPx.present) {
      map['detail_width_px'] = Variable<double>(detailWidthPx.value);
    }
    if (detailHeightPx.present) {
      map['detail_height_px'] = Variable<double>(detailHeightPx.value);
    }
    if (criticalDetailPx.present) {
      map['critical_detail_px'] = Variable<double>(criticalDetailPx.value);
    }
    if (pixelLimitReached.present) {
      map['pixel_limit_reached'] = Variable<bool>(pixelLimitReached.value);
    }
    if (shownAt.present) {
      map['shown_at'] = Variable<DateTime>(shownAt.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionIndex: $questionIndex, ')
          ..write('eyeSide: $eyeSide, ')
          ..write('testMode: $testMode, ')
          ..write('targetLogMar: $targetLogMar, ')
          ..write('targetDecimalAcuity: $targetDecimalAcuity, ')
          ..write('targetFivePointAcuity: $targetFivePointAcuity, ')
          ..write('displayedDirection: $displayedDirection, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('isTimeout: $isTimeout, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('testDistanceMm: $testDistanceMm, ')
          ..write('optotypeSizeMm: $optotypeSizeMm, ')
          ..write('detailSizeMm: $detailSizeMm, ')
          ..write('optotypeWidthPx: $optotypeWidthPx, ')
          ..write('optotypeHeightPx: $optotypeHeightPx, ')
          ..write('detailWidthPx: $detailWidthPx, ')
          ..write('detailHeightPx: $detailHeightPx, ')
          ..write('criticalDetailPx: $criticalDetailPx, ')
          ..write('pixelLimitReached: $pixelLimitReached, ')
          ..write('shownAt: $shownAt, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScreenProfilesTable screenProfiles = $ScreenProfilesTable(this);
  late final $TestSessionsTable testSessions = $TestSessionsTable(this);
  late final $QuestionRecordsTable questionRecords =
      $QuestionRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [screenProfiles, testSessions, questionRecords];
}

typedef $$ScreenProfilesTableCreateCompanionBuilder = ScreenProfilesCompanion
    Function({
  required String id,
  required String deviceName,
  required double screenWidthMm,
  required double screenHeightMm,
  required int screenWidthPx,
  required int screenHeightPx,
  required double devicePixelRatio,
  Value<bool> isDpiAware,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ScreenProfilesTableUpdateCompanionBuilder = ScreenProfilesCompanion
    Function({
  Value<String> id,
  Value<String> deviceName,
  Value<double> screenWidthMm,
  Value<double> screenHeightMm,
  Value<int> screenWidthPx,
  Value<int> screenHeightPx,
  Value<double> devicePixelRatio,
  Value<bool> isDpiAware,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ScreenProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ScreenProfilesTable> {
  $$ScreenProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceName => $composableBuilder(
      column: $table.deviceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get screenWidthMm => $composableBuilder(
      column: $table.screenWidthMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get screenHeightMm => $composableBuilder(
      column: $table.screenHeightMm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get screenWidthPx => $composableBuilder(
      column: $table.screenWidthPx, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get screenHeightPx => $composableBuilder(
      column: $table.screenHeightPx,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get devicePixelRatio => $composableBuilder(
      column: $table.devicePixelRatio,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDpiAware => $composableBuilder(
      column: $table.isDpiAware, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ScreenProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScreenProfilesTable> {
  $$ScreenProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceName => $composableBuilder(
      column: $table.deviceName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get screenWidthMm => $composableBuilder(
      column: $table.screenWidthMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get screenHeightMm => $composableBuilder(
      column: $table.screenHeightMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get screenWidthPx => $composableBuilder(
      column: $table.screenWidthPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get screenHeightPx => $composableBuilder(
      column: $table.screenHeightPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get devicePixelRatio => $composableBuilder(
      column: $table.devicePixelRatio,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDpiAware => $composableBuilder(
      column: $table.isDpiAware, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ScreenProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScreenProfilesTable> {
  $$ScreenProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
      column: $table.deviceName, builder: (column) => column);

  GeneratedColumn<double> get screenWidthMm => $composableBuilder(
      column: $table.screenWidthMm, builder: (column) => column);

  GeneratedColumn<double> get screenHeightMm => $composableBuilder(
      column: $table.screenHeightMm, builder: (column) => column);

  GeneratedColumn<int> get screenWidthPx => $composableBuilder(
      column: $table.screenWidthPx, builder: (column) => column);

  GeneratedColumn<int> get screenHeightPx => $composableBuilder(
      column: $table.screenHeightPx, builder: (column) => column);

  GeneratedColumn<double> get devicePixelRatio => $composableBuilder(
      column: $table.devicePixelRatio, builder: (column) => column);

  GeneratedColumn<bool> get isDpiAware => $composableBuilder(
      column: $table.isDpiAware, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ScreenProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScreenProfilesTable,
    ScreenProfileRow,
    $$ScreenProfilesTableFilterComposer,
    $$ScreenProfilesTableOrderingComposer,
    $$ScreenProfilesTableAnnotationComposer,
    $$ScreenProfilesTableCreateCompanionBuilder,
    $$ScreenProfilesTableUpdateCompanionBuilder,
    (
      ScreenProfileRow,
      BaseReferences<_$AppDatabase, $ScreenProfilesTable, ScreenProfileRow>
    ),
    ScreenProfileRow,
    PrefetchHooks Function()> {
  $$ScreenProfilesTableTableManager(
      _$AppDatabase db, $ScreenProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScreenProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScreenProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScreenProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> deviceName = const Value.absent(),
            Value<double> screenWidthMm = const Value.absent(),
            Value<double> screenHeightMm = const Value.absent(),
            Value<int> screenWidthPx = const Value.absent(),
            Value<int> screenHeightPx = const Value.absent(),
            Value<double> devicePixelRatio = const Value.absent(),
            Value<bool> isDpiAware = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScreenProfilesCompanion(
            id: id,
            deviceName: deviceName,
            screenWidthMm: screenWidthMm,
            screenHeightMm: screenHeightMm,
            screenWidthPx: screenWidthPx,
            screenHeightPx: screenHeightPx,
            devicePixelRatio: devicePixelRatio,
            isDpiAware: isDpiAware,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String deviceName,
            required double screenWidthMm,
            required double screenHeightMm,
            required int screenWidthPx,
            required int screenHeightPx,
            required double devicePixelRatio,
            Value<bool> isDpiAware = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScreenProfilesCompanion.insert(
            id: id,
            deviceName: deviceName,
            screenWidthMm: screenWidthMm,
            screenHeightMm: screenHeightMm,
            screenWidthPx: screenWidthPx,
            screenHeightPx: screenHeightPx,
            devicePixelRatio: devicePixelRatio,
            isDpiAware: isDpiAware,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScreenProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScreenProfilesTable,
    ScreenProfileRow,
    $$ScreenProfilesTableFilterComposer,
    $$ScreenProfilesTableOrderingComposer,
    $$ScreenProfilesTableAnnotationComposer,
    $$ScreenProfilesTableCreateCompanionBuilder,
    $$ScreenProfilesTableUpdateCompanionBuilder,
    (
      ScreenProfileRow,
      BaseReferences<_$AppDatabase, $ScreenProfilesTable, ScreenProfileRow>
    ),
    ScreenProfileRow,
    PrefetchHooks Function()>;
typedef $$TestSessionsTableCreateCompanionBuilder = TestSessionsCompanion
    Function({
  required String id,
  Value<String?> screenProfileId,
  Value<String?> calibrationProfileId,
  required String eyeSide,
  required String testMode,
  required String inputMode,
  required double testDistanceMm,
  required double startLogMar,
  required double minLogMar,
  required double maxLogMar,
  required double stepLogMar,
  required int requiredCorrectForStepDown,
  required int allowedWrongForStepUp,
  required int requiredReversalCount,
  required int maxQuestionCount,
  required int answerTimeLimitMs,
  required double minCriticalDetailPx,
  Value<bool> enableEnvironmentCheck,
  Value<bool> enablePixelLimitProtection,
  required String endReason,
  Value<double?> estimatedLogMar,
  Value<double?> decimalAcuity,
  Value<double?> fivePointAcuity,
  Value<int> totalQuestions,
  Value<int> correctQuestions,
  Value<double?> accuracy,
  Value<double?> meanResponseTimeMs,
  Value<double?> reversalStdDev,
  Value<bool> pixelLimitEncountered,
  Value<bool> retestRecommended,
  required DateTime startedAt,
  required DateTime finishedAt,
  Value<int> rowid,
});
typedef $$TestSessionsTableUpdateCompanionBuilder = TestSessionsCompanion
    Function({
  Value<String> id,
  Value<String?> screenProfileId,
  Value<String?> calibrationProfileId,
  Value<String> eyeSide,
  Value<String> testMode,
  Value<String> inputMode,
  Value<double> testDistanceMm,
  Value<double> startLogMar,
  Value<double> minLogMar,
  Value<double> maxLogMar,
  Value<double> stepLogMar,
  Value<int> requiredCorrectForStepDown,
  Value<int> allowedWrongForStepUp,
  Value<int> requiredReversalCount,
  Value<int> maxQuestionCount,
  Value<int> answerTimeLimitMs,
  Value<double> minCriticalDetailPx,
  Value<bool> enableEnvironmentCheck,
  Value<bool> enablePixelLimitProtection,
  Value<String> endReason,
  Value<double?> estimatedLogMar,
  Value<double?> decimalAcuity,
  Value<double?> fivePointAcuity,
  Value<int> totalQuestions,
  Value<int> correctQuestions,
  Value<double?> accuracy,
  Value<double?> meanResponseTimeMs,
  Value<double?> reversalStdDev,
  Value<bool> pixelLimitEncountered,
  Value<bool> retestRecommended,
  Value<DateTime> startedAt,
  Value<DateTime> finishedAt,
  Value<int> rowid,
});

class $$TestSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $TestSessionsTable> {
  $$TestSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get screenProfileId => $composableBuilder(
      column: $table.screenProfileId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get calibrationProfileId => $composableBuilder(
      column: $table.calibrationProfileId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eyeSide => $composableBuilder(
      column: $table.eyeSide, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get testMode => $composableBuilder(
      column: $table.testMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputMode => $composableBuilder(
      column: $table.inputMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get testDistanceMm => $composableBuilder(
      column: $table.testDistanceMm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get startLogMar => $composableBuilder(
      column: $table.startLogMar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minLogMar => $composableBuilder(
      column: $table.minLogMar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxLogMar => $composableBuilder(
      column: $table.maxLogMar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stepLogMar => $composableBuilder(
      column: $table.stepLogMar, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requiredCorrectForStepDown => $composableBuilder(
      column: $table.requiredCorrectForStepDown,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get allowedWrongForStepUp => $composableBuilder(
      column: $table.allowedWrongForStepUp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requiredReversalCount => $composableBuilder(
      column: $table.requiredReversalCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxQuestionCount => $composableBuilder(
      column: $table.maxQuestionCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get answerTimeLimitMs => $composableBuilder(
      column: $table.answerTimeLimitMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minCriticalDetailPx => $composableBuilder(
      column: $table.minCriticalDetailPx,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableEnvironmentCheck => $composableBuilder(
      column: $table.enableEnvironmentCheck,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enablePixelLimitProtection => $composableBuilder(
      column: $table.enablePixelLimitProtection,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endReason => $composableBuilder(
      column: $table.endReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get estimatedLogMar => $composableBuilder(
      column: $table.estimatedLogMar,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get decimalAcuity => $composableBuilder(
      column: $table.decimalAcuity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fivePointAcuity => $composableBuilder(
      column: $table.fivePointAcuity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctQuestions => $composableBuilder(
      column: $table.correctQuestions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get meanResponseTimeMs => $composableBuilder(
      column: $table.meanResponseTimeMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get reversalStdDev => $composableBuilder(
      column: $table.reversalStdDev,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pixelLimitEncountered => $composableBuilder(
      column: $table.pixelLimitEncountered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get retestRecommended => $composableBuilder(
      column: $table.retestRecommended,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnFilters(column));
}

class $$TestSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestSessionsTable> {
  $$TestSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get screenProfileId => $composableBuilder(
      column: $table.screenProfileId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get calibrationProfileId => $composableBuilder(
      column: $table.calibrationProfileId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eyeSide => $composableBuilder(
      column: $table.eyeSide, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get testMode => $composableBuilder(
      column: $table.testMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputMode => $composableBuilder(
      column: $table.inputMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get testDistanceMm => $composableBuilder(
      column: $table.testDistanceMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get startLogMar => $composableBuilder(
      column: $table.startLogMar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minLogMar => $composableBuilder(
      column: $table.minLogMar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxLogMar => $composableBuilder(
      column: $table.maxLogMar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stepLogMar => $composableBuilder(
      column: $table.stepLogMar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requiredCorrectForStepDown => $composableBuilder(
      column: $table.requiredCorrectForStepDown,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get allowedWrongForStepUp => $composableBuilder(
      column: $table.allowedWrongForStepUp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requiredReversalCount => $composableBuilder(
      column: $table.requiredReversalCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxQuestionCount => $composableBuilder(
      column: $table.maxQuestionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get answerTimeLimitMs => $composableBuilder(
      column: $table.answerTimeLimitMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minCriticalDetailPx => $composableBuilder(
      column: $table.minCriticalDetailPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableEnvironmentCheck => $composableBuilder(
      column: $table.enableEnvironmentCheck,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enablePixelLimitProtection => $composableBuilder(
      column: $table.enablePixelLimitProtection,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endReason => $composableBuilder(
      column: $table.endReason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get estimatedLogMar => $composableBuilder(
      column: $table.estimatedLogMar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get decimalAcuity => $composableBuilder(
      column: $table.decimalAcuity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fivePointAcuity => $composableBuilder(
      column: $table.fivePointAcuity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctQuestions => $composableBuilder(
      column: $table.correctQuestions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get meanResponseTimeMs => $composableBuilder(
      column: $table.meanResponseTimeMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get reversalStdDev => $composableBuilder(
      column: $table.reversalStdDev,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pixelLimitEncountered => $composableBuilder(
      column: $table.pixelLimitEncountered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get retestRecommended => $composableBuilder(
      column: $table.retestRecommended,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => ColumnOrderings(column));
}

class $$TestSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestSessionsTable> {
  $$TestSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get screenProfileId => $composableBuilder(
      column: $table.screenProfileId, builder: (column) => column);

  GeneratedColumn<String> get calibrationProfileId => $composableBuilder(
      column: $table.calibrationProfileId, builder: (column) => column);

  GeneratedColumn<String> get eyeSide =>
      $composableBuilder(column: $table.eyeSide, builder: (column) => column);

  GeneratedColumn<String> get testMode =>
      $composableBuilder(column: $table.testMode, builder: (column) => column);

  GeneratedColumn<String> get inputMode =>
      $composableBuilder(column: $table.inputMode, builder: (column) => column);

  GeneratedColumn<double> get testDistanceMm => $composableBuilder(
      column: $table.testDistanceMm, builder: (column) => column);

  GeneratedColumn<double> get startLogMar => $composableBuilder(
      column: $table.startLogMar, builder: (column) => column);

  GeneratedColumn<double> get minLogMar =>
      $composableBuilder(column: $table.minLogMar, builder: (column) => column);

  GeneratedColumn<double> get maxLogMar =>
      $composableBuilder(column: $table.maxLogMar, builder: (column) => column);

  GeneratedColumn<double> get stepLogMar => $composableBuilder(
      column: $table.stepLogMar, builder: (column) => column);

  GeneratedColumn<int> get requiredCorrectForStepDown => $composableBuilder(
      column: $table.requiredCorrectForStepDown, builder: (column) => column);

  GeneratedColumn<int> get allowedWrongForStepUp => $composableBuilder(
      column: $table.allowedWrongForStepUp, builder: (column) => column);

  GeneratedColumn<int> get requiredReversalCount => $composableBuilder(
      column: $table.requiredReversalCount, builder: (column) => column);

  GeneratedColumn<int> get maxQuestionCount => $composableBuilder(
      column: $table.maxQuestionCount, builder: (column) => column);

  GeneratedColumn<int> get answerTimeLimitMs => $composableBuilder(
      column: $table.answerTimeLimitMs, builder: (column) => column);

  GeneratedColumn<double> get minCriticalDetailPx => $composableBuilder(
      column: $table.minCriticalDetailPx, builder: (column) => column);

  GeneratedColumn<bool> get enableEnvironmentCheck => $composableBuilder(
      column: $table.enableEnvironmentCheck, builder: (column) => column);

  GeneratedColumn<bool> get enablePixelLimitProtection => $composableBuilder(
      column: $table.enablePixelLimitProtection, builder: (column) => column);

  GeneratedColumn<String> get endReason =>
      $composableBuilder(column: $table.endReason, builder: (column) => column);

  GeneratedColumn<double> get estimatedLogMar => $composableBuilder(
      column: $table.estimatedLogMar, builder: (column) => column);

  GeneratedColumn<double> get decimalAcuity => $composableBuilder(
      column: $table.decimalAcuity, builder: (column) => column);

  GeneratedColumn<double> get fivePointAcuity => $composableBuilder(
      column: $table.fivePointAcuity, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions, builder: (column) => column);

  GeneratedColumn<int> get correctQuestions => $composableBuilder(
      column: $table.correctQuestions, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get meanResponseTimeMs => $composableBuilder(
      column: $table.meanResponseTimeMs, builder: (column) => column);

  GeneratedColumn<double> get reversalStdDev => $composableBuilder(
      column: $table.reversalStdDev, builder: (column) => column);

  GeneratedColumn<bool> get pixelLimitEncountered => $composableBuilder(
      column: $table.pixelLimitEncountered, builder: (column) => column);

  GeneratedColumn<bool> get retestRecommended => $composableBuilder(
      column: $table.retestRecommended, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
      column: $table.finishedAt, builder: (column) => column);
}

class $$TestSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TestSessionsTable,
    TestSessionRow,
    $$TestSessionsTableFilterComposer,
    $$TestSessionsTableOrderingComposer,
    $$TestSessionsTableAnnotationComposer,
    $$TestSessionsTableCreateCompanionBuilder,
    $$TestSessionsTableUpdateCompanionBuilder,
    (
      TestSessionRow,
      BaseReferences<_$AppDatabase, $TestSessionsTable, TestSessionRow>
    ),
    TestSessionRow,
    PrefetchHooks Function()> {
  $$TestSessionsTableTableManager(_$AppDatabase db, $TestSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> screenProfileId = const Value.absent(),
            Value<String?> calibrationProfileId = const Value.absent(),
            Value<String> eyeSide = const Value.absent(),
            Value<String> testMode = const Value.absent(),
            Value<String> inputMode = const Value.absent(),
            Value<double> testDistanceMm = const Value.absent(),
            Value<double> startLogMar = const Value.absent(),
            Value<double> minLogMar = const Value.absent(),
            Value<double> maxLogMar = const Value.absent(),
            Value<double> stepLogMar = const Value.absent(),
            Value<int> requiredCorrectForStepDown = const Value.absent(),
            Value<int> allowedWrongForStepUp = const Value.absent(),
            Value<int> requiredReversalCount = const Value.absent(),
            Value<int> maxQuestionCount = const Value.absent(),
            Value<int> answerTimeLimitMs = const Value.absent(),
            Value<double> minCriticalDetailPx = const Value.absent(),
            Value<bool> enableEnvironmentCheck = const Value.absent(),
            Value<bool> enablePixelLimitProtection = const Value.absent(),
            Value<String> endReason = const Value.absent(),
            Value<double?> estimatedLogMar = const Value.absent(),
            Value<double?> decimalAcuity = const Value.absent(),
            Value<double?> fivePointAcuity = const Value.absent(),
            Value<int> totalQuestions = const Value.absent(),
            Value<int> correctQuestions = const Value.absent(),
            Value<double?> accuracy = const Value.absent(),
            Value<double?> meanResponseTimeMs = const Value.absent(),
            Value<double?> reversalStdDev = const Value.absent(),
            Value<bool> pixelLimitEncountered = const Value.absent(),
            Value<bool> retestRecommended = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime> finishedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TestSessionsCompanion(
            id: id,
            screenProfileId: screenProfileId,
            calibrationProfileId: calibrationProfileId,
            eyeSide: eyeSide,
            testMode: testMode,
            inputMode: inputMode,
            testDistanceMm: testDistanceMm,
            startLogMar: startLogMar,
            minLogMar: minLogMar,
            maxLogMar: maxLogMar,
            stepLogMar: stepLogMar,
            requiredCorrectForStepDown: requiredCorrectForStepDown,
            allowedWrongForStepUp: allowedWrongForStepUp,
            requiredReversalCount: requiredReversalCount,
            maxQuestionCount: maxQuestionCount,
            answerTimeLimitMs: answerTimeLimitMs,
            minCriticalDetailPx: minCriticalDetailPx,
            enableEnvironmentCheck: enableEnvironmentCheck,
            enablePixelLimitProtection: enablePixelLimitProtection,
            endReason: endReason,
            estimatedLogMar: estimatedLogMar,
            decimalAcuity: decimalAcuity,
            fivePointAcuity: fivePointAcuity,
            totalQuestions: totalQuestions,
            correctQuestions: correctQuestions,
            accuracy: accuracy,
            meanResponseTimeMs: meanResponseTimeMs,
            reversalStdDev: reversalStdDev,
            pixelLimitEncountered: pixelLimitEncountered,
            retestRecommended: retestRecommended,
            startedAt: startedAt,
            finishedAt: finishedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> screenProfileId = const Value.absent(),
            Value<String?> calibrationProfileId = const Value.absent(),
            required String eyeSide,
            required String testMode,
            required String inputMode,
            required double testDistanceMm,
            required double startLogMar,
            required double minLogMar,
            required double maxLogMar,
            required double stepLogMar,
            required int requiredCorrectForStepDown,
            required int allowedWrongForStepUp,
            required int requiredReversalCount,
            required int maxQuestionCount,
            required int answerTimeLimitMs,
            required double minCriticalDetailPx,
            Value<bool> enableEnvironmentCheck = const Value.absent(),
            Value<bool> enablePixelLimitProtection = const Value.absent(),
            required String endReason,
            Value<double?> estimatedLogMar = const Value.absent(),
            Value<double?> decimalAcuity = const Value.absent(),
            Value<double?> fivePointAcuity = const Value.absent(),
            Value<int> totalQuestions = const Value.absent(),
            Value<int> correctQuestions = const Value.absent(),
            Value<double?> accuracy = const Value.absent(),
            Value<double?> meanResponseTimeMs = const Value.absent(),
            Value<double?> reversalStdDev = const Value.absent(),
            Value<bool> pixelLimitEncountered = const Value.absent(),
            Value<bool> retestRecommended = const Value.absent(),
            required DateTime startedAt,
            required DateTime finishedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TestSessionsCompanion.insert(
            id: id,
            screenProfileId: screenProfileId,
            calibrationProfileId: calibrationProfileId,
            eyeSide: eyeSide,
            testMode: testMode,
            inputMode: inputMode,
            testDistanceMm: testDistanceMm,
            startLogMar: startLogMar,
            minLogMar: minLogMar,
            maxLogMar: maxLogMar,
            stepLogMar: stepLogMar,
            requiredCorrectForStepDown: requiredCorrectForStepDown,
            allowedWrongForStepUp: allowedWrongForStepUp,
            requiredReversalCount: requiredReversalCount,
            maxQuestionCount: maxQuestionCount,
            answerTimeLimitMs: answerTimeLimitMs,
            minCriticalDetailPx: minCriticalDetailPx,
            enableEnvironmentCheck: enableEnvironmentCheck,
            enablePixelLimitProtection: enablePixelLimitProtection,
            endReason: endReason,
            estimatedLogMar: estimatedLogMar,
            decimalAcuity: decimalAcuity,
            fivePointAcuity: fivePointAcuity,
            totalQuestions: totalQuestions,
            correctQuestions: correctQuestions,
            accuracy: accuracy,
            meanResponseTimeMs: meanResponseTimeMs,
            reversalStdDev: reversalStdDev,
            pixelLimitEncountered: pixelLimitEncountered,
            retestRecommended: retestRecommended,
            startedAt: startedAt,
            finishedAt: finishedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TestSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TestSessionsTable,
    TestSessionRow,
    $$TestSessionsTableFilterComposer,
    $$TestSessionsTableOrderingComposer,
    $$TestSessionsTableAnnotationComposer,
    $$TestSessionsTableCreateCompanionBuilder,
    $$TestSessionsTableUpdateCompanionBuilder,
    (
      TestSessionRow,
      BaseReferences<_$AppDatabase, $TestSessionsTable, TestSessionRow>
    ),
    TestSessionRow,
    PrefetchHooks Function()>;
typedef $$QuestionRecordsTableCreateCompanionBuilder = QuestionRecordsCompanion
    Function({
  Value<int> id,
  required String sessionId,
  required int questionIndex,
  required String eyeSide,
  required String testMode,
  required double targetLogMar,
  required double targetDecimalAcuity,
  required double targetFivePointAcuity,
  required String displayedDirection,
  Value<String?> userAnswer,
  Value<bool> isCorrect,
  Value<bool> isTimeout,
  required int responseTimeMs,
  required double testDistanceMm,
  required double optotypeSizeMm,
  required double detailSizeMm,
  required double optotypeWidthPx,
  required double optotypeHeightPx,
  required double detailWidthPx,
  required double detailHeightPx,
  required double criticalDetailPx,
  Value<bool> pixelLimitReached,
  required DateTime shownAt,
  required DateTime answeredAt,
});
typedef $$QuestionRecordsTableUpdateCompanionBuilder = QuestionRecordsCompanion
    Function({
  Value<int> id,
  Value<String> sessionId,
  Value<int> questionIndex,
  Value<String> eyeSide,
  Value<String> testMode,
  Value<double> targetLogMar,
  Value<double> targetDecimalAcuity,
  Value<double> targetFivePointAcuity,
  Value<String> displayedDirection,
  Value<String?> userAnswer,
  Value<bool> isCorrect,
  Value<bool> isTimeout,
  Value<int> responseTimeMs,
  Value<double> testDistanceMm,
  Value<double> optotypeSizeMm,
  Value<double> detailSizeMm,
  Value<double> optotypeWidthPx,
  Value<double> optotypeHeightPx,
  Value<double> detailWidthPx,
  Value<double> detailHeightPx,
  Value<double> criticalDetailPx,
  Value<bool> pixelLimitReached,
  Value<DateTime> shownAt,
  Value<DateTime> answeredAt,
});

class $$QuestionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionRecordsTable> {
  $$QuestionRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get questionIndex => $composableBuilder(
      column: $table.questionIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eyeSide => $composableBuilder(
      column: $table.eyeSide, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get testMode => $composableBuilder(
      column: $table.testMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetLogMar => $composableBuilder(
      column: $table.targetLogMar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetDecimalAcuity => $composableBuilder(
      column: $table.targetDecimalAcuity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetFivePointAcuity => $composableBuilder(
      column: $table.targetFivePointAcuity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayedDirection => $composableBuilder(
      column: $table.displayedDirection,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userAnswer => $composableBuilder(
      column: $table.userAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTimeout => $composableBuilder(
      column: $table.isTimeout, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get responseTimeMs => $composableBuilder(
      column: $table.responseTimeMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get testDistanceMm => $composableBuilder(
      column: $table.testDistanceMm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get optotypeSizeMm => $composableBuilder(
      column: $table.optotypeSizeMm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get detailSizeMm => $composableBuilder(
      column: $table.detailSizeMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get optotypeWidthPx => $composableBuilder(
      column: $table.optotypeWidthPx,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get optotypeHeightPx => $composableBuilder(
      column: $table.optotypeHeightPx,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get detailWidthPx => $composableBuilder(
      column: $table.detailWidthPx, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get detailHeightPx => $composableBuilder(
      column: $table.detailHeightPx,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get criticalDetailPx => $composableBuilder(
      column: $table.criticalDetailPx,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pixelLimitReached => $composableBuilder(
      column: $table.pixelLimitReached,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get shownAt => $composableBuilder(
      column: $table.shownAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnFilters(column));
}

class $$QuestionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionRecordsTable> {
  $$QuestionRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get questionIndex => $composableBuilder(
      column: $table.questionIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eyeSide => $composableBuilder(
      column: $table.eyeSide, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get testMode => $composableBuilder(
      column: $table.testMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetLogMar => $composableBuilder(
      column: $table.targetLogMar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetDecimalAcuity => $composableBuilder(
      column: $table.targetDecimalAcuity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetFivePointAcuity => $composableBuilder(
      column: $table.targetFivePointAcuity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayedDirection => $composableBuilder(
      column: $table.displayedDirection,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userAnswer => $composableBuilder(
      column: $table.userAnswer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTimeout => $composableBuilder(
      column: $table.isTimeout, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get responseTimeMs => $composableBuilder(
      column: $table.responseTimeMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get testDistanceMm => $composableBuilder(
      column: $table.testDistanceMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get optotypeSizeMm => $composableBuilder(
      column: $table.optotypeSizeMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get detailSizeMm => $composableBuilder(
      column: $table.detailSizeMm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get optotypeWidthPx => $composableBuilder(
      column: $table.optotypeWidthPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get optotypeHeightPx => $composableBuilder(
      column: $table.optotypeHeightPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get detailWidthPx => $composableBuilder(
      column: $table.detailWidthPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get detailHeightPx => $composableBuilder(
      column: $table.detailHeightPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get criticalDetailPx => $composableBuilder(
      column: $table.criticalDetailPx,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pixelLimitReached => $composableBuilder(
      column: $table.pixelLimitReached,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get shownAt => $composableBuilder(
      column: $table.shownAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnOrderings(column));
}

class $$QuestionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionRecordsTable> {
  $$QuestionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get questionIndex => $composableBuilder(
      column: $table.questionIndex, builder: (column) => column);

  GeneratedColumn<String> get eyeSide =>
      $composableBuilder(column: $table.eyeSide, builder: (column) => column);

  GeneratedColumn<String> get testMode =>
      $composableBuilder(column: $table.testMode, builder: (column) => column);

  GeneratedColumn<double> get targetLogMar => $composableBuilder(
      column: $table.targetLogMar, builder: (column) => column);

  GeneratedColumn<double> get targetDecimalAcuity => $composableBuilder(
      column: $table.targetDecimalAcuity, builder: (column) => column);

  GeneratedColumn<double> get targetFivePointAcuity => $composableBuilder(
      column: $table.targetFivePointAcuity, builder: (column) => column);

  GeneratedColumn<String> get displayedDirection => $composableBuilder(
      column: $table.displayedDirection, builder: (column) => column);

  GeneratedColumn<String> get userAnswer => $composableBuilder(
      column: $table.userAnswer, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<bool> get isTimeout =>
      $composableBuilder(column: $table.isTimeout, builder: (column) => column);

  GeneratedColumn<int> get responseTimeMs => $composableBuilder(
      column: $table.responseTimeMs, builder: (column) => column);

  GeneratedColumn<double> get testDistanceMm => $composableBuilder(
      column: $table.testDistanceMm, builder: (column) => column);

  GeneratedColumn<double> get optotypeSizeMm => $composableBuilder(
      column: $table.optotypeSizeMm, builder: (column) => column);

  GeneratedColumn<double> get detailSizeMm => $composableBuilder(
      column: $table.detailSizeMm, builder: (column) => column);

  GeneratedColumn<double> get optotypeWidthPx => $composableBuilder(
      column: $table.optotypeWidthPx, builder: (column) => column);

  GeneratedColumn<double> get optotypeHeightPx => $composableBuilder(
      column: $table.optotypeHeightPx, builder: (column) => column);

  GeneratedColumn<double> get detailWidthPx => $composableBuilder(
      column: $table.detailWidthPx, builder: (column) => column);

  GeneratedColumn<double> get detailHeightPx => $composableBuilder(
      column: $table.detailHeightPx, builder: (column) => column);

  GeneratedColumn<double> get criticalDetailPx => $composableBuilder(
      column: $table.criticalDetailPx, builder: (column) => column);

  GeneratedColumn<bool> get pixelLimitReached => $composableBuilder(
      column: $table.pixelLimitReached, builder: (column) => column);

  GeneratedColumn<DateTime> get shownAt =>
      $composableBuilder(column: $table.shownAt, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => column);
}

class $$QuestionRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionRecordsTable,
    QuestionRecordRow,
    $$QuestionRecordsTableFilterComposer,
    $$QuestionRecordsTableOrderingComposer,
    $$QuestionRecordsTableAnnotationComposer,
    $$QuestionRecordsTableCreateCompanionBuilder,
    $$QuestionRecordsTableUpdateCompanionBuilder,
    (
      QuestionRecordRow,
      BaseReferences<_$AppDatabase, $QuestionRecordsTable, QuestionRecordRow>
    ),
    QuestionRecordRow,
    PrefetchHooks Function()> {
  $$QuestionRecordsTableTableManager(
      _$AppDatabase db, $QuestionRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<int> questionIndex = const Value.absent(),
            Value<String> eyeSide = const Value.absent(),
            Value<String> testMode = const Value.absent(),
            Value<double> targetLogMar = const Value.absent(),
            Value<double> targetDecimalAcuity = const Value.absent(),
            Value<double> targetFivePointAcuity = const Value.absent(),
            Value<String> displayedDirection = const Value.absent(),
            Value<String?> userAnswer = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<bool> isTimeout = const Value.absent(),
            Value<int> responseTimeMs = const Value.absent(),
            Value<double> testDistanceMm = const Value.absent(),
            Value<double> optotypeSizeMm = const Value.absent(),
            Value<double> detailSizeMm = const Value.absent(),
            Value<double> optotypeWidthPx = const Value.absent(),
            Value<double> optotypeHeightPx = const Value.absent(),
            Value<double> detailWidthPx = const Value.absent(),
            Value<double> detailHeightPx = const Value.absent(),
            Value<double> criticalDetailPx = const Value.absent(),
            Value<bool> pixelLimitReached = const Value.absent(),
            Value<DateTime> shownAt = const Value.absent(),
            Value<DateTime> answeredAt = const Value.absent(),
          }) =>
              QuestionRecordsCompanion(
            id: id,
            sessionId: sessionId,
            questionIndex: questionIndex,
            eyeSide: eyeSide,
            testMode: testMode,
            targetLogMar: targetLogMar,
            targetDecimalAcuity: targetDecimalAcuity,
            targetFivePointAcuity: targetFivePointAcuity,
            displayedDirection: displayedDirection,
            userAnswer: userAnswer,
            isCorrect: isCorrect,
            isTimeout: isTimeout,
            responseTimeMs: responseTimeMs,
            testDistanceMm: testDistanceMm,
            optotypeSizeMm: optotypeSizeMm,
            detailSizeMm: detailSizeMm,
            optotypeWidthPx: optotypeWidthPx,
            optotypeHeightPx: optotypeHeightPx,
            detailWidthPx: detailWidthPx,
            detailHeightPx: detailHeightPx,
            criticalDetailPx: criticalDetailPx,
            pixelLimitReached: pixelLimitReached,
            shownAt: shownAt,
            answeredAt: answeredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sessionId,
            required int questionIndex,
            required String eyeSide,
            required String testMode,
            required double targetLogMar,
            required double targetDecimalAcuity,
            required double targetFivePointAcuity,
            required String displayedDirection,
            Value<String?> userAnswer = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<bool> isTimeout = const Value.absent(),
            required int responseTimeMs,
            required double testDistanceMm,
            required double optotypeSizeMm,
            required double detailSizeMm,
            required double optotypeWidthPx,
            required double optotypeHeightPx,
            required double detailWidthPx,
            required double detailHeightPx,
            required double criticalDetailPx,
            Value<bool> pixelLimitReached = const Value.absent(),
            required DateTime shownAt,
            required DateTime answeredAt,
          }) =>
              QuestionRecordsCompanion.insert(
            id: id,
            sessionId: sessionId,
            questionIndex: questionIndex,
            eyeSide: eyeSide,
            testMode: testMode,
            targetLogMar: targetLogMar,
            targetDecimalAcuity: targetDecimalAcuity,
            targetFivePointAcuity: targetFivePointAcuity,
            displayedDirection: displayedDirection,
            userAnswer: userAnswer,
            isCorrect: isCorrect,
            isTimeout: isTimeout,
            responseTimeMs: responseTimeMs,
            testDistanceMm: testDistanceMm,
            optotypeSizeMm: optotypeSizeMm,
            detailSizeMm: detailSizeMm,
            optotypeWidthPx: optotypeWidthPx,
            optotypeHeightPx: optotypeHeightPx,
            detailWidthPx: detailWidthPx,
            detailHeightPx: detailHeightPx,
            criticalDetailPx: criticalDetailPx,
            pixelLimitReached: pixelLimitReached,
            shownAt: shownAt,
            answeredAt: answeredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionRecordsTable,
    QuestionRecordRow,
    $$QuestionRecordsTableFilterComposer,
    $$QuestionRecordsTableOrderingComposer,
    $$QuestionRecordsTableAnnotationComposer,
    $$QuestionRecordsTableCreateCompanionBuilder,
    $$QuestionRecordsTableUpdateCompanionBuilder,
    (
      QuestionRecordRow,
      BaseReferences<_$AppDatabase, $QuestionRecordsTable, QuestionRecordRow>
    ),
    QuestionRecordRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScreenProfilesTableTableManager get screenProfiles =>
      $$ScreenProfilesTableTableManager(_db, _db.screenProfiles);
  $$TestSessionsTableTableManager get testSessions =>
      $$TestSessionsTableTableManager(_db, _db.testSessions);
  $$QuestionRecordsTableTableManager get questionRecords =>
      $$QuestionRecordsTableTableManager(_db, _db.questionRecords);
}
