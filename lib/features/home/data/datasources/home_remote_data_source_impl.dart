import 'package:dio/dio.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> getProducts({int? page, int? pageSize}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          if (page != null) 'page': page,
          if (pageSize != null) 'pageSize': pageSize,
        },
      );
      // OPTIMIZATION: Removed debug print() statement for better performance

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Unexpected response format: expected a Map');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch products',
      );
    } catch (e) {
      // OPTIMIZATION: Removed debug print() statement for better performance
      throw Exception('An unknown error occurred while fetching products');
    }
  }
}
