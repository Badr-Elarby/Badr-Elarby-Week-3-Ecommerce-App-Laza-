import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/Cart/data/repositories/cart_repository.dart';
import 'package:laza/features/Cart/data/services/cart_service.dart';
import 'package:laza/features/Cart/presentation/cubits/cart_state.dart';
import 'package:laza/features/ProductDetails/data/models/product_details_model.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final CartService _cartService;

  CartCubit(this._cartRepository)
    : _cartService = CartService(),
      super(CartInitial());

  Future<void> loadCartItems() async {
    try {
      emit(CartLoading());
      log('🛒 [CartCubit] Loading cart items');

      final cartItems = await _cartRepository.getCartItems();
      final totalAmount = await _cartRepository.getCartTotal();
      final totalItems = await _cartRepository.getCartItemsCount();

      if (cartItems.isEmpty) {
        emit(CartEmpty());
        log('🛒 [CartCubit] Cart is empty');
      } else {
        emit(
          CartLoaded(
            cartItems: cartItems,
            totalAmount: totalAmount,
            totalItems: totalItems,
          ),
        );
        log(
          '🛒 [CartCubit] Cart loaded with ${cartItems.length} items, total: \$${totalAmount.toStringAsFixed(2)}',
        );
      }
    } catch (e) {
      log('🛒 [CartCubit] Error loading cart: $e');
      emit(CartError('Failed to load cart items'));
    }
  }

  Future<void> addProduct(
    ProductDetailsModel product, {
    int quantity = 1,
    String? color,
    String? size,
  }) async {
    try {
      log('🛒 [CartCubit] Adding product to cart: ${product.name}');
      await _cartService.addProduct(
        product,
        quantity: quantity,
        color: color,
        size: size,
      );
      await loadCartItems(); // Reload cart to get updated state
    } catch (e) {
      log('🛒 [CartCubit] Error adding product: $e');
      emit(CartError('Failed to add product to cart'));
    }
  }

  Future<void> removeProduct(String productId) async {
    try {
      log('🛒 [CartCubit] Removing product from cart: $productId');
      await _cartService.removeProduct(productId);
      await loadCartItems(); // Reload cart to get updated state
    } catch (e) {
      log('🛒 [CartCubit] Error removing product: $e');
      emit(CartError('Failed to remove product from cart'));
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      log(
        '🛒 [CartCubit] Updating quantity for product: $productId to $quantity',
      );
      await _cartService.updateQuantity(productId, quantity);
      await loadCartItems(); // Reload cart to get updated state
    } catch (e) {
      log('🛒 [CartCubit] Error updating quantity: $e');
      emit(CartError('Failed to update quantity'));
    }
  }

  Future<void> clearCart() async {
    try {
      log('🛒 [CartCubit] Clearing cart');
      await _cartService.clearCart();
      emit(CartEmpty());
    } catch (e) {
      log('🛒 [CartCubit] Error clearing cart: $e');
      emit(CartError('Failed to clear cart'));
    }
  }

  Future<int> getCartItemsCount() async {
    try {
      return await _cartRepository.getCartItemsCount();
    } catch (e) {
      log('🛒 [CartCubit] Error getting cart items count: $e');
      return 0;
    }
  }

  Future<double> getCartTotal() async {
    try {
      return await _cartRepository.getCartTotal();
    } catch (e) {
      log('🛒 [CartCubit] Error getting cart total: $e');
      return 0.0;
    }
  }
}
