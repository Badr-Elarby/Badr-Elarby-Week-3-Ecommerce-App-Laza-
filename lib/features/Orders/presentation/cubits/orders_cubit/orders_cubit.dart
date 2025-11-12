import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laza/features/Orders/data/models/order_model.dart';
import 'package:laza/features/Orders/data/repositories/orders_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _ordersRepository;

  OrdersCubit(this._ordersRepository) : super(OrdersInitial());

  /// Load all orders from storage
  Future<void> loadOrders() async {
    emit(OrdersLoading());
    try {
      final orders = await _ordersRepository.getOrders();
      if (orders.isEmpty) {
        emit(OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  /// Save a new order
  Future<void> saveOrder(OrderModel order) async {
    try {
      print('📦 [OrdersCubit] Saving order: ${order.id}');
      await _ordersRepository.saveOrder(order);
      print('📦 [OrdersCubit] Order saved successfully, reloading orders...');
      // Reload orders to reflect the new order
      await loadOrders();
      print('📦 [OrdersCubit] Orders reloaded');
    } catch (e) {
      print('📦 [OrdersCubit] Error saving order: $e');
      emit(OrdersError('Failed to save order: $e'));
    }
  }

  /// Delete an order by ID
  Future<void> deleteOrder(String orderId) async {
    try {
      print('🗑️ [OrdersCubit] Deleting order: $orderId');
      await _ordersRepository.deleteOrder(orderId);
      print('🗑️ [OrdersCubit] Order deleted, reloading orders...');
      // Reload orders to reflect the deletion
      await loadOrders();
      print('🗑️ [OrdersCubit] Orders reloaded after deletion');
    } catch (e) {
      print('🗑️ [OrdersCubit] Error deleting order: $e');
      emit(OrdersError('Failed to delete order: $e'));
    }
  }
}
