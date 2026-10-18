import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({required this.authService});

  final AuthService authService;
  AuthSession? _session;
  bool _isRestoring = true;
  bool _isBusy = false;
  String? _error;

  String? get token => _session?.token;
  String? get employerId => _session?.employerId;
  bool get isSignedIn => _session != null;
  bool get isRestoring => _isRestoring;
  bool get isBusy => _isBusy;
  String? get error => _error;

  Future<void> restore() async {
    try {
      _session = await authService.restoreSession();
    } catch (error) {
      _error = error.toString();
    } finally {
      _isRestoring = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String employerId,
    required String password,
  }) => _run(() => authService.register(
    employerId: employerId,
    password: password,
  ));

  Future<void> signIn({
    required String employerId,
    required String password,
  }) => _run(() => authService.signIn(
    employerId: employerId,
    password: password,
  ));

  Future<void> _run(Future<AuthSession> Function() authenticate) async {
    _isBusy = true;
    _error = null;
    notifyListeners();
    try {
      _session = await authenticate();
    } catch (error) {
      _error = error.toString();
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    final token = _session?.token;
    try {
      await authService.signOut(token: token);
    } finally {
      _session = null;
      _error = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    authService.dispose();
    super.dispose();
  }
}
