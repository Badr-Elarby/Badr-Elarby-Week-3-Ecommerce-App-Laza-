import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';
import 'package:laza/features/Orders/presentation/cubits/orders_cubit/orders_cubit.dart';
import 'package:laza/features/Orders/data/models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Load orders when screen initializes
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SoftCloud,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        title: Text('My Orders', style: AppTextStyles.AlmostBlack22Semibold),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.Gray,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: AppTextStyles.Grey15Regular,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => context.read<OrdersCubit>().loadOrders(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is OrdersEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64.sp,
                      color: AppColors.Gray,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No orders yet',
                      style: AppTextStyles.AlmostBlack17Semibold,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your completed orders will appear here',
                      style: AppTextStyles.Grey15Regular,
                    ),
                  ],
                ),
              );
            }

            if (state is OrdersLoaded) {
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return _buildOrderCard(order, context);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// Build a compact order card with delete button
  Widget _buildOrderCard(OrderModel order, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header with date, total, and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id.substring(0, 8)}',
                        style: AppTextStyles.AlmostBlack15Semibold,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${order.formattedDate} at ${order.formattedTime}',
                        style: AppTextStyles.Grey15Regular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: AppTextStyles.AlmostBlack17Semibold.copyWith(
                        color: AppColors.LightPurple,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, order),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20.sp,
                        color: AppColors.Red,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(maxWidth: 24.w),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: AppColors.Gray.withOpacity(0.3)),
            SizedBox(height: 12.h),
            // Order items preview
            Text(
              '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
              style: AppTextStyles.AlmostBlack15Semibold,
            ),
            SizedBox(height: 8.h),
            // Show first 2 items, then "and X more" if applicable
            ...order.items
                .take(2)
                .map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: item.imageUrl.isNotEmpty
                              ? Image.network(
                                  item.imageUrl,
                                  width: 40.w,
                                  height: 40.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/image.png',
                                      width: 40.w,
                                      height: 40.w,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/image.png',
                                  width: 40.w,
                                  height: 40.w,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: AppTextStyles.AlmostBlack15Semibold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Qty: ${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                                style: AppTextStyles.Grey15Regular,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            if (order.items.length > 2)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'and ${order.items.length - 2} more item${order.items.length - 2 > 1 ? 's' : ''}',
                  style: AppTextStyles.Grey15Regular,
                ),
              ),
            SizedBox(height: 12.h),
            Divider(color: AppColors.Gray.withOpacity(0.3)),
            SizedBox(height: 12.h),
            // Order summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: AppTextStyles.Grey15Regular),
                Text(
                  '\$${order.subtotal.toStringAsFixed(2)}',
                  style: AppTextStyles.AlmostBlack15Semibold,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping', style: AppTextStyles.Grey15Regular),
                Text(
                  '\$${order.shipping.toStringAsFixed(2)}',
                  style: AppTextStyles.AlmostBlack15Semibold,
                ),
              ],
            ),
            // Address if available
            if (order.address != null) ...[
              SizedBox(height: 12.h),
              Divider(color: AppColors.Gray.withOpacity(0.3)),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, size: 20.sp, color: AppColors.Gray),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      order.address!['address'] as String? ??
                          'Address not available',
                      style: AppTextStyles.Grey15Regular,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog for deleting an order
  void _showDeleteConfirmationDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Order'),
        content: Text(
          'Are you sure you want to delete order #${order.id.substring(0, 8)}?'
          '\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Show loading state
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deleting order...')),
              );

              try {
                // Delete the order
                if (!context.mounted) return;
                await context.read<OrdersCubit>().deleteOrder(order.id);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete order: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
