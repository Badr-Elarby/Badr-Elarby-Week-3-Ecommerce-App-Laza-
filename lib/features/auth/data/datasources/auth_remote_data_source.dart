abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(Map<String, dynamic> requestData);
  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> requestData);
}
