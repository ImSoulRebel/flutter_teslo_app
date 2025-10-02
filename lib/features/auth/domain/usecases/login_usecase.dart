import 'package:flutter/foundation.dart';
import 'package:teslo_shop/features/auth/infraestructure/errors/errors.dart';

import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para iniciar sesión
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Ejecuta el caso de uso de login
  ///
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  ///
  /// Returns [UserEntity] si el login es exitoso
  /// Throws [Exception] si hay algún error
  Future<UserEntity> execute(String email, String password) async {
    try {
      return await repository.login(email, password);
    } on WrongCredentials catch (e) {
      debugPrint(e.toString());
      // Si ya es una WrongCredentials, la re-lanzamos sin modificar
      rethrow;
    } on ConnectionTimeout catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      // Para otros errores, los envolvemos en WrongCredentials
      throw WrongCredentials(
          message: "Error de autenticación: ${e.toString()}");
    }
  }
}
