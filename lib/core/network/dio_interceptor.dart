import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laza/features/auth/data/models/refresh_token_request_model.dart';
import 'package:laza/features/auth/data/models/login_response_model.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._dio, this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _secureStorage.read(key: 'refreshToken');
        if (refreshToken != null) {
          // Create a new Dio instance for token refresh to avoid infinite loop
          final refreshDio = Dio(_dio.options);

          // Try to refresh the token
          final response = await refreshDio.post(
            '${_dio.options.baseUrl}refresh-token',
            data: RefreshTokenRequestModel(
              refreshToken: refreshToken,
              useCookies: false,
            ).toJson(),
          );

          if (response.statusCode == 200) {
            final loginResponse = LoginResponseModel.fromJson(response.data);

            // Save new tokens
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

            // Retry the original request with the new access token
            err.requestOptions.headers['Authorization'] =
                'Bearer ${loginResponse.accessToken}';
            final retryResponse = await _dio.fetch(err.requestOptions);
            return handler.resolve(retryResponse);
          }
        }

        // If refresh fails or no refresh token, clear all tokens
        await _secureStorage.delete(key: 'accessToken');
        await _secureStorage.delete(key: 'refreshToken');
        await _secureStorage.delete(key: 'expiresAtUtc');
        return handler.next(err);
      } on DioException catch (e) {
        // If refresh token also fails, clear tokens
        await _secureStorage.delete(key: 'accessToken');
        await _secureStorage.delete(key: 'refreshToken');
        await _secureStorage.delete(key: 'expiresAtUtc');
        return handler.next(e);
      } catch (e) {
        // Handle other errors during token refresh
        await _secureStorage.delete(key: 'accessToken');
        await _secureStorage.delete(key: 'refreshToken');
        await _secureStorage.delete(key: 'expiresAtUtc');
        return handler.next(err);
      }
    }
    super.onError(err, handler);
  }
}
