import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SoftCloud,
      appBar: AppBar(
        backgroundColor: AppColors.SoftCloud,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: CircleAvatar(
            backgroundColor: AppColors.White,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.AlmostBlack,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        'Forgot Password',
                        style: AppTextStyles.AlmostBlack22Semibold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Center(child: Icon(Icons.lock, size: 100)),
                    SizedBox(height: 40.h),
                    Text(
                      'Email Address',
                      style: AppTextStyles.AlmostBlack15Medium,
                    ),
                    SizedBox(height: 4.h),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'bill.sanders@example.com',
                        border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.Gray,
                            width: 1,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.LightPurple,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 150.h),
                    Center(
                      child: Text(
                        'Please write your email to receive a confirmation code to set a new password.',
                        style: AppTextStyles.Gray13Regular,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.LightPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) {
                      context.push(
                        '/confirm-code',
                        extra: _emailController.text,
                      );
                    }
                  },
                  child: Text(
                    'Send Reset Email',
                    style: AppTextStyles.White17Medium,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
