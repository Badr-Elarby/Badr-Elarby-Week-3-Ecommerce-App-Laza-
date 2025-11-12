import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'product_model.dart';

// OPTIMIZATION: @immutable annotation enables Dart analyzer optimizations
@immutable
class ProductsResponseModel extends Equatable {
  final List<ProductModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const ProductsResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      items: (json['items'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList(),
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalCount: json['totalCount'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'page': page,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  @override
  List<Object> get props => [
    items,
    page,
    pageSize,
    totalCount,
    hasNextPage,
    hasPreviousPage,
  ];
}
