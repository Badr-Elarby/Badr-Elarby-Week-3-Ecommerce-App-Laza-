import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:laza/core/network/dio_interceptor.dart';
import 'package:laza/core/routing/app_router.dart';
import 'package:laza/core/services/local_storage_service.dart';
import 'package:laza/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laza/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:laza/features/auth/data/repositories/auth_repository.dart';
import 'package:laza/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laza/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:laza/features/home/data/datasources/home_remote_data_source.dart';
import 'package:laza/features/home/data/datasources/home_remote_data_source_impl.dart';
import 'package:laza/features/home/data/repositories/home_repository.dart';
import 'package:laza/features/home/data/repositories/home_repository_impl.dart';
import 'package:laza/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:laza/features/onboarding/data/repositories/gender_repository_impl.dart';
import 'package:laza/features/onboarding/data/repositories/gender_repository.dart';
import 'package:laza/features/onboarding/presentation/cubits/gender_cubit/gender_cubit.dart';
import 'package:laza/features/favorites/presentation/cubits/favorites_cubit/favorites_cubit.dart';
import 'package:laza/features/ProductDetails/data/datasources/product_details_datasource.dart';
import 'package:laza/features/ProductDetails/data/repositories/product_details_repository.dart';
import 'package:laza/features/ProductDetails/presentation/cubit/product_details_cubit.dart';
import 'package:laza/features/Cart/data/repositories/cart_repository.dart';
import 'package:laza/features/Cart/data/services/cart_service.dart';
import 'package:laza/features/Payment/data/services/paymob_service.dart';
import 'package:laza/features/Cart/presentation/cubits/cart_cubit.dart';
import 'package:laza/features/Orders/data/repositories/orders_repository.dart';
import 'package:laza/features/Orders/data/repositories/orders_repository_impl.dart';
import 'package:laza/features/Orders/presentation/cubits/orders_cubit/orders_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

// OPTIMIZATION: Conditional logging for performance in debug mode only
Future<void> setupGetIt() async {
  if (kDebugMode) log('setupGetIt: Starting GetIt setup');

  // Secure Storage (register first as it's needed by AuthInterceptor)
  getIt.registerLazySingleton<FlutterSecureStorage>(() {
    // OPTIMIZATION: Reduced logging (was logging every registration)
    return const FlutterSecureStorage();
  });

  // AuthInterceptor (register before Dio to avoid circular dependency)
  getIt.registerLazySingleton<AuthInterceptor>(() {
    return AuthInterceptor(Dio(), getIt<FlutterSecureStorage>());
  });

  // Dio & Interceptors
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://accessories-eshop.runasp.net/api/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(getIt<AuthInterceptor>());
    return dio;
  });

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(() {
    return AuthRemoteDataSourceImpl(getIt<Dio>());
  });

  getIt.registerLazySingleton<HomeRemoteDataSource>(() {
    return HomeRemoteDataSourceImpl(getIt<Dio>());
  });

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() {
    return AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
    );
  });

  getIt.registerLazySingleton<HomeRepository>(() {
    return HomeRepositoryImpl(getIt<HomeRemoteDataSource>());
  });

  // Local Storage
  final sharedPreferences = await SharedPreferences.getInstance();

  // Cubits
  getIt.registerFactory<LoginCubit>(() {
    return LoginCubit(getIt<AuthRepository>());
  });

  getIt.registerFactory<HomeCubit>(() {
    return HomeCubit(getIt<HomeRepository>(), sharedPreferences);
  });

  // App Router
  getIt.registerLazySingleton<AppRouter>(() {
    return AppRouter();
  });
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(sharedPreferences),
  );

  // Gender Repository
  getIt.registerLazySingleton<GenderRepository>(
    () => GenderRepositoryImpl(getIt<LocalStorageService>()),
  );

  // Gender Cubit
  getIt.registerFactory<GenderCubit>(
    () => GenderCubit(getIt<GenderRepository>()),
  );

  // Favorites Feature Dependencies
  getIt.registerLazySingleton<FavoritesCubit>(() {
    final cubit = FavoritesCubit(sharedPreferences);
    return cubit;
  });

  // Product Details Feature Dependencies
  // Product Details Feature Dependencies
  getIt.registerLazySingleton<ProductDetailsDataSource>(
    () => ProductDetailsDataSource(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<ProductDetailsRepository>(
    () =>
        ProductDetailsRepository(dataSource: getIt<ProductDetailsDataSource>()),
  );

  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(repository: getIt<ProductDetailsRepository>()),
  );

  // Cart Feature Dependencies
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sharedPreferences),
  );

  // Initialize CartService
  CartService().initialize(getIt<CartRepository>());

  // Paymob Payment Service
  getIt.registerLazySingleton<PaymobService>(() {
    return PaymobService(dio: Dio());
  });

  getIt.registerFactory<CartCubit>(() => CartCubit(getIt<CartRepository>()));

  // Orders Feature Dependencies
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(sharedPreferences),
  );

  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(getIt<OrdersRepository>()),
  );

  // OPTIMIZATION: Reduced logging - keep only final completion log
  if (kDebugMode) log('setupGetIt: GetIt setup completed');
}
