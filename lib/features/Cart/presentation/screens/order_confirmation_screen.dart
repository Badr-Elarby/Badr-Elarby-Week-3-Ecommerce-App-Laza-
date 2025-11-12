import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/features/Orders/data/models/order_model.dart';
import 'package:laza/features/Orders/presentation/cubits/orders_cubit/orders_cubit.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final OrderModel? order;

  const OrderConfirmationScreen({Key? key, this.order}) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  bool _orderSaved = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: BlocListener<OrdersCubit, OrdersState>(
        listener: (context, state) {
          // Handle any errors during order saving
          if (state is OrdersError) {
            debugPrint('Error saving order: ${state.message}');
          }
        },
        child: Builder(
          builder: (context) {
            // Save order once when widget is built and order is provided
            if (widget.order != null && !_orderSaved) {
              _orderSaved = true;
              // OPTIMIZATION: Removed print() statements for better performance
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.read<OrdersCubit>().saveOrder(widget.order!);
                }
              });
            }
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
                  onPressed: () {
                    // Pop back using GoRouter to maintain proper nav stack
                    context.pop();
                  },
                ),
              ),
              body: SafeArea(
                child: Padding(
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
                            // Navigate to Orders screen
                            context.go('/orders');
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
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pop back to cart/home (OrderConfirmation was pushed via GoRouter)
                      context.pop();
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
          },
        ),
      ),
    );
  }
}
