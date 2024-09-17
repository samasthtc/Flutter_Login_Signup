import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:login/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;

  const AuthState({
    required this.isLoading,
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required super.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required super.isLoading,
  });
}

class AuthStateChangePassword extends AuthState {
  final Exception? exception;
  const AuthStateChangePassword({
    required this.exception,
    required super.isLoading,
  });
}
