import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hideTexts = false;
  bool _hideLogo = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 40), () {
        if (mounted) {
          setState(() {
            _hideTexts = true;
            _hideLogo = true;
          });
          Future.delayed(const Duration(milliseconds: 700), () {
            if (mounted) {
              context.go('/login');
            }
          });
        }
      });
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

              AnimatedSlide(
                offset: _hideTexts ? const Offset(0, 2) : Offset.zero,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeIn,
                child: AnimatedOpacity(
                  opacity: _hideTexts ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Shimmer.fromColors(
                    baseColor: AppColors.White,
                    highlightColor: AppColors.DarkCyanGray,
                    period: const Duration(seconds: 3),
                    child: Text('WEARVA', style: AppTextStyles.White40Regular)
                        .animate()
                        .fadeIn(duration: 1000.ms, delay: 500.ms)
                        .slideY(begin: 0.5),
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              AnimatedSlide(
                offset: _hideTexts ? const Offset(0, 2) : Offset.zero,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeIn,
                child: AnimatedOpacity(
                  opacity: _hideTexts ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child:
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
