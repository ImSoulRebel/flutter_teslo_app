import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';

import 'auth_usecases_provider.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final UserEntity? user;
  final String errorMessage;
  final AuthStatus status;

  AuthState({
    this.user,
    this.errorMessage = '',
    this.status = AuthStatus.checking,
  });

  AuthState copyWith({
    UserEntity? user,
    String? errorMessage,
    AuthStatus? status,
  }) =>
      AuthState(
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
      );
}

class AuthNotifier extends Notifier<AuthState> {
  late AuthUseCases authUseCases;

  @override
  AuthState build() {
    authUseCases = ref.read(authUseCasesProvider);
    return AuthState();
  }

  Future<void> login(String username, String password) async {
    final user = await authUseCases.login(username, password);
    state = state.copyWith(user: user, status: AuthStatus.authenticated);
  }

  Future<void> register(String username, String password, String email) async {
    final user = await authUseCases.register(username, password, email);
    state = state.copyWith(user: user, status: AuthStatus.authenticated);
  }

  Future<void> checkStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(status: AuthStatus.notAuthenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});



// class AuthNotifier extends Notifier<AuthState> {
//   late AuthUseCases authUseCases;

//   @override
//   AuthState build() {
//     authUseCases = ref.read(authUseCasesProvider);
//     return AuthState();
//   }

  /// Realiza el login del usuario
//   Future<void> login(String email, String password) async {
//     try {
//       state = state.copyWith(status: AuthStatus.checking, errorMessage: '');
      
//       final user = await authUseCases.login(email, password);
      
//       state = state.copyWith(
//         user: user,
//         status: AuthStatus.authenticated,
//         errorMessage: '',
//       );
//     } catch (e) {
//       state = state.copyWith(
//         status: AuthStatus.notAuthenticated,
//         errorMessage: e.toString().replaceAll('Exception: ', ''),
//         user: null,
//       );
//     }
//   }

//   /// Registra un nuevo usuario
//   Future<void> register(String fullName, String email, String password) async {
//     try {
//       state = state.copyWith(status: AuthStatus.checking, errorMessage: '');
      
//       final user = await authUseCases.register(fullName, email, password);
      
//       state = state.copyWith(
//         user: user,
//         status: AuthStatus.authenticated,
//         errorMessage: '',
//       );
//     } catch (e) {
//       state = state.copyWith(
//         status: AuthStatus.notAuthenticated,
//         errorMessage: e.toString().replaceAll('Exception: ', ''),
//         user: null,
//       );
//     }
//   }

//   /// Verifica el estado de autenticación actual
//   Future<void> checkAuthStatus(String token) async {
//     try {
//       state = state.copyWith(status: AuthStatus.checking, errorMessage: '');
      
//       final user = await authUseCases.checkAuthStatus(token);
      
//       state = state.copyWith(
//         user: user,
//         status: AuthStatus.authenticated,
//         errorMessage: '',
//       );
//     } catch (e) {
//       state = state.copyWith(
//         status: AuthStatus.notAuthenticated,
//         errorMessage: '',
//         user: null,
//       );
//     }
//   }

//   /// Cierra la sesión del usuario
//   Future<void> logout() async {
//     try {
//       await authUseCases.logout();
      
//       state = state.copyWith(
//         user: null,
//         status: AuthStatus.notAuthenticated,
//         errorMessage: '',
//       );
//     } catch (e) {
//       // En caso de error en logout, aún limpiamos el estado local
//       state = state.copyWith(
//         user: null,
//         status: AuthStatus.notAuthenticated,
//         errorMessage: 'Error durante el logout, pero sesión cerrada localmente',
//       );
//     }
//   }
// }

// final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
//   return AuthNotifier();
// });