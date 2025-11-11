import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/core/services/local_storage_service.dart';
import 'package:laza/features/auth/presentation/cubits/login_cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('LoginScreen build method called');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) {
          log('BlocProvider create method called for LoginCubit');
          return getIt<LoginCubit>();
        },
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            log('LoginCubit listener called with state: $state');
            if (state is LoginSuccess) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));

              // Check if gender is selected before navigating
              final localStorage = getIt<LocalStorageService>();
              final savedGender = localStorage.getGender();
              log('LoginScreen: Checking saved gender: $savedGender');

              if (!context.mounted) return;
              if (savedGender != null) {
                log('LoginScreen: Gender found, navigating to home');
                context.go('/home');
              } else {
                log(
                  'LoginScreen: No gender found, navigating to gender selection',
                );
                context.go('/gender-selection');
              }
            } else if (state is LoginFailure) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            log('LoginCubit builder called with state: $state');
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 90.h),

                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Welcome',
                                    style: AppTextStyles.AlmostBlack28Semibold,
                                  ),
                                  Text(
                                    'Please enter your data to continue',
                                    style: AppTextStyles.Grey15Regular,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 80.h),

                            // Email Field
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: AppTextStyles.Grey15Regular,
                                  ),
                                  SizedBox(height: 4.h),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      suffixIcon:
                                          _emailController.text.isNotEmpty &&
                                              RegExp(
                                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                              ).hasMatch(_emailController.text)
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h,
                                      ),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Password Field
                            Text(
                              'Password',
                              style: AppTextStyles.Grey15Regular,
                            ),
                            SizedBox(height: 4.h),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                suffixIcon: _passwordController.text.length >= 6
                                    ? Padding(
                                        padding: EdgeInsets.only(right: 12.w),
                                        child: Text(
                                          'Strong',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 8.h),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  context.push('/forgot-password');
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Remember Me Switch
                            Row(
                              children: [
                                Switch(
                                  value: _rememberMe,
                                  onChanged: (val) =>
                                      setState(() => _rememberMe = val),
                                  activeColor: Colors.green,
                                ),
                                Text(
                                  'Remember me',
                                  style: AppTextStyles.Grey15Regular,
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),

                            // Terms and Conditions
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        'By connecting your account confirm that you agree with our ',
                                    style: AppTextStyles.Grey15Regular,
                                    children: [
                                      TextSpan(
                                        text: 'Term and Condition',
                                        style:
                                            AppTextStyles.AlmostBlack15Medium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.LightPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                ),
                                onPressed: state is LoginLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<LoginCubit>().login(
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                        }
                                      },
                                child: state is LoginLoading
                                    ? const CircularProgressIndicator(
                                        color: AppColors.White,
                                      )
                                    : Text(
                                        'Login',
                                        style: AppTextStyles.White17Medium,
                                      ),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Sign Up Link
                            Center(
                              child: GestureDetector(
                                onTap: () => context.go('/signup'),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: AppTextStyles.Grey15Regular,
                                    children: [
                                      TextSpan(
                                        text: 'Sign up',
                                        style:
                                            AppTextStyles.LightPurple15Medium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
