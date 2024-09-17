import 'package:firebase_auth/firebase_auth.dart';
import 'auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  User? get firebaseCurrentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  });
  Future<void> changePassword({
    required String password,
  });
  Future<void> logout();
}
