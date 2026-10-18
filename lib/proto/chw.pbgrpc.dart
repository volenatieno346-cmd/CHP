// This is a generated file - do not edit.
//
// Generated from chw.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chw.pb.dart' as $0;

export 'chw.pb.dart';

@$pb.GrpcServiceName('chp.v1.CHPRecords')
class CHPRecordsClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CHPRecordsClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SyncRecordsResponse> syncRecords(
    $0.SyncRecordsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$syncRecords, request, options: options);
  }

  $grpc.ResponseFuture<$0.HealthResponse> health(
    $0.HealthRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$health, request, options: options);
  }

  // method descriptors

  static final _$syncRecords =
      $grpc.ClientMethod<$0.SyncRecordsRequest, $0.SyncRecordsResponse>(
          '/chp.v1.CHPRecords/SyncRecords',
          ($0.SyncRecordsRequest value) => value.writeToBuffer(),
          $0.SyncRecordsResponse.fromBuffer);
  static final _$health =
      $grpc.ClientMethod<$0.HealthRequest, $0.HealthResponse>(
          '/chp.v1.CHPRecords/Health',
          ($0.HealthRequest value) => value.writeToBuffer(),
          $0.HealthResponse.fromBuffer);
}

@$pb.GrpcServiceName('chp.v1.CHPRecords')
abstract class CHPRecordsServiceBase extends $grpc.Service {
  $core.String get $name => 'chp.v1.CHPRecords';

  CHPRecordsServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.SyncRecordsRequest, $0.SyncRecordsResponse>(
            'SyncRecords',
            syncRecords_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SyncRecordsRequest.fromBuffer(value),
            ($0.SyncRecordsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HealthRequest, $0.HealthResponse>(
        'Health',
        health_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HealthRequest.fromBuffer(value),
        ($0.HealthResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SyncRecordsResponse> syncRecords_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SyncRecordsRequest> $request) async {
    return syncRecords($call, await $request);
  }

  $async.Future<$0.SyncRecordsResponse> syncRecords(
      $grpc.ServiceCall call, $0.SyncRecordsRequest request);

  $async.Future<$0.HealthResponse> health_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.HealthRequest> $request) async {
    return health($call, await $request);
  }

  $async.Future<$0.HealthResponse> health(
      $grpc.ServiceCall call, $0.HealthRequest request);
}
