import 'package:chp/services/auth_service.dart';
import 'package:chp/state/auth_controller.dart';
import 'package:chp/ui/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

import 'dart:convert';

class _EmptySessionStorage implements SessionStorage {
  @override
  Future<void> clear() async {}

  @override
  Future<String?> readEmployerId() async => null;

  @override
  Future<String?> readToken() async => null;

  @override
  Future<void> save(AuthSession session) async {}
}

void main() {
  testWidgets('requires staff sign-in and offers registration', (tester) async {
    final auth = AuthController(
      authService: AuthService(
        host: '127.0.0.1',
        port: 8080,
        useTls: false,
        storage: _EmptySessionStorage(),
        client: MockClient((_) async => throw StateError('unexpected request')),
      ),
    );
    await auth.restore();
    addTearDown(auth.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>.value(
        value: auth,
        child: const MaterialApp(home: AuthGate()),
      ),
    );

    expect(find.text('Staff sign in'), findsOneWidget);
    expect(find.text('Employer / staff ID'), findsOneWidget);
    expect(find.text('Log Patient Visit'), findsNothing);

    await tester.tap(find.text('Not registered? Create an account'));
    await tester.pumpAndSettle();

    expect(find.text('Register staff account'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
  });

  testWidgets('shows the login error without a Bad state prefix', (
    tester,
  ) async {
    final auth = AuthController(
      authService: AuthService(
        host: '127.0.0.1',
        port: 8080,
        useTls: false,
        storage: _EmptySessionStorage(),
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'error': 'invalid employer ID or password'}),
            401,
          ),
        ),
      ),
    );
    await auth.restore();
    addTearDown(auth.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>.value(
        value: auth,
        child: const MaterialApp(home: AuthGate()),
      ),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'EMP-104');
    await tester.enterText(find.byType(TextFormField).at(1), 'bad-password');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Authentication failed (HTTP 401): invalid employer ID or password',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Bad state:'), findsNothing);
  });
}
