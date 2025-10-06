import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/products.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    refreshListenable: ref.read(goRouterNotifierProvider),
    initialLocation: '/check-auth-status',
    routes: [
      ///* Auth Routes
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

      ///* Product Routes
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),

      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final productId = state.params['id'] ?? 'no-id';
          return ProductDetailScreen(productId: productId);
        },
      ),
    ],

    ///! TODO: Bloquear si no se está autenticado de alguna manera
    ///
    redirect: (_, state) {
      final currentStatus = ref.read(authProvider).status;

      final isLoggedIn = currentStatus == AuthStatus.authenticated;

      final loggingIn = state.subloc == '/login' || state.subloc == '/register';

      if (!isLoggedIn) return loggingIn ? null : '/login';

      if (loggingIn) return '/products';

      return null;
    },
  );
});
