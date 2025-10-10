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
      print('API Response Structure: ${response.data}'); // Debug print

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Unexpected response format: expected a Map');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch products',
      );
    } catch (e) {
      print('Error details: $e'); // Debug print
      throw Exception('An unknown error occurred while fetching products');
    }
  }
}
