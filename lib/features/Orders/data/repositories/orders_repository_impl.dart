import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laza/features/Orders/data/models/order_model.dart';
import 'package:laza/features/Orders/data/repositories/orders_repository.dart';

/// Implementation of OrdersRepository using SharedPreferences
class OrdersRepositoryImpl implements OrdersRepository {
  static const String _ordersKey = 'orders';
  final SharedPreferences _prefs;

  OrdersRepositoryImpl(this._prefs);

  @override
  Future<void> saveOrder(OrderModel order) async {
    try {
      log('💾 [OrdersRepository] Starting to save order: ${order.id}');
      final orders = await getOrders();
      log('💾 [OrdersRepository] Current orders count: ${orders.length}');
      orders.insert(0, order); // Add new order at the beginning (newest first)

      final ordersJson = orders.map((o) => jsonEncode(o.toJson())).toList();
      await _prefs.setStringList(_ordersKey, ordersJson);
      log(
        '💾 [OrdersRepository] Order saved successfully: ${order.id}, total orders: ${orders.length}',
      );

      // Verify the save
      final verifyOrders = await getOrders();
      log(
        '💾 [OrdersRepository] Verification - orders in storage: ${verifyOrders.length}',
      );
    } catch (e) {
      log('💾 [OrdersRepository] Error saving order: $e');
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final ordersList = _prefs.getStringList(_ordersKey) ?? [];
      if (ordersList.isEmpty) {
        return [];
      }

      return ordersList
          .map(
            (json) =>
                OrderModel.fromJson(jsonDecode(json) as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      log('Error getting orders: $e');
      return [];
    }
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final orders = await getOrders();
      return orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw StateError('Order not found'),
      );
    } catch (e) {
      log('Error getting order by ID: $e');
      return null;
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      log('🗑️ [OrdersRepository] Deleting order: $orderId');
      final orders = await getOrders();
      // Remove order with matching ID
      orders.removeWhere((order) => order.id == orderId);

      final ordersJson = orders.map((o) => jsonEncode(o.toJson())).toList();
      await _prefs.setStringList(_ordersKey, ordersJson);
      log('🗑️ [OrdersRepository] Order deleted successfully: $orderId');
    } catch (e) {
      log('🗑️ [OrdersRepository] Error deleting order: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearOrders() async {
    try {
      await _prefs.remove(_ordersKey);
      log('All orders cleared');
    } catch (e) {
      log('Error clearing orders: $e');
      throw Exception('Failed to clear orders');
    }
  }
}
