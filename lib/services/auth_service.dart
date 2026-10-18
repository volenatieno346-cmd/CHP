import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthSession {
  const AuthSession({required this.token, required this.employerId});

  final String token;
  final String employerId;
}

abstract interface class SessionStorage {
  Future<String?> readToken();
  Future<String?> readEmployerId();
  Future<void> save(AuthSession session);
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _employerIdKey = 'employer_id';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<String?> readEmployerId() => _storage.read(key: _employerIdKey);

  @override
  Future<void> save(AuthSession session) async {
    await _storage.write(key: _tokenKey, value: session.token);
    await _storage.write(key: _employerIdKey, value: session.employerId);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _employerIdKey);
  }
}

class AuthService {
  AuthService({
    required this.host,
    required this.port,
    required this.useTls,
    required this.storage,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String host;
  final int port;
  final bool useTls;
  final SessionStorage storage;
  final http.Client _client;

  Future<AuthSession?> restoreSession() async {
    final token = await storage.readToken();
    final employerId = await storage.readEmployerId();
    if (token == null || employerId == null) {
      await storage.clear();
      return null;
    }
    final cachedSession = AuthSession(token: token, employerId: employerId);
    late final http.Response response;
    try {
      response = await _client
          .get(_uri('/auth/me'), headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return cachedSession;
    } on http.ClientException {
      return cachedSession;
    }

    if (response.statusCode == 401) {
      await storage.clear();
      return null;
    }
    if (response.statusCode != 200) {
      return cachedSession;
    }
    final confirmedEmployerId = _decodeEmployerId(response.body);
    final session = AuthSession(token: token, employerId: confirmedEmployerId);
    await storage.save(session);
    return session;
  }

  Future<AuthSession> register({
    required String employerId,
    required String password,
  }) async {
    final uri = _uri('/auth/register');
    final response = await _postCredentials(
      uri,
      employerId: employerId,
      password: password,
    );
    if (response.statusCode != 201) {
      throw StateError(
        'Registration failed (HTTP ${response.statusCode}): '
        '${_responseMessage(response.body)}',
      );
    }
    return signIn(employerId: employerId, password: password);
  }

  Future<AuthSession> signIn({
    required String employerId,
    required String password,
  }) async {
    final uri = _uri('/auth/login');
    final response = await _postCredentials(
      uri,
      employerId: employerId,
      password: password,
    );
    if (response.statusCode != 200) {
      throw StateError(
        'Authentication failed (HTTP ${response.statusCode}): '
        '${_responseMessage(response.body)}',
      );
    }

    final session = _decodeSession(response.body);
    await storage.save(session);
    return session;
  }

  Future<http.Response> _postCredentials(
    Uri uri, {
    required String employerId,
    required String password,
  }) async {
    try {
      return await _client
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'employer_id': employerId.trim(),
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw StateError('Authentication request timed out.');
    } on http.ClientException catch (error) {
      throw StateError(
        'Could not reach the authentication server: ${error.message}',
      );
    }
  }

  Uri _uri(String path) {
    if (host.trim().isEmpty || port < 1 || port > 65535) {
      throw StateError('The API host or port is invalid.');
    }
    return Uri(
      scheme: useTls ? 'https' : 'http',
      host: host,
      port: port,
      path: path,
    );
  }

  AuthSession _decodeSession(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> &&
          decoded['access_token'] is String &&
          decoded['token_type'] == 'Bearer' &&
          decoded['employer_id'] is String) {
        final token = decoded['access_token']! as String;
        final employerId = decoded['employer_id']! as String;
        if (token.isEmpty || employerId.trim().isEmpty) {
          throw StateError(
            'The authentication server returned an invalid session.',
          );
        }
        return AuthSession(
          token: token,
          employerId: employerId,
        );
      }
    } on FormatException {
      throw StateError('The authentication server returned invalid JSON.');
    }
    throw StateError('The authentication server returned an invalid session.');
  }

  String _decodeEmployerId(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> && decoded['employer_id'] is String) {
        return decoded['employer_id']! as String;
      }
    } on FormatException {
      throw StateError('The authentication server returned invalid JSON.');
    }
    throw StateError('The authentication server returned an invalid identity.');
  }

  String _responseMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> && decoded['error'] is String) {
        return decoded['error']! as String;
      }
    } on FormatException {
      return body.isEmpty ? 'No error details returned.' : body;
    }
    return body.isEmpty ? 'No error details returned.' : body;
  }

  Future<void> signOut({required String? token}) async {
    await storage.clear();
    if (token == null || token.isEmpty) return;

    final uri = _uri('/auth/logout');
    late final http.Response response;
    try {
      response = await _client
          .post(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      throw StateError(
        'Signed out on this device, but server session revocation timed out.',
      );
    } on http.ClientException catch (error) {
      throw StateError(
        'Signed out on this device, but server session revocation failed: '
        '${error.message}',
      );
    }
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw StateError(
        'Signed out on this device, but server session revocation failed '
        '(HTTP ${response.statusCode}).',
      );
    }
  }

  void dispose() => _client.close();
}
