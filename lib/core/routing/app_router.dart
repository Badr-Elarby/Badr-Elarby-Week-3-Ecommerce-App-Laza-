import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/routing/app_shell.dart';
import 'package:laza/features/auth/presentation/screens/confirm_code.dart';
import 'package:laza/features/auth/presentation/screens/forget_password.dart';
import 'package:laza/features/auth/presentation/screens/login_screen.dart';
import 'package:laza/features/auth/presentation/screens/new_password.dart';
import 'package:laza/features/auth/presentation/screens/signup_screen.dart';
import 'package:laza/features/cart/presentation/screens/cart_screen.dart';
import 'package:laza/features/favorites/presentation/screens/favourite_screen.dart';
import 'package:laza/features/onboarding/presentation/cubits/gender_cubit/gender_cubit.dart';
import 'package:laza/features/onboarding/presentation/screens/gender_selection_screen.dart';
import 'package:laza/features/spalsh/presentation/screens/splash_screen.dart';

// ✅ Import your shell (navigation bar) widget
import 'package:laza/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  late GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        // ---------------- AUTH & ONBOARDING ----------------
        GoRoute(
          path: '/',
          name: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: AppRoutes.signup,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/confirm-code',
          name: AppRoutes.confirmCode,
          builder: (context, state) {
            final email = state.extra as String?;
            if (email == null) {
              return const LoginScreen();
            }
            return ConfirmCode(email: email);
          },
        ),
        GoRoute(
          path: '/new-password',
          name: AppRoutes.newPassword,
          builder: (context, state) => const NewPassword(),
        ),
        GoRoute(
          path: '/gender-selection',
          name: AppRoutes.genderSelection,
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<GenderCubit>(),
            child: const GenderSelectionScreen(),
          ),
        ),

        // ---------------- SHELL ROUTE (for main app navigation) ----------------
        ShellRoute(
          builder: (context, state, child) {
            return AppShell(child: child); // The bottom nav shell
          },
          routes: [
            GoRoute(
              path: '/home',
              name: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/favorites',
              name: AppRoutes.favorites,
              builder: (context, state) => const FavouriteScreen(),
            ),
            GoRoute(
              path: '/cart',
              name: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------- ROUTE NAMES ----------------
class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgotPassword';
  static const String confirmCode = 'confirmCode';
  static const String newPassword = 'newPassword';
  static const String genderSelection = 'genderSelection';

  static const String home = 'home';
  static const String favorites = 'favorites';
  static const String cart = 'cart';
  static const String profile = 'profile';
}
