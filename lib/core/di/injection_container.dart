import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:laza/core/network/dio_interceptor.dart';
import 'package:laza/core/routing/app_router.dart';
import 'package:laza/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laza/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:laza/features/auth/data/repositories/auth_repository.dart';
import 'package:laza/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laza/features/auth/presentation/cubits/login_cubit/login_cubit.dart';

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
        baseUrl: 'https://accessories-eshop.runasp.net/api/auth/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(getIt<AuthInterceptor>());
    return dio;
  });
  log('setupGetIt: Dio registered');

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(() {
    log('setupGetIt: Registering AuthRemoteDataSource');
    return AuthRemoteDataSourceImpl(
      getIt<Dio>(),
      getIt<FlutterSecureStorage>(),
    );
  });
  log('setupGetIt: AuthRemoteDataSource registered');

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() {
    log('setupGetIt: Registering AuthRepository');
    return AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
    );
  });
  log('setupGetIt: AuthRepository registered');

  // Cubits
  getIt.registerFactory<LoginCubit>(() {
    log('setupGetIt: Registering LoginCubit');
    return LoginCubit(getIt<AuthRepository>());
  });
  log('setupGetIt: LoginCubit registered');

  // App Router
  getIt.registerLazySingleton<AppRouter>(() {
    log('setupGetIt: Registering AppRouter');
    return AppRouter();
  });
  log('setupGetIt: AppRouter registered');

  log('setupGetIt: GetIt setup completed');
}
