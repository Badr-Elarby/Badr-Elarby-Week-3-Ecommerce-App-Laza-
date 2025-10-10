import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/core/utils/string_extension.dart';
import 'package:laza/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:laza/features/home/presentation/widgits/BrandCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit;
  String? _selectedCategory;

  final List<String> _categories = ['adidas', 'nike', 'fila', 'puma', 'others'];

  @override
  void initState() {
    super.initState();
    _homeCubit = getIt<HomeCubit>();
    _homeCubit.getProducts();
  }

  List<dynamic> _filterProducts(List<dynamic> products) {
    if (_selectedCategory == null) return products;

    if (_selectedCategory == 'others') {
      return products.where((product) {
        final categories = product.categories
            .map((e) => e.toLowerCase())
            .toList();
        return !categories.contains('adidas') &&
            !categories.contains('nike') &&
            !categories.contains('fila') &&
            !categories.contains('puma');
      }).toList();
    }

    return products.where((product) {
      final categories = product.categories
          .map((e) => e.toLowerCase())
          .toList();
      return categories.contains(_selectedCategory!.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: TextStyle(color: AppColors.Red, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => _homeCubit.getProducts(),
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeSuccess) {
              return Column(
                children: [
                  // Custom App Bar
                  Container(
                    width: double.infinity,
                    color: AppColors.White,
                    padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello',
                                style: AppTextStyles.AlmostBlack22Semibold,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Welcome to Laza',
                                style: AppTextStyles.Grey15Regular,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none,
                            color: AppColors.AlmostBlack,
                            size: 28.sp,
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(width: 8.w),
                        CircleAvatar(
                          backgroundColor: AppColors.Gray,
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.White,
                            size: 24.sp,
                          ),
                          radius: 20.r,
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            // Search Bar
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.Gray,
                                ),
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
                                  child: Text(
                                    'View All',
                                    style: AppTextStyles.Gray13Regular,
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),

                            SizedBox(
                              height: 60.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  final category = _categories[index];
                                  final isSelected =
                                      _selectedCategory == category;

                                  String imageAsset;
                                  switch (category.toLowerCase()) {
                                    case 'adidas':
                                      imageAsset = 'assets/images/Adidas.png';
                                      break;
                                    case 'nike':
                                      imageAsset = 'assets/images/Vector.png';
                                      break;
                                    case 'fila':
                                      imageAsset = 'assets/images/fila-9 1.png';
                                      break;
                                    case 'puma':
                                      imageAsset = 'assets/images/puma.jpg';
                                      break;
                                    default:
                                      imageAsset =
                                          'assets/images/images.png'; // Default for 'others'
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(right: 12.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = isSelected
                                              ? null
                                              : category;
                                        });
                                      },
                                      child: BrandCard(
                                        image: imageAsset,
                                        name: category.capitalize(),
                                        isSelected: isSelected,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 20.h),
                            Text(
                              'Popular Products',
                              style: AppTextStyles.AlmostBlack17Medium,
                            ),
                            SizedBox(height: 15.h),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _filterProducts(state.products).length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 16.h,
                                    crossAxisSpacing: 16.w,
                                    childAspectRatio: 0.7,
                                  ),
                              itemBuilder: (context, index) {
                                final filteredProducts = _filterProducts(
                                  state.products,
                                );
                                final product = filteredProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/product-details',
                                      extra: product,
                                    );
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
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(
                                                        16.r,
                                                      ),
                                                    ),
                                                child: Image.network(
                                                  product.coverPictureUrl,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Image.asset(
                                                          'assets/images/image.png',
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value:
                                                            loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                top: 8.h,
                                                right: 8.w,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // TODO: Implement favorite functionality
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                      4.w,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.White,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.favorite_border,
                                                      size: 20.sp,
                                                      color:
                                                          AppColors.AlmostBlack,
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
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
