import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Center(
                      child: Text(
                        'New Password',
                        style: AppTextStyles.AlmostBlack22Semibold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 150.h),
                    Text('Password', style: AppTextStyles.AlmostBlack15Medium),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
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
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Confirm Password',
                      style: AppTextStyles.AlmostBlack15Medium,
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Re-enter new password',
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
                    ),
                    SizedBox(height: 40.h),
                    Center(
                      child: Text(
                        'Please write your new password.',
                        style: AppTextStyles.Gray13Regular,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
                    if (_passwordController.text ==
                            _confirmPasswordController.text &&
                        _passwordController.text.isNotEmpty) {
                      context.go('/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Passwords do not match or are empty'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Reset Password',
                    style: AppTextStyles.White17Medium,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
