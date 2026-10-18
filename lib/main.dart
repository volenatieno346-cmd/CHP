import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/chp_dao.dart';
import 'db/database_helper.dart';
import 'services/auth_service.dart';
import 'services/sync_service.dart';
import 'state/auth_controller.dart';
import 'state/sync_bloc.dart';
import 'ui/auth_screen.dart';

const _apiHost = String.fromEnvironment('API_HOST');
const _apiPort = int.fromEnvironment('API_PORT', defaultValue: 8080);
const _apiUseTls = bool.fromEnvironment('API_USE_TLS');

String get _defaultApiHost {
  if (kIsWeb) return 'localhost';
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => '10.0.2.2',
    TargetPlatform.iOS ||
    TargetPlatform.macOS ||
    TargetPlatform.linux ||
    TargetPlatform.windows => 'localhost',
    TargetPlatform.fuchsia => 'localhost',
  };
}

void main() {
  runApp(
    ChangeNotifierProvider<AuthController>(
      create: (_) => AuthController(
        authService: AuthService(
          host: _apiHost.isEmpty ? _defaultApiHost : _apiHost,
          port: _apiPort,
          useTls: _apiUseTls,
          storage: SecureSessionStorage(),
        ),
      )..restore(),
      child: Builder(
        builder: (context) => ChangeNotifierProvider<SyncBloc>(
          create: (_) => SyncBloc(
            dao: CHPDao(DatabaseHelper.instance),
            syncService: SyncService(
              host: _apiHost.isEmpty ? _defaultApiHost : _apiHost,
              port: _apiPort,
              useTls: _apiUseTls,
              tokenProvider: () => context.read<AuthController>().token,
            ),
          ),
          child: const CHPApp(),
        ),
      ),
    ),
  );
}

class CHPApp extends StatelessWidget {
  const CHPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHP Records',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
