import 'package:laza/features/Orders/data/models/order_model.dart';

/// Abstract repository for managing orders
abstract class OrdersRepository {
  /// Save a completed order
  Future<void> saveOrder(OrderModel order);

  /// Get all saved orders (sorted by date, newest first)
  Future<List<OrderModel>> getOrders();

  /// Get a specific order by ID
  Future<OrderModel?> getOrderById(String orderId);

  /// Delete an order by ID and update local storage
  Future<void> deleteOrder(String orderId);

  /// Clear all orders (for testing/debugging)
  Future<void> clearOrders();
}
