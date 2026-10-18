import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/chp_record.dart' as model;

const _syncTimeout = Duration(seconds: 60);
const _healthTimeout = Duration(seconds: 5);

class SyncService {
  SyncService({
    required this.host,
    required this.tokenProvider,
    this.port = 8080,
    this.useTls = false,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String? host;
  final String? Function() tokenProvider;
  final int port;
  final bool useTls;
  final http.Client _client;

  Uri _uri(String path) {
    final configuredHost = host;
    if (configuredHost == null || configuredHost.trim().isEmpty) {
      throw StateError(
        'No REST API host is configured. Set API_HOST to enable sync.',
      );
    }
    if (port < 1 || port > 65535) {
      throw StateError('API_PORT must be between 1 and 65535.');
    }

    return Uri(
      scheme: useTls ? 'https' : 'http',
      host: configuredHost,
      port: port,
      path: path,
    );
  }

  Future<void> syncRecords(List<model.CHPRecord> records) async {
    if (records.isEmpty) return;

    final uri = _uri('/sync');
    final token = tokenProvider();
    if (token == null || token.isEmpty) {
      throw StateError('Sign in before syncing records.');
    }
    late final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(
              records.map((record) => record.toApiJson()).toList(),
            ),
          )
          .timeout(_syncTimeout);
    } on TimeoutException {
      throw StateError(
        'REST sync to $uri timed out after ${_syncTimeout.inSeconds}s.',
      );
    } on http.ClientException catch (error) {
      throw StateError('REST sync to $uri failed: ${error.message}');
    }

    if (response.statusCode != 200) {
      throw StateError(
        'REST sync failed (HTTP ${response.statusCode}): '
        '${_responseMessage(response.body)}',
      );
    }

    final result = _decodeResponse(response.body);
    if (result.received != records.length ||
        result.inserted + result.duplicates != records.length) {
      throw StateError('The REST server returned inconsistent sync counts.');
    }
  }

  Future<void> checkHealth() async {
    final uri = _uri('/healthz');
    late final http.Response response;
    try {
      response = await _client.get(uri).timeout(_healthTimeout);
    } on TimeoutException {
      throw StateError('REST health check to $uri timed out.');
    } on http.ClientException catch (error) {
      throw StateError('REST health check to $uri failed: ${error.message}');
    }

    if (response.statusCode != 204) {
      throw StateError(
        'REST health check failed (HTTP ${response.statusCode}): '
        '${_responseMessage(response.body)}',
      );
    }
  }

  ({int received, int inserted, int duplicates}) _decodeResponse(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final received = decoded['received'];
        final inserted = decoded['inserted'];
        final duplicates = decoded['duplicates'];
        if (received is int && inserted is int && duplicates is int) {
          return (
            received: received,
            inserted: inserted,
            duplicates: duplicates,
          );
        }
      }
    } on FormatException {
      throw StateError('The REST server returned invalid JSON for sync.');
    }
    throw StateError('The REST server returned an invalid sync response.');
  }

  String _responseMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> && decoded['error'] is String) {
        return decoded['error']! as String;
      }
    } on FormatException {
      // Keep the raw response body below for non-JSON server errors.
    }
    return body.isEmpty ? 'No error details returned.' : body;
  }

  void dispose() {
    _client.close();
  }
}
