import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

final authServiceProvider = Provider<BaseAuthService>((ref) {
  return FirebaseOrLocalAuthService();
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authService) : super(const AuthState(user: null, isLoading: true)) {
    _subscription = _authService.authStateChanges().listen((user) {
      state = state.copyWith(user: user, isLoading: false);
      _controller.add(user);
    });
  }

  final BaseAuthService _authService;
  late final StreamSubscription _subscription;
  final StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get authStateStream => _controller.stream;

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);
    await _authService.signIn(email, password);
    state = state.copyWith(isLoading: false);
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true);
    await _authService.signUp(email, password);
    state = state.copyWith(isLoading: false);
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _authService.signOut();
    state = state.copyWith(isLoading: false);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.close();
    super.dispose();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthController(service);
});
