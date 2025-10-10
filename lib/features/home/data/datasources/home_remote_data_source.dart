abstract class HomeRemoteDataSource {
  Future<Map<String, dynamic>> getProducts({int? page, int? pageSize});
}
