import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/routing/app_router.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SoftCloud,
      appBar: AppBar(
        backgroundColor: AppColors.SoftCloud,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.AlmostBlack,
          ),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            // صورة أو SVG
            Container(
              height: 250.h,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/undraw_order_confirmed_aaw7 1.png', // ضع الصورة المناسبة هنا
                height: 160.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Order Confirmed!',
              style: AppTextStyles.AlmostBlack22Semibold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Your order has been confirmed, we will send you confirmation email shortly.',
              style: AppTextStyles.Grey15Regular,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // ممكن تظبطها بعدين
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.SoftCloud,
                  foregroundColor: AppColors.Gray,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  side: BorderSide.none,
                ),
                child: Text(
                  'Go to Orders',
                  style: AppTextStyles.LightPurple15Medium,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
        child: SizedBox(
          width: double.infinity,
          height: 60.h,
          child: ElevatedButton(
            onPressed: () {
              context.go(AppRoutes.home);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.LightPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'Continue Shopping',
              style: AppTextStyles.White17Medium,
            ),
          ),
        ),
      ),
    );
  }
}
