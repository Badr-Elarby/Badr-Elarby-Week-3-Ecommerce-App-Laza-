import '../models/login_response_model.dart';
import '../models/login_request_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<LoginResponseModel> refreshToken();
  Future<String?> getCurrentUserToken();
}
