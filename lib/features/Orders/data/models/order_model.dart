import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:laza/features/Cart/data/models/cart_item_model.dart';

/// Model representing a completed order
// OPTIMIZATION: @immutable annotation enables Dart analyzer optimizations
@immutable
class OrderModel extends Equatable {
  final String id;
  final List<CartItemModel> items;
  final double subtotal;
  final double shipping;
  final double total;
  final Map<String, dynamic>? address;
  final DateTime orderDate;
  final String? paymentId; // Paymob order ID if available

  const OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    this.address,
    required this.orderDate,
    this.paymentId,
  });

  /// Create from JSON for local storage
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      address: json['address'] as Map<String, dynamic>?,
      orderDate: DateTime.parse(json['orderDate'] as String),
      paymentId: json['paymentId'] as String?,
    );
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,
      'address': address,
      'orderDate': orderDate.toIso8601String(),
      'paymentId': paymentId,
    };
  }

  /// Get formatted order date string
  String get formattedDate {
    return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
  }

  /// Get formatted order time string
  String get formattedTime {
    return '${orderDate.hour.toString().padLeft(2, '0')}:${orderDate.minute.toString().padLeft(2, '0')}';
  }

  /// Get total number of items in order
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  List<Object?> get props => [
    id,
    items,
    subtotal,
    shipping,
    total,
    address,
    orderDate,
    paymentId,
  ];
}
