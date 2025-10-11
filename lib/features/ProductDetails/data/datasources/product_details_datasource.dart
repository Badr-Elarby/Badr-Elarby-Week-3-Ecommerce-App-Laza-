import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:laza/features/ProductDetails/data/models/product_details_model.dart';

class ProductDetailsDataSource {
  final Dio dio;

  ProductDetailsDataSource({required this.dio});

  Future<ProductDetailsModel> getProductById(String id) async {
    try {
      log('🛍️ [ProductDetailsDataSource] Fetching product: $id');
      final response = await dio.get('/products/$id');

      if (response.statusCode == 200) {
        log('🛍️ [ProductDetailsDataSource] Successfully fetched product data');
        return ProductDetailsModel.fromJson(response.data);
      } else {
        final errorMessage =
            response.data['message'] ?? 'Failed to fetch product details';
        log('🛍️ [ProductDetailsDataSource] Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data['message'] ?? 'Invalid product ID';
        log('🛍️ [ProductDetailsDataSource] DioError: $errorMessage');
        throw Exception(errorMessage);
      }
      log('🛍️ [ProductDetailsDataSource] Network error: ${e.message}');
      throw Exception('Failed to fetch product: ${e.message}');
    } catch (e) {
      log('🛍️ [ProductDetailsDataSource] Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }
}
