import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/routing/app_router.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/features/Cart/presentation/cubits/cart_cubit.dart';
import 'package:laza/features/Cart/presentation/cubits/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartCubit _cartCubit;

  @override
  void initState() {
    super.initState();
    _cartCubit = getIt<CartCubit>();
    // Load cart items when screen initializes
    _cartCubit.loadCartItems();
  }

  @override
  void dispose() {
    _cartCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cartCubit,
      child: Scaffold(
        backgroundColor: AppColors.SoftCloud,
        appBar: AppBar(
          backgroundColor: AppColors.White,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.AlmostBlack,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          title: Text('Cart', style: AppTextStyles.AlmostBlack22Semibold),
          centerTitle: true,
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.Gray,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: AppTextStyles.Grey15Regular,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => _cartCubit.loadCartItems(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CartEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64.sp,
                      color: AppColors.Gray,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Your cart is empty',
                      style: AppTextStyles.AlmostBlack17Semibold,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add some products to get started',
                      style: AppTextStyles.Grey15Regular,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.home),
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
                  ],
                ),
              );
            }

            if (state is CartLoaded) {
              return _buildCartContent(context, state);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Items
          Expanded(
            child: ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                final item = state.cartItems[index];
                return Container(
                  margin: EdgeInsets.only(top: 16.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.White,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: item.imageUrl.isNotEmpty
                            ? Image.network(
                                item.imageUrl,
                                width: 64.w,
                                height: 64.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/image.png',
                                    width: 64.w,
                                    height: 64.w,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/image.png',
                                width: 64.w,
                                height: 64.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyles.AlmostBlack15Semibold,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: AppTextStyles.Grey15Regular,
                            ),
                            if (item.color != null || item.size != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                '${item.color ?? ''} ${item.size ?? ''}'.trim(),
                                style: AppTextStyles.Gray13Regular,
                              ),
                            ],
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (item.quantity > 1) {
                                      _cartCubit.updateQuantity(
                                        item.productId,
                                        item.quantity - 1,
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove_circle_outline,
                                    size: 22,
                                    color: item.quantity > 1
                                        ? AppColors.Gray
                                        : AppColors.Gray.withOpacity(0.5),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '${item.quantity}',
                                  style: AppTextStyles.AlmostBlack15Semibold,
                                ),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () {
                                    _cartCubit.updateQuantity(
                                      item.productId,
                                      item.quantity + 1,
                                    );
                                  },
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    size: 22,
                                    color: AppColors.Gray,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    _cartCubit.removeProduct(item.productId);
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: AppColors.Gray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24.h),

          // Order Summary
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: AppTextStyles.Grey15Regular),
                    Text(
                      '\$${state.totalAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.AlmostBlack15Semibold,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping', style: AppTextStyles.Grey15Regular),
                    Text('\$10.00', style: AppTextStyles.AlmostBlack15Semibold),
                  ],
                ),
                SizedBox(height: 8.h),
                Divider(color: AppColors.Gray.withOpacity(0.3)),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTextStyles.AlmostBlack17Semibold),
                    Text(
                      '\$${(state.totalAmount + 10.0).toStringAsFixed(2)}',
                      style: AppTextStyles.AlmostBlack17Semibold,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 60.h,
            child: ElevatedButton(
              onPressed: () {
                context.pushNamed('OrderConfirmationScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.LightPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text('Checkout', style: AppTextStyles.White17Medium),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
