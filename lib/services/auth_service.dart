import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';

class AuthUser {
  final String uid;
  final String? email;
  const AuthUser({required this.uid, this.email});
}

class AuthState {
  final AuthUser? user;
  final bool isLoading;
  const AuthState({required this.user, required this.isLoading});

  AuthState copyWith({AuthUser? user, bool? isLoading}) {
    return AuthState(user: user ?? this.user, isLoading: isLoading ?? this.isLoading);
  }
}

abstract class BaseAuthService {
  Stream<AuthUser?> authStateChanges();
  Future<AuthUser?> signIn(String email, String password);
  Future<AuthUser?> signUp(String email, String password);
  Future<void> signOut();
}

class FirebaseOrLocalAuthService implements BaseAuthService {
  FirebaseOrLocalAuthService() {
    _init();
  }

  final StreamController<AuthUser?> _controller = StreamController<AuthUser?>.broadcast();
  bool _firebaseReady = false;
  AuthUser? _currentUser;

  Future<void> _init() async {
    try {
      await Firebase.initializeApp();
      _firebaseReady = true;
      fb.FirebaseAuth.instance.authStateChanges().listen((fb.User? user) {
        final mapped = user == null ? null : AuthUser(uid: user.uid, email: user.email);
        _currentUser = mapped;
        _controller.add(mapped);
      });
    } catch (_) {
      _firebaseReady = false;
      _controller.add(null);
    }
  }

  @override
  Stream<AuthUser?> authStateChanges() => _controller.stream;

  @override
  Future<AuthUser?> signIn(String email, String password) async {
    if (_firebaseReady) {
      final cred = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = AuthUser(uid: cred.user!.uid, email: cred.user!.email);
      _currentUser = user;
      _controller.add(user);
      return user;
    }
    final user = AuthUser(uid: 'local-${email.hashCode}', email: email);
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AuthUser?> signUp(String email, String password) async {
    if (_firebaseReady) {
      final cred = await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = AuthUser(uid: cred.user!.uid, email: cred.user!.email);
      _currentUser = user;
      _controller.add(user);
      return user;
    }
    final user = AuthUser(uid: 'local-${email.hashCode}', email: email);
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    if (_firebaseReady) {
      await fb.FirebaseAuth.instance.signOut();
    }
    _currentUser = null;
    _controller.add(null);
  }
}
