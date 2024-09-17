import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/custom_text_form_fields.dart';
import 'package:login/glass_card.dart';
import 'package:login/services/auth/auth_exceptions.dart';
import 'package:login/services/auth/auth_service.dart';
import 'package:login/services/auth/bloc/auth_bloc.dart';
import 'package:login/services/auth/bloc/auth_event.dart';
import 'package:login/services/auth/bloc/auth_state.dart';
import 'dart:developer' as devtools;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // String get userName => AuthService.firebase().currentUser!.name;
  // String get userEmail => AuthService.firebase().currentUser!.email;
  late final String userName;

  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isPasswordValid = false;
  String? _passwordError;

  @override
  void initState() {
    userName = AuthService.firebase().currentUser!.name;
    _email = TextEditingController();
    _email.text = AuthService.firebase().currentUser!.email;
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
        _passwordError = '';
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

  void _changePassword() async {
    final password = _password.text;

    _validatePassword(password);

    context.read<AuthBloc>().add(
          AuthEventChangePassword(password: password),
        );

    setState(() {
      _password.clear();
      _isPasswordValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateChangePassword) {
          if (state.exception is WeakPasswordAuthException) {
            setState(() {
              _passwordError = "Provided password is too weak.";
              _isPasswordValid = false;
            });
          } else if (state.exception is MissingPasswordAuthException) {
            setState(() {
              _passwordError = "";
              _isPasswordValid = false;
            });
          } else if (state.exception is GenericAuthException) {
            devtools.log('Failed to Register. Please try again.');
          } else if (state.exception == null) {
            setState(() {
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
          child: Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.center,
            children: [
              GlassCard(
                width: 350.0,
                height: 400.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text.rich(
                            TextSpan(
                              text: 'Welcome,\n',
                              style: const TextStyle(
                                color: Color(0xFF2C2C2C),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 0.9,
                              ),
                              children: [
                                TextSpan(
                                  text: userName.isNotEmpty
                                      ? "${userName[0].toUpperCase()}${userName.substring(1)}"
                                      : 'Stranger',
                                  style: TextStyle(
                                    fontSize: userName.isNotEmpty ? 64 : 24,
                                    color: userName.isNotEmpty
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.red,
                                    fontFamily: 'Noto Color Emoji',
                                  ),
                                ),
                                TextSpan(
                                  text: '👋',
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: userName.isNotEmpty
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.red,
                                    fontFamily: 'Noto Color Emoji',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        controller: _email,
                        labelText: "Email",
                        isEmail: true,
                        isDisabled: true,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _password,
                        labelText: "New Password",
                        hintText: 'Enter your new password',
                        errorText: _passwordError,
                        isValid: _isPasswordValid,
                        isPassword: true,
                        onSubmitted: (_) => _changePassword(),
                        onChanged: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthEventLogout());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4F4F4),
                            ),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: const Text(
                              "Change Password",
                              style: TextStyle(
                                color: Color(0xFFF4F4F4),
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
              Positioned(
                top: -40,
                child: GlassCard(
                  width: 80,
                  height: 80,
                  shape: BoxShape.circle,
                  child: Icon(
                    Icons.account_circle,
                    size: 80.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
