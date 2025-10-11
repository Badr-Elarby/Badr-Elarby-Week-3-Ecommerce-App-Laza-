import 'dart:developer';
import 'package:laza/features/Cart/data/repositories/cart_repository.dart';
import 'package:laza/features/ProductDetails/data/models/product_details_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  CartRepository? _repository;

  void initialize(CartRepository repository) {
    _repository = repository;
    log('🛒 [CartService] Initialized with repository');
  }

  Future<void> addProduct(
    ProductDetailsModel product, {
    int quantity = 1,
    String? color,
    String? size,
  }) async {
    if (_repository == null) {
      throw Exception('CartService not initialized');
    }

    try {
      log('🛒 [CartService] Adding product to cart: ${product.name}');
      await _repository!.addProduct(
        product,
        quantity: quantity,
        color: color,
        size: size,
      );
    } catch (e) {
      log('🛒 [CartService] Error adding product: $e');
      rethrow;
    }
  }

  Future<void> removeProduct(String productId) async {
    if (_repository == null) {
      throw Exception('CartService not initialized');
    }

    try {
      log('🛒 [CartService] Removing product from cart: $productId');
      await _repository!.removeProduct(productId);
    } catch (e) {
      log('🛒 [CartService] Error removing product: $e');
      rethrow;
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (_repository == null) {
      throw Exception('CartService not initialized');
    }

    try {
      log(
        '🛒 [CartService] Updating quantity for product: $productId to $quantity',
      );
      await _repository!.updateQuantity(productId, quantity);
    } catch (e) {
      log('🛒 [CartService] Error updating quantity: $e');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    if (_repository == null) {
      throw Exception('CartService not initialized');
    }

    try {
      log('🛒 [CartService] Clearing cart');
      await _repository!.clearCart();
    } catch (e) {
      log('🛒 [CartService] Error clearing cart: $e');
      rethrow;
    }
  }
}
