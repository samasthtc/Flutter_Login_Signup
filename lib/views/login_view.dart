import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/widgets/custom_text_form_fields.dart';
import 'package:login/widgets/glass_card.dart';
import 'package:login/services/auth/auth_exceptions.dart';
import 'package:login/services/auth/bloc/auth_bloc.dart';
import 'package:login/services/auth/bloc/auth_event.dart';
import 'package:login/services/auth/bloc/auth_state.dart';
import 'dart:developer' as devtools;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _email.text;
    final password = _password.text;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    context.read<AuthBloc>().add(
          AuthEventLogin(
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException ||
              state.exception is WrongPasswordAuthException) {
            setState(() {
              _emailError = "Wrong credentials. Please try again.";
              _passwordError = "Wrong credentials. Please try again.";
            });
          } else if (state.exception is InvalidEmailAuthException) {
            setState(() {
              _emailError = "Invalid email. Please enter a valid email.";
            });
          } else if (state.exception is InvalidCredentialsAuthException) {
            setState(() {
              _emailError = "Wrong credentials. Please try again.";
              _passwordError = "Wrong credentials. Please try again.";
            });
          } else if (state.exception is MissingPasswordAuthException) {
            setState(() {
              _passwordError = "Please enter a valid password.";
            });
          } else if (state.exception is GenericAuthException) {
            devtools.log(
                'Authentication failed. Please try again. ${state.exception}');
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF79AA),
                  Color(0xFFAAFFFF),
                ]),
            image: DecorationImage(
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
          alignment: const Alignment(0, 0),
          child: GlassCard(
            width: 350.0,
            height: 400.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 56),
                  CustomTextFormField(
                    controller: _email,
                    labelText: "Email",
                    hintText: "Enter your email",
                    errorText: _emailError,
                    keyboardType: TextInputType.emailAddress,
                    isEmail: true,
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _password,
                    labelText: "Password",
                    hintText: "Enter your password",
                    errorText: _passwordError,
                    isPassword: true,
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventShouldRegister(),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          "Go to Sign Up",
                          style: TextStyle(
                            color: Color(0xFFF4F4F4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4F4F4),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
