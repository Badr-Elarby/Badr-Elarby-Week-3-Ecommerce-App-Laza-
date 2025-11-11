import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/injection_container.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/core/utils/product_grid_config.dart';
import 'package:laza/core/utils/string_extension.dart';
import 'package:laza/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:laza/features/home/presentation/widgits/BrandCard.dart';
import 'package:laza/features/home/presentation/widgets/home_product_card.dart';
import 'package:laza/core/routing/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit;
  late final ScrollController _scrollController;
  String? _selectedCategory;

  final List<String> _categories = ['adidas', 'nike', 'fila', 'puma', 'others'];

  @override
  void initState() {
    super.initState();
    _homeCubit = getIt<HomeCubit>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _homeCubit.getProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Detects when user scrolls near bottom and loads next page
  void _onScroll() {
    // Safety check: ensure scroll controller is attached and has valid position
    if (!_scrollController.hasClients) return;
    
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      _homeCubit.loadNextPage();
    }
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
                      controller: _scrollController, // Attach scroll controller for pagination
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
                            Builder(
                              builder: (context) {
                                // Calculate filtered products once per build
                                final filteredProducts = _filterProducts(state.products);
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  itemCount: filteredProducts.length,
                                  gridDelegate: ProductGridConfig.gridDelegate,
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    return GestureDetector(
                                      key: ValueKey('product_${product.id}'),
                                      onTap: () {
                                        context.pushNamed(
                                          AppRoutes.productDetails,
                                          pathParameters: {'id': product.id},
                                        );
                                      },
                                      child: HomeProductCard(product: product),
                                    );
                                  },
                                );
                              },
                            ),
                            // Loading indicator for pagination
                            if (state.isLoadingMore)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.h),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            // End of list indicator
                            if (!state.hasMorePages && state.products.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.h),
                                child: Center(
                                  child: Text(
                                    'No more products',
                                    style: AppTextStyles.Grey15Regular,
                                  ),
                                ),
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
