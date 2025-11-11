import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/features/ProductDetails/presentation/cubit/product_details_cubit.dart';
import 'package:laza/features/ProductDetails/presentation/cubit/product_details_state.dart';
import 'package:laza/features/Cart/data/services/cart_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.AlmostBlack),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.Gray13Regular.copyWith(fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedSize = 2;
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL'];
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    log(
      '🛍️ [ProductDetailsScreen] Initializing with product ID: ${widget.productId}',
    );
    getIt<ProductDetailsCubit>().fetchProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductDetailsCubit>()..fetchProductDetails(widget.productId),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading ||
              state is ProductDetailsInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProductDetailsError) {
            return Scaffold(
              body: Center(
                child: Text(state.message, style: TextStyle(fontSize: 16.sp)),
              ),
            );
          }

          if (state is ProductDetailsLoaded) {
            final product = state.product;
            log(
              '🛍️ [ProductDetailsScreen] Building UI for product: ${product.id}',
            );
            return Scaffold(
              backgroundColor: AppColors.SoftCloud,
              appBar: AppBar(
                backgroundColor: AppColors.White,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.AlmostBlack,
                    size: 20.sp,
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.AlmostBlack,
                      size: 22.sp,
                    ),
                    onPressed: () => context.pushNamed('cart'),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 80.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Product Image
                        Center(
                          child: product.coverPictureUrl.isNotEmpty
                              ? Image.network(
                                  product.coverPictureUrl,
                                  width: 1.sw,
                                  height: 260.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    log(
                                      '🛍️ [ProductDetailsScreen] Failed to load main image: $error',
                                    );
                                    return Image.asset(
                                      'assets/images/image.png',
                                      width: 1.sw,
                                      height: 260.h,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/image.png',
                                  width: 1.sw,
                                  height: 260.h,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(height: 16.h),
                        // Product Details Header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    product.productCode,
                                    style: AppTextStyles.Grey15Regular.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  if (product.discountPercentage > 0) ...[
                                    const Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .LightPurple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                        style:
                                            AppTextStyles
                                                .Grey15Regular.copyWith(
                                              fontSize: 13.sp,
                                              color: AppColors.LightPurple,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style:
                                          AppTextStyles
                                              .AlmostBlack22Semibold.copyWith(
                                            fontSize: 22.sp,
                                          ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (product.discountPercentage > 0)
                                        Text(
                                          '\$${((product.price * (100 + product.discountPercentage)) / 100).toStringAsFixed(2)}',
                                          style:
                                              AppTextStyles
                                                  .Grey15Regular.copyWith(
                                                fontSize: 15.sp,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                        ),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style:
                                            AppTextStyles
                                                .AlmostBlack22Semibold.copyWith(
                                              fontSize: 22.sp,
                                              color: AppColors.LightPurple,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Rating and Info Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${product.rating.toStringAsFixed(1)}',
                                    style:
                                        AppTextStyles
                                            .AlmostBlack15Semibold.copyWith(
                                          fontSize: 15.sp,
                                        ),
                                  ),
                                  Text(
                                    ' (${product.reviewsCount} reviews)',
                                    style: AppTextStyles.Grey15Regular.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              _InfoChip(
                                icon: Icons.inventory_2_outlined,
                                label: product.inStock
                                    ? 'In Stock'
                                    : 'Out of Stock',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Size',
                            style: AppTextStyles.AlmostBlack15Semibold.copyWith(
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(
                              sizes.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: ChoiceChip(
                                  label: Text(
                                    sizes[index],
                                    style:
                                        AppTextStyles
                                            .AlmostBlack15Semibold.copyWith(
                                          fontSize: 15.sp,
                                        ),
                                  ),
                                  selected: selectedSize == index,
                                  selectedColor: AppColors.LightPurple,
                                  backgroundColor: AppColors.White,
                                  labelStyle: TextStyle(
                                    color: selectedSize == index
                                        ? AppColors.White
                                        : AppColors.AlmostBlack,
                                    fontSize: 15.sp,
                                  ),
                                  onSelected: (_) =>
                                      setState(() => selectedSize = index),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Description',
                            style: AppTextStyles.AlmostBlack17Semibold.copyWith(
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.description,
                                style: AppTextStyles.Grey15Regular.copyWith(
                                  fontSize: 15.sp,
                                ),
                                maxLines: _isExpanded ? null : 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _isExpanded = !_isExpanded),
                                child: Text(
                                  _isExpanded ? 'Read more..' : 'Read less',
                                  style:
                                      AppTextStyles
                                          .LightPurple15Medium.copyWith(
                                        fontSize: 15.sp,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reviews',
                                style: AppTextStyles.AlmostBlack17Semibold,
                              ),
                              Text(
                                'View All',
                                style: AppTextStyles.Gray13Regular,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: AppColors.White,
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.LightPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              // Add product to cart
                              await CartService().addProduct(
                                product,
                                color: product.color.isNotEmpty
                                    ? product.color
                                    : null,
                                size: sizes[selectedSize],
                              );

                              // Show success message
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.name} added to cart!',
                                    ),
                                    backgroundColor: AppColors.LightPurple,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Show error message
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to add product to cart: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Add to Cart',
                            style: AppTextStyles.White17Medium.copyWith(
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
