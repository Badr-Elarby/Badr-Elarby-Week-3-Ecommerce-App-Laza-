import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/features/home/presentation/cubits/home_cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..getProducts(),
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: AppBar(
          backgroundColor: AppColors.White,
          elevation: 0,
          title: Text('Wearva', style: AppTextStyles.AlmostBlack22Semibold),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: AppColors.AlmostBlack,
              ),
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/demo.png'),
                radius: 18.r,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: AppColors.Gray),
                  filled: true,
                  fillColor: AppColors.SoftCloud,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16.w,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose Brand',
                    style: AppTextStyles.AlmostBlack17Medium,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('View All', style: AppTextStyles.Gray13Regular),
                  ),
                ],
              ),

              SizedBox(height: 10.h),
              SizedBox(
                height: 60.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    BrandCard(
                      image: 'assets/images/adidas.png',
                      name: 'Adidas',
                    ),
                    BrandCard(image: 'assets/images/adidas.png', name: 'Nike'),
                    BrandCard(image: 'assets/images/adidas.png', name: 'Fila'),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              Text(
                'Popular Products',
                style: AppTextStyles.AlmostBlack17Medium,
              ),
              SizedBox(height: 15.h),

              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is HomeLoaded) {
                      final products = state.products;
                      return GridView.builder(
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              context.push('/ProductDetails');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.White,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16.r),
                                          ),
                                          child: Image.network(
                                            product.image,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.h,
                                          right: 8.w,
                                          child: GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<HomeCubit>()
                                                  .toggleFavorite(product.id);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(4.w),
                                              decoration: BoxDecoration(
                                                color: AppColors.White,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                product.isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 20.sp,
                                                color: product.isLiked
                                                    ? AppColors.Red
                                                    : AppColors.AlmostBlack,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: AppTextStyles
                                              .AlmostBlack15Semibold,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: AppTextStyles
                                              .AlmostBlack13Semibold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is HomeError) {
                      return Center(child: Text(state.message));
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
