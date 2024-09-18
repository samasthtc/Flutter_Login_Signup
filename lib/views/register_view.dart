import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/widgets/custom_text_form_fields.dart';
import 'package:login/widgets/glass_card.dart';
import 'package:login/services/auth/auth_exceptions.dart';
import 'package:login/services/auth/bloc/auth_bloc.dart';
import 'package:login/services/auth/bloc/auth_event.dart';
import 'package:login/services/auth/bloc/auth_state.dart';
import 'dart:developer' as devtools;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _validateName(String name) {
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Name cannot be empty';
        _isNameValid = false;
      });
    } else {
      setState(() {
        _nameError = null;
        _isNameValid = true;
      });
    }
  }

  void _validateEmail(String email) {
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,7}$');
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email cannot be empty';
        _isEmailValid = false;
      });
    } else if (!emailPattern.hasMatch(email)) {
      setState(() {
        _emailError = 'Invalid email format';
        _isEmailValid = false;
      });
    } else {
      setState(() {
        _emailError = null;
        _isEmailValid = true;
      });
    }
  }

  void _validatePassword(String password) {
    final isLong = password.length >= 8;
    final hasChar = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasUpperChar = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSpecialCharacter =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password cannot be empty';
        _isPasswordValid = false;
      });
    } else if (!isLong ||
        !hasChar ||
        !hasUpperChar ||
        !hasNumber ||
        !hasSpecialCharacter) {
      setState(() {
        _passwordError =
            'Must be at least 8 characters long, with at least one letter, one number, one uppercase letter, and one special character';
        _isPasswordValid = false;
      });
    } else {
      setState(() {
        _passwordError = null;
        _isPasswordValid = true;
      });
    }
  }

  void _register() async {
    final name = _name.text;
    final email = _email.text;
    final password = _password.text;

    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
    });

    _validateName(name);
    _validateEmail(email);
    _validatePassword(password);

    context.read<AuthBloc>().add(
          AuthEventRegister(
            name: name,
            email: email,
            password: password,
          ),
        );

    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _isNameValid = false;
      _isEmailValid = false;
      _isPasswordValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            setState(() {
              _passwordError = "Provided password is too weak.";
              _isPasswordValid = false;
              _isNameValid = true;
              _isEmailValid = true;
            });
          } else if (state.exception is MissingPasswordAuthException) {
            setState(() {
              _passwordError = "Please enter a password.";
              _isPasswordValid = false;
              _isNameValid = true;
              _isEmailValid = true;
            });
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            setState(() {
              _emailError =
                  "Email is already in use. Please enter another email.";
              _isEmailValid = false;
              _isNameValid = true;
            });
          } else if (state.exception is InvalidEmailAuthException) {
            setState(() {
              _emailError = "Invalid email. Please enter a valid email.";
              _isEmailValid = false;
              _isNameValid = true;
            });
          } else if (state.exception is GenericAuthException) {
            devtools.log('Failed to Register. Please try again.');
            _isNameValid = false;
            _isEmailValid = false;
            _isPasswordValid = false;
          } else if (state.exception == null) {
            setState(() {
              _isNameValid = true;
              _isEmailValid = true;
              _isPasswordValid = true;
            });
          } else {
            devtools.log(state.exception.toString());
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
              height: 468.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C)),
                    ),
                    const SizedBox(height: 56),
                    CustomTextFormField(
                      controller: _name,
                      labelText: "Name",
                      hintText: "Enter your name",
                      errorText: _nameError,
                      isValid: _isNameValid,
                      keyboardType: TextInputType.text,
                      isName: true,
                      onSubmitted: (_) => _register(),
                      onChanged: _validateName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _email,
                      labelText: "Email",
                      hintText: "Enter your email",
                      errorText: _emailError,
                      isValid: _isEmailValid,
                      keyboardType: TextInputType.emailAddress,
                      isEmail: true,
                      onSubmitted: (_) => _register(),
                      onChanged: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _password,
                      labelText: "Password",
                      hintText: "Enter your password",
                      errorText: _passwordError,
                      isValid: _isPasswordValid,
                      isPassword: true,
                      onSubmitted: (_) => _register(),
                      onChanged: _validatePassword,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogout(),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: const Text(
                            "Go to Login",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4F4F4),
                          ),
                          child: Text(
                            "Sign Up",
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
              )),
        ),
      ),
    );
  }
}
