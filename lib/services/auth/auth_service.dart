import 'package:firebase_auth/firebase_auth.dart' show User;
import 'firebase_auth_provider.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  }) =>
      provider.createUser(name: name, email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  User? get firebaseCurrentUser => provider.firebaseCurrentUser;

  @override
  Future<void> changePassword({required String password}) =>
      provider.changePassword(password: password);
}
