import '../models/products_response_model.dart';

abstract class HomeRepository {
  Future<ProductsResponseModel> getProducts({int? page, int? pageSize});
}
