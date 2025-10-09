import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/refresh_token_request_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthRemoteDataSourceImpl(this._dio, this._secureStorage);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post('/login', data: request.toJson());
      final loginResponse = LoginResponseModel.fromJson(response.data);
      await _secureStorage.write(
        key: 'accessToken',
        value: loginResponse.accessToken,
      );
      await _secureStorage.write(
        key: 'refreshToken',
        value: loginResponse.refreshToken,
      );
      await _secureStorage.write(
        key: 'expiresAtUtc',
        value: loginResponse.expiresAtUtc.toIso8601String(),
      );
      return loginResponse;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('An unknown error occurred during login');
    }
  }

  @override
  Future<LoginResponseModel> refreshToken(
    RefreshTokenRequestModel request,
  ) async {
    try {
      final response = await _dio.post(
        '/refresh-token',
        data: request.toJson(),
      );
      final loginResponse = LoginResponseModel.fromJson(response.data);
      await _secureStorage.write(
        key: 'accessToken',
        value: loginResponse.accessToken,
      );
      await _secureStorage.write(
        key: 'refreshToken',
        value: loginResponse.refreshToken,
      );
      await _secureStorage.write(
        key: 'expiresAtUtc',
        value: loginResponse.expiresAtUtc.toIso8601String(),
      );
      return loginResponse;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Token refresh failed');
    } catch (e) {
      throw Exception('An unknown error occurred during token refresh');
    }
  }
}
