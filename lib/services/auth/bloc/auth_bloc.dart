import 'package:bloc/bloc.dart';
import 'package:login/services/auth/auth_provider.dart';
import 'package:login/services/auth/bloc/auth_event.dart';
import 'package:login/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });
    // register
    on<AuthEventRegister>((event, emit) async {
      final name = event.name;
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          name: name,
          email: email,
          password: password,
        );
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateRegistering(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    // change password
    on<AuthEventChangePassword>((event, emit) async {
      final password = event.password;
      try {
        // final user = provider.currentUser!;
        emit(
          const AuthStateChangePassword(
            exception: null,
            isLoading: false,
          ),
        );
        await provider.changePassword(password: password);
      } on Exception catch (e) {
        emit(
          AuthStateChangePassword(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    // should register
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    // login
    on<AuthEventLogin>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(
          email: email,
          password: password,
        );

        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
        emit(
          AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    // logout
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logout();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
