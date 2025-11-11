import '../datasources/home_remote_data_source.dart';
import '../models/product_model.dart';
import '../models/products_response_model.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProductsResponseModel> getProducts({int? page, int? pageSize}) async {
    try {
      final response = await _remoteDataSource.getProducts(
        page: page,
        pageSize: pageSize,
      );
      final productsResponse = ProductsResponseModel.fromJson(response);

      // Filter out invalid products (e.g., "Object" titles, empty names, test data)
      // Only keep products related to clothing, fashion, shoes, or accessories
      final validProducts = _filterValidProducts(productsResponse.items);

      // Return filtered response while preserving original pagination metadata
      // Note: We filter items but keep original pagination info from API
      // This ensures pagination continues to work correctly
      return ProductsResponseModel(
        items: validProducts,
        page: productsResponse.page,
        pageSize: productsResponse.pageSize,
        totalCount:
            productsResponse.totalCount, // Keep original count for pagination
        hasNextPage: productsResponse.hasNextPage,
        hasPreviousPage: productsResponse.hasPreviousPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Filters out invalid products, keeping only valid fashion/clothing items
  /// Removes products with:
  /// - Invalid names (e.g., "Object", empty, or test data)
  /// - Products not related to fashion/clothing/shoes/accessories
  List<ProductModel> _filterValidProducts(List<ProductModel> products) {
    // Keywords that indicate valid fashion/clothing products
    const validKeywords = [
      'clothes',
      'clothing',
      'fashion',
      'shoes',
      'shoe',
      'dress',
      'bag',
      'jacket',
      'shirt',
      'pants',
      'jeans',
      'sneakers',
      'boots',
      'accessories',
      'accessory',
      'watch',
      'jewelry',
      'hat',
      'cap',
      't-shirt',
      'tshirt',
      'hoodie',
      'sweater',
      'coat',
      'skirt',
      'shorts',
      'belt',
      'wallet',
      'purse',
      'backpack',
    ];

    // Invalid product name patterns to exclude
    const invalidPatterns = [
      'object',
      'test',
      'null',
      'undefined',
      'sample',
      'example',
      'placeholder',
    ];

    return products.where((product) {
      final name = product.name.toLowerCase().trim();
      final description = product.description.toLowerCase().trim();
      final categories = product.categories
          .map((c) => c.toLowerCase())
          .join(' ');

      // Exclude products with invalid names
      if (name.isEmpty ||
          invalidPatterns.any((pattern) => name.contains(pattern))) {
        return false;
      }

      // Exclude products that don't match fashion/clothing keywords
      final combinedText = '$name $description $categories';
      final hasValidKeyword = validKeywords.any(
        (keyword) => combinedText.contains(keyword),
      );

      // Also check if product has valid price and image
      final hasValidData =
          product.price > 0 && product.coverPictureUrl.isNotEmpty;

      return hasValidKeyword && hasValidData;
    }).toList();
  }
}
