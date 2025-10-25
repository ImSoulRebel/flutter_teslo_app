import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/products.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final AuthStatus status = ref.watch(authProvider).status;
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    refreshListenable: goRouterNotifier,
    initialLocation: '/check-auth-status',
    routes: [
      // Auth routes
      GoRoute(
        path: '/check-auth-status',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Product routes
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final String productId = state.params['id'] ?? 'no-id';
          return ProductDetailScreen(productId: productId);
        },
      ),
    ],
    // Redirección centralizada según estado de autenticación
    redirect: (_, state) {
      // Mientras se verifica el estado, mostrar pantalla de carga
      if (status == AuthStatus.checking) {
        return state.subloc == '/check-auth-status'
            ? null
            : '/check-auth-status';
      }

      // Si no está autenticado, redirigir a login (excepto si ya está en login o register)
      if (status == AuthStatus.notAuthenticated) {
        final isAuthRoute =
            state.subloc == '/login' || state.subloc == '/register';
        return isAuthRoute ? null : '/login';
      }

      // Si está autenticado y está en login/register, redirigir a productos
      if (status == AuthStatus.authenticated) {
        final isAuthRoute = state.subloc == '/login' ||
            state.subloc == '/register' ||
            state.subloc == '/check-auth-status';
        return isAuthRoute ? '/products' : null;
      }

      return null;
    },
  );
});
