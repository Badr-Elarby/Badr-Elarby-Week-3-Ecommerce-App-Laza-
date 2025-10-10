import 'package:dio/dio.dart';

import 'auth_remote_data_source.dart';

import 'package:dio/dio.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> requestData) async {
    try {
      final response = await _dio.post('/auth/login', data: requestData);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('An unknown error occurred during login');
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(
    Map<String, dynamic> requestData,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/refresh-token',
        data: requestData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Token refresh failed');
    } catch (e) {
      throw Exception('An unknown error occurred during token refresh');
    }
  }
}
