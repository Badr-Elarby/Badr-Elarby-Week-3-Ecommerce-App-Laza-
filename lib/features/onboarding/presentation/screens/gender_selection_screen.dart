import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:laza/features/onboarding/presentation/cubits/gender_cubit/gender_cubit.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _checkExistingGender();
  }

  Future<void> _checkExistingGender() async {
    final savedGender = context.read<GenderCubit>().getGender();
    if (savedGender != null) {
      // Small delay to ensure proper navigation
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        context.go('/home');
      }
    }
  }

  void _handleGenderSelection(String gender) {
    setState(() => selectedGender = gender);
    context.read<GenderCubit>().saveGender(gender);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenderCubit, GenderState>(
      listener: (context, state) {
        if (state is GenderSuccess) {
          context.go('/Home');
        } else if (state is GenderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<GenderCubit, GenderState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                // Gradient Background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.LightPurple, AppColors.Gray],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Full-screen background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/smiling-pretty-girl-with-wavy-hairstyle-standing-one-leg-purple-wall-cheerful-brunette-female-model-dancing-white-sneakers-removebg 1.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Content overlay
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 60.h),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 15.h,
                          ),
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: AppColors.White,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.SteelNight,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Look Good, Feel Good',
                                style: AppTextStyles.AlmostBlack22Semibold,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Create your individual & unique style and look amazing everyday.',
                                style: AppTextStyles.Gray13Regular,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            selectedGender == 'Women'
                                            ? AppColors.LightPurple
                                            : AppColors.SoftCloud,
                                        foregroundColor:
                                            selectedGender == 'Women'
                                            ? AppColors.White
                                            : AppColors.AlmostBlack,
                                        elevation: 4,
                                        minimumSize: Size(
                                          double.infinity,
                                          60.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                      onPressed: state is GenderLoading
                                          ? null
                                          : () =>
                                                _handleGenderSelection('Women'),
                                      child: const Text('Women'),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedGender == 'Men'
                                            ? AppColors.LightPurple
                                            : AppColors.SoftCloud,
                                        foregroundColor: selectedGender == 'Men'
                                            ? AppColors.White
                                            : AppColors.AlmostBlack,
                                        elevation: 4,
                                        minimumSize: Size(
                                          double.infinity,
                                          60.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                      onPressed: state is GenderLoading
                                          ? null
                                          : () => _handleGenderSelection('Men'),
                                      child: const Text('Men'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              TextButton(
                                onPressed: state is GenderLoading
                                    ? null
                                    : () => context.go('/Home'),
                                child: Text(
                                  'Skip',
                                  style: AppTextStyles.Grey17Medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Loading overlay
                if (state is GenderLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
