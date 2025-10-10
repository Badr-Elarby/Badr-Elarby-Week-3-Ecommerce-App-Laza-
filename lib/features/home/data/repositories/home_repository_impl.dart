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
      return ProductsResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
