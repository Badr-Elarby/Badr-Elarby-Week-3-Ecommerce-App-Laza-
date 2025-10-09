import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/features/auth/presentation/screens/confirm_code.dart';
import 'package:laza/features/auth/presentation/screens/forget_password.dart';
import 'package:laza/features/auth/presentation/screens/login_screen.dart';
import 'package:laza/features/auth/presentation/screens/new_password.dart';
import 'package:laza/features/auth/presentation/screens/signup_screen.dart';
import 'package:laza/features/spalsh/presentation/screens/splash_screen.dart';

class AppRouter {
  late GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        // Authentication and onboarding screens (no shell)
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
              return const LoginScreen(); // Or an error screen
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
          path: '/home',
          name: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}

class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgotPassword';
  static const String confirmCode = 'confirmCode';
  static const String newPassword = 'newPassword';
  static const String home = 'home';
}

// Placeholder for Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to the Home Screen!')),
    );
  }
}
