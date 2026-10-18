// This is a generated file - do not edit.
//
// Generated from chw.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cHPRecordDescriptor instead')
const CHPRecord$json = {
  '1': 'CHPRecord',
  '2': [
    {'1': 'local_id', '3': 1, '4': 1, '5': 9, '10': 'localId'},
    {'1': 'chw_id', '3': 2, '4': 1, '5': 9, '10': 'chwId'},
    {'1': 'patient_name', '3': 3, '4': 1, '5': 9, '10': 'patientName'},
    {'1': 'village_name', '3': 4, '4': 1, '5': 9, '10': 'villageName'},
    {'1': 'visit_type', '3': 5, '4': 1, '5': 9, '10': 'visitType'},
    {'1': 'vitals_bp', '3': 6, '4': 1, '5': 9, '10': 'vitalsBp'},
    {'1': 'vitals_temp', '3': 7, '4': 1, '5': 1, '10': 'vitalsTemp'},
    {'1': 'urgency_level', '3': 8, '4': 1, '5': 9, '10': 'urgencyLevel'},
    {'1': 'visit_notes', '3': 9, '4': 1, '5': 9, '10': 'visitNotes'},
    {'1': 'created_at_local', '3': 10, '4': 1, '5': 9, '10': 'createdAtLocal'},
    {'1': 'sync_status', '3': 11, '4': 1, '5': 9, '10': 'syncStatus'},
  ],
};

/// Descriptor for `CHPRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cHPRecordDescriptor = $convert.base64Decode(
    'CglDSFBSZWNvcmQSGQoIbG9jYWxfaWQYASABKAlSB2xvY2FsSWQSFQoGY2h3X2lkGAIgASgJUg'
    'VjaHdJZBIhCgxwYXRpZW50X25hbWUYAyABKAlSC3BhdGllbnROYW1lEiEKDHZpbGxhZ2VfbmFt'
    'ZRgEIAEoCVILdmlsbGFnZU5hbWUSHQoKdmlzaXRfdHlwZRgFIAEoCVIJdmlzaXRUeXBlEhsKCX'
    'ZpdGFsc19icBgGIAEoCVIIdml0YWxzQnASHwoLdml0YWxzX3RlbXAYByABKAFSCnZpdGFsc1Rl'
    'bXASIwoNdXJnZW5jeV9sZXZlbBgIIAEoCVIMdXJnZW5jeUxldmVsEh8KC3Zpc2l0X25vdGVzGA'
    'kgASgJUgp2aXNpdE5vdGVzEigKEGNyZWF0ZWRfYXRfbG9jYWwYCiABKAlSDmNyZWF0ZWRBdExv'
    'Y2FsEh8KC3N5bmNfc3RhdHVzGAsgASgJUgpzeW5jU3RhdHVz');

@$core.Deprecated('Use syncRecordsRequestDescriptor instead')
const SyncRecordsRequest$json = {
  '1': 'SyncRecordsRequest',
  '2': [
    {
      '1': 'records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.chp.v1.CHPRecord',
      '10': 'records'
    },
  ],
};

/// Descriptor for `SyncRecordsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncRecordsRequestDescriptor = $convert.base64Decode(
    'ChJTeW5jUmVjb3Jkc1JlcXVlc3QSKwoHcmVjb3JkcxgBIAMoCzIRLmNocC52MS5DSFBSZWNvcm'
    'RSB3JlY29yZHM=');

@$core.Deprecated('Use syncRecordsResponseDescriptor instead')
const SyncRecordsResponse$json = {
  '1': 'SyncRecordsResponse',
  '2': [
    {'1': 'received', '3': 1, '4': 1, '5': 5, '10': 'received'},
    {'1': 'inserted', '3': 2, '4': 1, '5': 5, '10': 'inserted'},
    {'1': 'duplicates', '3': 3, '4': 1, '5': 5, '10': 'duplicates'},
  ],
};

/// Descriptor for `SyncRecordsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncRecordsResponseDescriptor = $convert.base64Decode(
    'ChNTeW5jUmVjb3Jkc1Jlc3BvbnNlEhoKCHJlY2VpdmVkGAEgASgFUghyZWNlaXZlZBIaCghpbn'
    'NlcnRlZBgCIAEoBVIIaW5zZXJ0ZWQSHgoKZHVwbGljYXRlcxgDIAEoBVIKZHVwbGljYXRlcw==');

@$core.Deprecated('Use healthRequestDescriptor instead')
const HealthRequest$json = {
  '1': 'HealthRequest',
};

/// Descriptor for `HealthRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthRequestDescriptor =
    $convert.base64Decode('Cg1IZWFsdGhSZXF1ZXN0');

@$core.Deprecated('Use healthResponseDescriptor instead')
const HealthResponse$json = {
  '1': 'HealthResponse',
  '2': [
    {'1': 'healthy', '3': 1, '4': 1, '5': 8, '10': 'healthy'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `HealthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthResponseDescriptor = $convert.base64Decode(
    'Cg5IZWFsdGhSZXNwb25zZRIYCgdoZWFsdGh5GAEgASgIUgdoZWFsdGh5EhgKB21lc3NhZ2UYAi'
    'ABKAlSB21lc3NhZ2U=');
