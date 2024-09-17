import 'package:firebase_core/firebase_core.dart';
import 'package:login/firebase_options.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User;
import 'dart:developer' as devtools;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = firebaseCurrentUser;
      await firebaseUser?.updateDisplayName(name);

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on MissingPasswordAuthException {
      throw MissingPasswordAuthException();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'missing-password':
          throw MissingPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      devtools.log('Generic Exception: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<void> changePassword({required String password}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw UserNotLoggedInAuthException();
      }

      await user.updatePassword(password);
      devtools.log('Password updated successfully');
    } on MissingPasswordAuthException {
      throw MissingPasswordAuthException();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();
        default:
          devtools.log('Password update failed: ${e.message}');
          throw GenericAuthException();
      }
    } catch (e) {
      devtools.log('Password update failed: $e');
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  User? get firebaseCurrentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundAuthException();
        case 'wrong-password':
          throw WrongPasswordAuthException();
        case 'invalid-credential':
          throw InvalidCredentialsAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'missing-password':
          throw MissingPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
