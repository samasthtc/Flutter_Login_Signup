import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String name;
  final String email;
  final String id;

  const AuthUser({
    required this.name,
    required this.id,
    required this.email,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        name: user.displayName ?? '',
        id: user.uid,
        email: user.email!,
      );
}
