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
      return await _remoteDataSource.login(request);
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
      return await _remoteDataSource.refreshToken(
        RefreshTokenRequestModel(refreshToken: refreshToken, useCookies: false),
      );
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
