import 'dart:convert';

import 'package:chp/models/chp_record.dart' as model;
import 'package:chp/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final record = model.CHPRecord(
    localId: 'record-1',
    chwId: 'CHW-KKG-04',
    patientId: 'CHW-KKG-04',
    patientName: 'Amina Example',
    villageName: 'Shibuye',
    visitType: 'Maternal',
    vitalsBP: '120/80',
    vitalsTemp: 37.2,
    urgencyLevel: 'Routine',
    visitNotes: 'Follow-up visit',
    createdAtLocal: DateTime.utc(2026, 10, 16, 12),
  );

  test('posts the project record schema to the REST sync endpoint', () async {
    http.Request? syncRequest;
    final client = MockClient((request) async {
      if (request.url.path == '/sync') {
        syncRequest = request;
        return http.Response(
          jsonEncode({'received': 1, 'inserted': 1, 'duplicates': 0}),
          200,
        );
      }
      return http.Response('', 204);
    });
    final service = SyncService(
      host: '127.0.0.1',
      port: 8080,
      client: client,
      tokenProvider: () => 'test-session-token',
    );
    addTearDown(service.dispose);

    await service.syncRecords([record]);

    expect(syncRequest?.method, 'POST');
    expect(syncRequest?.url, Uri.parse('http://127.0.0.1:8080/sync'));
    expect(syncRequest?.headers['Content-Type'], 'application/json');
    expect(
      syncRequest?.headers['Authorization'],
      'Bearer test-session-token',
    );
    final postedRecords = jsonDecode(syncRequest!.body) as List<dynamic>;
    final postedRecord = postedRecords.single as Map<String, dynamic>;
    expect(postedRecord['local_id'], record.localId);
    expect(postedRecord['chw_id'], record.chwId);
    expect(postedRecord['patient_id'], record.patientId);
    expect(postedRecord['patient_name'], record.patientName);
    expect(postedRecord['vitals_temp'], record.vitalsTemp);
    expect(postedRecord['created_at_local'], '2026-10-16T12:00:00.000Z');

    await service.checkHealth();
  });

  test('reports REST errors returned by the backend', () async {
    final service = SyncService(
      host: '127.0.0.1',
      tokenProvider: () => 'test-session-token',
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'error': 'record 0: invalid visit type'}),
          400,
        ),
      ),
    );
    addTearDown(service.dispose);

    await expectLater(
      service.syncRecords([record]),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('HTTP 400'),
        ),
      ),
    );
  });

  test('fails clearly when no REST API host is configured', () async {
    final service = SyncService(host: null, tokenProvider: () => null);
    addTearDown(service.dispose);

    await expectLater(
      service.syncRecords([record]),
      throwsA(isA<StateError>()),
    );
  });

  test('does not send a sync request without a signed-in staff token', () async {
    var requestSent = false;
    final service = SyncService(
      host: '127.0.0.1',
      tokenProvider: () => null,
      client: MockClient((_) async {
        requestSent = true;
        return http.Response('', 401);
      }),
    );
    addTearDown(service.dispose);

    await expectLater(
      service.syncRecords([record]),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('Sign in'),
        ),
      ),
    );
    expect(requestSent, isFalse);
  });
}
