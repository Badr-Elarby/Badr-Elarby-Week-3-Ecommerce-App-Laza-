import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// OPTIMIZATION: @immutable annotation enables Dart analyzer optimizations
@immutable
class CartItemModel extends Equatable {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? color;
  final String? size;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.color,
    this.size,
  });

  // Calculate total price for this item (price * quantity)
  double get totalPrice => price * quantity;

  // Create a copy with updated quantity
  CartItemModel copyWith({
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? color,
    String? size,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'color': color,
      'size': size,
    };
  }

  // Create from JSON for local storage
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
      color: json['color'] as String?,
      size: json['size'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    imageUrl,
    price,
    quantity,
    color,
    size,
  ];

  @override
  String toString() {
    return 'CartItemModel(productId: $productId, name: $name, price: $price, quantity: $quantity)';
  }
}
