import 'dart:convert';

import 'package:chp/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _MemorySessionStorage implements SessionStorage {
  String? token;
  String? employerId;

  @override
  Future<void> clear() async {
    token = null;
    employerId = null;
  }

  @override
  Future<String?> readEmployerId() async => employerId;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> save(AuthSession session) async {
    token = session.token;
    employerId = session.employerId;
  }
}

void main() {
  test('registers with employer ID and stores the returned session', () async {
    final storage = _MemorySessionStorage();
    final requests = <http.Request>[];
    final service = AuthService(
      host: '127.0.0.1',
      port: 8080,
      useTls: false,
      storage: storage,
      client: MockClient((value) async {
        requests.add(value);
        if (value.url.path == '/auth/register') {
          return http.Response('', 201);
        }
        if (value.url.path == '/auth/me') {
          return http.Response(jsonEncode({'employer_id': 'EMP-104'}), 200);
        }
        return http.Response(
          jsonEncode({
            'access_token': 'opaque-token',
            'token_type': 'Bearer',
            'employer_id': 'EMP-104',
            'expires_at': '2026-11-16T01:53:56Z',
          }),
          200,
        );
      }),
    );
    addTearDown(service.dispose);

    final session = await service.register(
      employerId: ' EMP-104 ',
      password: 'correct-horse',
    );

    expect(jsonDecode(requests.first.body), {
      'employer_id': 'EMP-104',
      'password': 'correct-horse',
    });
    expect(session.token, 'opaque-token');
    expect(storage.token, 'opaque-token');
    expect(storage.employerId, 'EMP-104');
    final restored = await service.restoreSession();
    expect(requests.map((request) => request.url.path), [
      '/auth/register',
      '/auth/login',
      '/auth/me',
    ]);
    expect(restored?.token, session.token);
    expect(restored?.employerId, session.employerId);
  });

  test('reports login errors returned by the backend', () async {
    final service = AuthService(
      host: '127.0.0.1',
      port: 8080,
      useTls: false,
      storage: _MemorySessionStorage(),
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'error': 'invalid employer ID or password'}),
          401,
        ),
      ),
    );
    addTearDown(service.dispose);

    await expectLater(
      service.signIn(employerId: 'EMP-104', password: 'bad-password'),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('HTTP 401'),
        ),
      ),
    );
  });

  test('clears an expired cached session after auth/me returns unauthorized',
      () async {
    final storage = _MemorySessionStorage()
      ..token = 'expired-token'
      ..employerId = 'EMP-104';
    final service = AuthService(
      host: '127.0.0.1',
      port: 8080,
      useTls: false,
      storage: storage,
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'error': 'unauthorized'}),
          401,
        ),
      ),
    );
    addTearDown(service.dispose);

    expect(await service.restoreSession(), isNull);
    expect(storage.token, isNull);
    expect(storage.employerId, isNull);
  });

  test('revokes the bearer session when signing out', () async {
    final storage = _MemorySessionStorage()
      ..token = 'opaque-token'
      ..employerId = 'EMP-104';
    http.Request? request;
    final service = AuthService(
      host: '127.0.0.1',
      port: 8080,
      useTls: false,
      storage: storage,
      client: MockClient((value) async {
        request = value;
        return http.Response('', 204);
      }),
    );
    addTearDown(service.dispose);

    await service.signOut(token: 'opaque-token');

    expect(request?.url.path, '/auth/logout');
    expect(request?.headers['Authorization'], 'Bearer opaque-token');
    expect(storage.token, isNull);
    expect(storage.employerId, isNull);
  });
}
