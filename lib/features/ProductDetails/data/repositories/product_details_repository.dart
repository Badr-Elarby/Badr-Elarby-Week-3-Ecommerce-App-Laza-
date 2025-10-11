import 'package:laza/features/ProductDetails/data/datasources/product_details_datasource.dart';
import 'package:laza/features/ProductDetails/data/models/product_details_model.dart';

class ProductDetailsRepository {
  final ProductDetailsDataSource dataSource;

  ProductDetailsRepository({required this.dataSource});

  Future<ProductDetailsModel> getProductById(String id) async {
    try {
      return await dataSource.getProductById(id);
    } catch (e) {
      throw Exception('Failed to fetch product details: ${e.toString()}');
    }
  }
}
