import 'package:equatable/equatable.dart';
import 'package:laza/features/Cart/data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> cartItems;
  final double totalAmount;
  final int totalItems;

  const CartLoaded({
    required this.cartItems,
    required this.totalAmount,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [cartItems, totalAmount, totalItems];

  CartLoaded copyWith({
    List<CartItemModel>? cartItems,
    double? totalAmount,
    int? totalItems,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
      totalAmount: totalAmount ?? this.totalAmount,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartEmpty extends CartState {}
