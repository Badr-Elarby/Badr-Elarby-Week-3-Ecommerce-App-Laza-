import 'dart:developer';

import 'package:dio/dio.dart';
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
import 'package:laza/features/Cart/presentation/cubits/cart_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  log('setupGetIt: Starting GetIt setup');

  // Secure Storage (register first as it's needed by AuthInterceptor)
  getIt.registerLazySingleton<FlutterSecureStorage>(() {
    log('setupGetIt: Registering FlutterSecureStorage');
    return const FlutterSecureStorage();
  });
  log('setupGetIt: FlutterSecureStorage registered');

  // AuthInterceptor (register before Dio to avoid circular dependency)
  getIt.registerLazySingleton<AuthInterceptor>(() {
    log('setupGetIt: Registering AuthInterceptor');
    return AuthInterceptor(Dio(), getIt<FlutterSecureStorage>());
  });
  log('setupGetIt: AuthInterceptor registered');

  // Dio & Interceptors
  getIt.registerLazySingleton<Dio>(() {
    log('setupGetIt: Registering Dio');
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
  log('setupGetIt: Dio registered');

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(() {
    log('setupGetIt: Registering AuthRemoteDataSource');
    return AuthRemoteDataSourceImpl(getIt<Dio>());
  });
  log('setupGetIt: AuthRemoteDataSource registered');

  getIt.registerLazySingleton<HomeRemoteDataSource>(() {
    log('setupGetIt: Registering HomeRemoteDataSource');
    return HomeRemoteDataSourceImpl(getIt<Dio>());
  });
  log('setupGetIt: HomeRemoteDataSource registered');

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() {
    log('setupGetIt: Registering AuthRepository');
    return AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
    );
  });
  log('setupGetIt: AuthRepository registered');

  getIt.registerLazySingleton<HomeRepository>(() {
    log('setupGetIt: Registering HomeRepository');
    return HomeRepositoryImpl(getIt<HomeRemoteDataSource>());
  });
  log('setupGetIt: HomeRepository registered');

  // Local Storage
  final sharedPreferences = await SharedPreferences.getInstance();

  // Cubits
  getIt.registerFactory<LoginCubit>(() {
    log('setupGetIt: Registering LoginCubit');
    return LoginCubit(getIt<AuthRepository>());
  });
  log('setupGetIt: LoginCubit registered');

  getIt.registerFactory<HomeCubit>(() {
    log('setupGetIt: Registering HomeCubit');
    return HomeCubit(getIt<HomeRepository>(), sharedPreferences);
  });
  log('setupGetIt: HomeCubit registered');

  // App Router
  getIt.registerLazySingleton<AppRouter>(() {
    log('setupGetIt: Registering AppRouter');
    return AppRouter();
  });
  log('setupGetIt: AppRouter registered');
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
    log('[DI] Registering FavoritesCubit as lazySingleton');
    final cubit = FavoritesCubit(sharedPreferences);
    log(
      '[DI] Created FavoritesCubit with hashCode: ${identityHashCode(cubit)}',
    );
    return cubit;
  });
  log('[DI] FavoritesCubit registered successfully');

  // Product Details Feature Dependencies
  getIt.registerLazySingleton<ProductDetailsDataSource>(
    () => ProductDetailsDataSource(dio: getIt<Dio>()),
  );
  log('[DI] ProductDetailsDataSource registered');

  getIt.registerLazySingleton<ProductDetailsRepository>(
    () =>
        ProductDetailsRepository(dataSource: getIt<ProductDetailsDataSource>()),
  );
  log('[DI] ProductDetailsRepository registered');

  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(repository: getIt<ProductDetailsRepository>()),
  );
  log('[DI] ProductDetailsCubit registered');

  // Cart Feature Dependencies
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sharedPreferences),
  );
  log('[DI] CartRepository registered');

  // Initialize CartService
  CartService().initialize(getIt<CartRepository>());
  log('[DI] CartService initialized');

  getIt.registerFactory<CartCubit>(() => CartCubit(getIt<CartRepository>()));
  log('[DI] CartCubit registered');

  log('setupGetIt: GetIt setup completed');
}
