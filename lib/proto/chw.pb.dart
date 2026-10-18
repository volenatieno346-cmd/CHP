// This is a generated file - do not edit.
//
// Generated from chw.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CHPRecord extends $pb.GeneratedMessage {
  factory CHPRecord({
    $core.String? localId,
    $core.String? chwId,
    $core.String? patientName,
    $core.String? villageName,
    $core.String? visitType,
    $core.String? vitalsBp,
    $core.double? vitalsTemp,
    $core.String? urgencyLevel,
    $core.String? visitNotes,
    $core.String? createdAtLocal,
    $core.String? syncStatus,
  }) {
    final result = CHPRecord._();
    if (localId != null) result.localId = localId;
    if (chwId != null) result.chwId = chwId;
    if (patientName != null) result.patientName = patientName;
    if (villageName != null) result.villageName = villageName;
    if (visitType != null) result.visitType = visitType;
    if (vitalsBp != null) result.vitalsBp = vitalsBp;
    if (vitalsTemp != null) result.vitalsTemp = vitalsTemp;
    if (urgencyLevel != null) result.urgencyLevel = urgencyLevel;
    if (visitNotes != null) result.visitNotes = visitNotes;
    if (createdAtLocal != null) result.createdAtLocal = createdAtLocal;
    if (syncStatus != null) result.syncStatus = syncStatus;
    return result;
  }

  CHPRecord._();

  factory CHPRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CHPRecord()..mergeFromBuffer(data, registry);
  factory CHPRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CHPRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CHPRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chp.v1'),
      createEmptyInstance: CHPRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'localId')
    ..aOS(2, _omitFieldNames ? '' : 'chwId')
    ..aOS(3, _omitFieldNames ? '' : 'patientName')
    ..aOS(4, _omitFieldNames ? '' : 'villageName')
    ..aOS(5, _omitFieldNames ? '' : 'visitType')
    ..aOS(6, _omitFieldNames ? '' : 'vitalsBp')
    ..aD(7, _omitFieldNames ? '' : 'vitalsTemp')
    ..aOS(8, _omitFieldNames ? '' : 'urgencyLevel')
    ..aOS(9, _omitFieldNames ? '' : 'visitNotes')
    ..aOS(10, _omitFieldNames ? '' : 'createdAtLocal')
    ..aOS(11, _omitFieldNames ? '' : 'syncStatus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CHPRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CHPRecord copyWith(void Function(CHPRecord) updates) =>
      super.copyWith((message) => updates(message as CHPRecord)) as CHPRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CHPRecord() / CHPRecord.new instead')
  static CHPRecord create() => CHPRecord._();
  static $pb.GeneratedMessage $_createMessage() => CHPRecord._();
  @$core.override
  CHPRecord createEmptyInstance() => CHPRecord._();
  @$core.pragma('dart2js:noInline')
  static CHPRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CHPRecord>(CHPRecord.$_createMessage);
  static CHPRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get localId => $_getSZ(0);
  @$pb.TagNumber(1)
  set localId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chwId => $_getSZ(1);
  @$pb.TagNumber(2)
  set chwId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChwId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChwId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientName => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get villageName => $_getSZ(3);
  @$pb.TagNumber(4)
  set villageName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVillageName() => $_has(3);
  @$pb.TagNumber(4)
  void clearVillageName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get visitType => $_getSZ(4);
  @$pb.TagNumber(5)
  set visitType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVisitType() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisitType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get vitalsBp => $_getSZ(5);
  @$pb.TagNumber(6)
  set vitalsBp($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVitalsBp() => $_has(5);
  @$pb.TagNumber(6)
  void clearVitalsBp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get vitalsTemp => $_getN(6);
  @$pb.TagNumber(7)
  set vitalsTemp($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVitalsTemp() => $_has(6);
  @$pb.TagNumber(7)
  void clearVitalsTemp() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get urgencyLevel => $_getSZ(7);
  @$pb.TagNumber(8)
  set urgencyLevel($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUrgencyLevel() => $_has(7);
  @$pb.TagNumber(8)
  void clearUrgencyLevel() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get visitNotes => $_getSZ(8);
  @$pb.TagNumber(9)
  set visitNotes($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVisitNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearVisitNotes() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get createdAtLocal => $_getSZ(9);
  @$pb.TagNumber(10)
  set createdAtLocal($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAtLocal() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAtLocal() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get syncStatus => $_getSZ(10);
  @$pb.TagNumber(11)
  set syncStatus($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSyncStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearSyncStatus() => $_clearField(11);
}

class SyncRecordsRequest extends $pb.GeneratedMessage {
  factory SyncRecordsRequest({
    $core.Iterable<CHPRecord>? records,
  }) {
    final result = SyncRecordsRequest._();
    if (records != null) result.records.addAll(records);
    return result;
  }

  SyncRecordsRequest._();

  factory SyncRecordsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncRecordsRequest()..mergeFromBuffer(data, registry);
  factory SyncRecordsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncRecordsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncRecordsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chp.v1'),
      createEmptyInstance: SyncRecordsRequest.$_createMessage)
    ..pPM<CHPRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: CHPRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncRecordsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncRecordsRequest copyWith(void Function(SyncRecordsRequest) updates) =>
      super.copyWith((message) => updates(message as SyncRecordsRequest))
          as SyncRecordsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SyncRecordsRequest() / SyncRecordsRequest.new instead')
  static SyncRecordsRequest create() => SyncRecordsRequest._();
  static $pb.GeneratedMessage $_createMessage() => SyncRecordsRequest._();
  @$core.override
  SyncRecordsRequest createEmptyInstance() => SyncRecordsRequest._();
  @$core.pragma('dart2js:noInline')
  static SyncRecordsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncRecordsRequest>(
          SyncRecordsRequest.$_createMessage);
  static SyncRecordsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CHPRecord> get records => $_getList(0);
}

class SyncRecordsResponse extends $pb.GeneratedMessage {
  factory SyncRecordsResponse({
    $core.int? received,
    $core.int? inserted,
    $core.int? duplicates,
  }) {
    final result = SyncRecordsResponse._();
    if (received != null) result.received = received;
    if (inserted != null) result.inserted = inserted;
    if (duplicates != null) result.duplicates = duplicates;
    return result;
  }

  SyncRecordsResponse._();

  factory SyncRecordsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncRecordsResponse()..mergeFromBuffer(data, registry);
  factory SyncRecordsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SyncRecordsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncRecordsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chp.v1'),
      createEmptyInstance: SyncRecordsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'received')
    ..aI(2, _omitFieldNames ? '' : 'inserted')
    ..aI(3, _omitFieldNames ? '' : 'duplicates')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncRecordsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncRecordsResponse copyWith(void Function(SyncRecordsResponse) updates) =>
      super.copyWith((message) => updates(message as SyncRecordsResponse))
          as SyncRecordsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use SyncRecordsResponse() / SyncRecordsResponse.new instead')
  static SyncRecordsResponse create() => SyncRecordsResponse._();
  static $pb.GeneratedMessage $_createMessage() => SyncRecordsResponse._();
  @$core.override
  SyncRecordsResponse createEmptyInstance() => SyncRecordsResponse._();
  @$core.pragma('dart2js:noInline')
  static SyncRecordsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncRecordsResponse>(
          SyncRecordsResponse.$_createMessage);
  static SyncRecordsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get received => $_getIZ(0);
  @$pb.TagNumber(1)
  set received($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceived() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceived() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get inserted => $_getIZ(1);
  @$pb.TagNumber(2)
  set inserted($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInserted() => $_has(1);
  @$pb.TagNumber(2)
  void clearInserted() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get duplicates => $_getIZ(2);
  @$pb.TagNumber(3)
  set duplicates($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuplicates() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuplicates() => $_clearField(3);
}

class HealthRequest extends $pb.GeneratedMessage {
  factory HealthRequest() => HealthRequest._();

  HealthRequest._();

  factory HealthRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthRequest()..mergeFromBuffer(data, registry);
  factory HealthRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chp.v1'),
      createEmptyInstance: HealthRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthRequest copyWith(void Function(HealthRequest) updates) =>
      super.copyWith((message) => updates(message as HealthRequest))
          as HealthRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HealthRequest() / HealthRequest.new instead')
  static HealthRequest create() => HealthRequest._();
  static $pb.GeneratedMessage $_createMessage() => HealthRequest._();
  @$core.override
  HealthRequest createEmptyInstance() => HealthRequest._();
  @$core.pragma('dart2js:noInline')
  static HealthRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HealthRequest>(
          HealthRequest.$_createMessage);
  static HealthRequest? _defaultInstance;
}

class HealthResponse extends $pb.GeneratedMessage {
  factory HealthResponse({
    $core.bool? healthy,
    $core.String? message,
  }) {
    final result = HealthResponse._();
    if (healthy != null) result.healthy = healthy;
    if (message != null) result.message = message;
    return result;
  }

  HealthResponse._();

  factory HealthResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthResponse()..mergeFromBuffer(data, registry);
  factory HealthResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chp.v1'),
      createEmptyInstance: HealthResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'healthy')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthResponse copyWith(void Function(HealthResponse) updates) =>
      super.copyWith((message) => updates(message as HealthResponse))
          as HealthResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HealthResponse() / HealthResponse.new instead')
  static HealthResponse create() => HealthResponse._();
  static $pb.GeneratedMessage $_createMessage() => HealthResponse._();
  @$core.override
  HealthResponse createEmptyInstance() => HealthResponse._();
  @$core.pragma('dart2js:noInline')
  static HealthResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HealthResponse>(
          HealthResponse.$_createMessage);
  static HealthResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get healthy => $_getBF(0);
  @$pb.TagNumber(1)
  set healthy($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHealthy() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealthy() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
