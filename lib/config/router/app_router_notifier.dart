import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/providers.dart';

final goRouterNotifierProvider = Provider((Ref ref) => AppRouterNotifier(ref));

class AppRouterNotifier extends ChangeNotifier {
  final Ref _ref;
  AuthStatus _authStatus = AuthStatus.checking;

  AppRouterNotifier(this._ref) {
    // Escuchar cambios en el authProvider usando Riverpod
    _ref.listen<AuthState>(authProvider, (previous, next) {
      authStatus = next.status;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus status) {
    if (status == _authStatus) return;
    _authStatus = status;
    notifyListeners();
  }
}
