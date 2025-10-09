import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/features/auth/data/repositories/auth_repository.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      
      try {
        log('SplashScreen: Starting navigation logic');
        final authRepository = getIt<AuthRepository>();
        log('SplashScreen: AuthRepository retrieved successfully');
        
        final accessToken = await authRepository.getCurrentUserToken();
        log('SplashScreen: Access token check completed - token exists: ${accessToken != null && accessToken.isNotEmpty}');
        
        if (accessToken != null && accessToken.isNotEmpty) {
          log('SplashScreen: Navigating to home screen');
          context.go('/home');
        } else {
          log('SplashScreen: Navigating to login screen');
          context.go('/login');
        }
      } catch (e) {
        log('SplashScreen: Error during navigation: $e');
        // Fallback to login screen on error
        if (mounted) {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LightPurple,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.LightPurple, AppColors.Gray],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5.h),
              Shimmer.fromColors(
                baseColor: AppColors.White,
                highlightColor: AppColors.DarkCyanGray,
                period: const Duration(seconds: 3),
                child: Text('WEARVA', style: AppTextStyles.White40Regular)
                    .animate()
                    .fadeIn(duration: 1000.ms, delay: 500.ms)
                    .slideY(begin: 0.5),
              ),
              SizedBox(height: 5.h),
              Shimmer.fromColors(
                    baseColor: AppColors.White,
                    highlightColor: AppColors.DarkCyanGray,
                    period: const Duration(seconds: 3),
                    child: Text(
                      'Find Your Style',
                      style: AppTextStyles.White35Regular,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 1500.ms, delay: 1000.ms)
                  .slideY(begin: 0.6),
            ],
          ),
        ),
      ),
    );
  }
}
