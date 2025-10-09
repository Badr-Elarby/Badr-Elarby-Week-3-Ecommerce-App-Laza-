import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/refresh_token_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<LoginResponseModel> refreshToken(RefreshTokenRequestModel request);
}
