import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/ProductDetails/data/models/product_details_model.dart';
import 'package:laza/features/ProductDetails/presentation/cubit/product_details_state.dart';
import 'package:laza/features/ProductDetails/data/repositories/product_details_repository.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsRepository repository;

  ProductDetailsCubit({required this.repository})
    : super(ProductDetailsInitial());

  Future<void> fetchProductDetails(String productId) async {
    try {
      emit(ProductDetailsLoading());
      log('🛍️ [ProductDetailsCubit] Fetching details for product: $productId');

      final product = await repository.getProductById(productId);
      emit(ProductDetailsLoaded(product));
      log(
        '🛍️ [ProductDetailsCubit] Successfully loaded product: ${product.id}',
      );
    } catch (error) {
      log('🛍️ [ProductDetailsCubit] Error loading product: $error');
      emit(ProductDetailsError(error.toString()));
    }
  }
}
