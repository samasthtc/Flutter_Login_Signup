import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin({
    required this.email,
    required this.password,
  });
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventRegister extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const AuthEventRegister({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthEventChangePassword extends AuthEvent {
  final String password;
  const AuthEventChangePassword({
    required this.password,
  });
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}
