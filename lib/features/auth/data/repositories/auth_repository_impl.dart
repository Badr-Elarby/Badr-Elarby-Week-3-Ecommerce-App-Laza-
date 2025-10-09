import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/refresh_token_request_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final rawResponse = await _remoteDataSource.login(request.toJson());
      final loginResponse = LoginResponseModel.fromJson(rawResponse);

      // ✅ تخزين التوكينز
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponseModel> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final rawResponse = await _remoteDataSource.refreshToken(
        RefreshTokenRequestModel(
          refreshToken: refreshToken,
          useCookies: false,
        ).toJson(),
      );

      final loginResponse = LoginResponseModel.fromJson(rawResponse);

      // ✅ تحديث التوكينز بعد التجديد
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getCurrentUserToken() async {
    try {
      return await _secureStorage.read(key: 'accessToken');
    } catch (e) {
      rethrow;
    }
  }
}
