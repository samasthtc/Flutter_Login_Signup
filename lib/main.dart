import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/constants/routes.dart';
import 'package:login/services/auth/bloc/auth_bloc.dart';
import 'package:login/services/auth/bloc/auth_event.dart';
import 'package:login/services/auth/bloc/auth_state.dart';
import 'package:login/services/auth/firebase_auth_provider.dart';
import 'package:login/views/login_view.dart';
import 'package:login/views/profile_view.dart';
import 'dart:developer' as devtools;

import 'package:login/views/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        profileRoute: (context) => const ProfileView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          devtools.log('loading...');
        }
      },
      builder: (context, state) {
        if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateLoggedIn) {
          return const ProfileView();
        } else if (state is AuthStateChangePassword) {
          return const ProfileView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
