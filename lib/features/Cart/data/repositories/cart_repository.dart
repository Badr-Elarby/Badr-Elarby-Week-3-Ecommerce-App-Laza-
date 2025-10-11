import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laza/features/Cart/data/models/cart_item_model.dart';
import 'package:laza/features/ProductDetails/data/models/product_details_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addProduct(
    ProductDetailsModel product, {
    int quantity = 1,
    String? color,
    String? size,
  });
  Future<void> removeProduct(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
  Future<int> getCartItemsCount();
  Future<double> getCartTotal();
}

class CartRepositoryImpl implements CartRepository {
  static const String _cartKey = 'cart_items';
  final SharedPreferences _prefs;

  CartRepositoryImpl(this._prefs);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final cartJson = _prefs.getString(_cartKey);
      if (cartJson == null || cartJson.isEmpty) {
        return [];
      }

      final List<dynamic> cartList = json.decode(cartJson);
      return cartList
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error getting cart items: $e');
      return [];
    }
  }

  @override
  Future<void> addProduct(
    ProductDetailsModel product, {
    int quantity = 1,
    String? color,
    String? size,
  }) async {
    try {
      final cartItems = await getCartItems();

      // Check if product already exists in cart
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.productId == product.id,
      );

      if (existingItemIndex != -1) {
        // Update quantity if product already exists
        final existingItem = cartItems[existingItemIndex];
        cartItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      } else {
        // Add new product to cart
        final cartItem = CartItemModel(
          productId: product.id,
          name: product.name,
          imageUrl: product.coverPictureUrl,
          price: product.price,
          quantity: quantity,
          color: color,
          size: size,
        );
        cartItems.add(cartItem);
      }

      await _saveCartItems(cartItems);
      log('Product added to cart: ${product.name}');
    } catch (e) {
      log('Error adding product to cart: $e');
      throw Exception('Failed to add product to cart');
    }
  }

  @override
  Future<void> removeProduct(String productId) async {
    try {
      final cartItems = await getCartItems();
      cartItems.removeWhere((item) => item.productId == productId);
      await _saveCartItems(cartItems);
      log('Product removed from cart: $productId');
    } catch (e) {
      log('Error removing product from cart: $e');
      throw Exception('Failed to remove product from cart');
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeProduct(productId);
        return;
      }

      final cartItems = await getCartItems();
      final itemIndex = cartItems.indexWhere(
        (item) => item.productId == productId,
      );

      if (itemIndex != -1) {
        cartItems[itemIndex] = cartItems[itemIndex].copyWith(
          quantity: quantity,
        );
        await _saveCartItems(cartItems);
        log('Quantity updated for product: $productId to $quantity');
      }
    } catch (e) {
      log('Error updating quantity: $e');
      throw Exception('Failed to update quantity');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _prefs.remove(_cartKey);
      log('Cart cleared');
    } catch (e) {
      log('Error clearing cart: $e');
      throw Exception('Failed to clear cart');
    }
  }

  @override
  Future<int> getCartItemsCount() async {
    try {
      final cartItems = await getCartItems();
      return cartItems.fold<int>(0, (total, item) => total + item.quantity);
    } catch (e) {
      log('Error getting cart items count: $e');
      return 0;
    }
  }

  @override
  Future<double> getCartTotal() async {
    try {
      final cartItems = await getCartItems();
      return cartItems.fold<double>(
        0.0,
        (total, item) => total + item.totalPrice,
      );
    } catch (e) {
      log('Error calculating cart total: $e');
      return 0.0;
    }
  }

  Future<void> _saveCartItems(List<CartItemModel> cartItems) async {
    final cartJson = json.encode(
      cartItems.map((item) => item.toJson()).toList(),
    );
    await _prefs.setString(_cartKey, cartJson);
  }
}
