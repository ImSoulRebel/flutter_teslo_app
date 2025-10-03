import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/errors/errors.dart';
import 'package:teslo_shop/shared/infrastructure/simple_adapters.dart';

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
  final StorageAdapter storageAdapter = SharedPreferencesStorageAdapter();

  @override
  AuthState build() {
    authUseCases = ref.read(authUseCasesProvider);
    checkStatus();
    return AuthState();
  }

  Future<void> login(String username, String password) async {
    await _tic();

    try {
      final user = await authUseCases.login(username, password);
      _setLoggedUser(user);
    } on WrongCredentials catch (e) {
      logout(e.message);
    } on ConnectionTimeout catch (e) {
      logout(e.message);
    } catch (e) {
      debugPrint("Login: ${e.toString()}");
      logout("Error inesperado durante el login");
    }
  }

  Future<void> register(String username, String password, String email) async {
    final user = await authUseCases.register(
      username,
      password,
      email,
    );
    _setLoggedUser(user);
  }

  Future<void> checkStatus() async {
    await _tic();
    final token = await storageAdapter.getToken();
    if (token == null) return logout();
    try {
      final user = await authUseCases.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      debugPrint("Token: ${e.toString()}");
      logout();
    }
  }

  Future<void> logout([String? errorMessage]) async {
    await _tic();
    await storageAdapter.removeToken();
    await authUseCases.logout();
    state = state.copyWith(
      status: AuthStatus.notAuthenticated,
      errorMessage: errorMessage,
      user: null,
    );
  }

  Future<void> _setLoggedUser(UserEntity user) async {
    await storageAdapter.saveToken(user.token);

    state = state.copyWith(
      user: user,
      status: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> _tic() => Future.delayed(const Duration(milliseconds: 500));
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