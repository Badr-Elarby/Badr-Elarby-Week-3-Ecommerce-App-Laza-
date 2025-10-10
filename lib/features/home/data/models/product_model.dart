import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String productCode;
  final String name;
  final String description;
  final String arabicName;
  final String arabicDescription;
  final String coverPictureUrl;
  final double price;
  final int stock;
  final double weight;
  final String color;
  final double rating;
  final int reviewsCount;
  final double discountPercentage;
  final List<String> categories;
  final bool isLiked;

  const ProductModel({
    required this.id,
    required this.productCode,
    required this.name,
    required this.description,
    required this.arabicName,
    required this.arabicDescription,
    required this.coverPictureUrl,
    required this.price,
    required this.stock,
    required this.weight,
    required this.color,
    required this.rating,
    required this.reviewsCount,
    required this.discountPercentage,
    required this.categories,
    this.isLiked = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      productCode: json['productCode'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      arabicName: json['arabicName'] as String,
      arabicDescription: json['arabicDescription'] as String,
      coverPictureUrl: json['coverPictureUrl'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      weight: (json['weight'] as num).toDouble(),
      color: json['color'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'] as int,
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'name': name,
      'description': description,
      'arabicName': arabicName,
      'arabicDescription': arabicDescription,
      'coverPictureUrl': coverPictureUrl,
      'price': price,
      'stock': stock,
      'weight': weight,
      'color': color,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'discountPercentage': discountPercentage,
      'categories': categories,
      'isLiked': isLiked,
    };
  }

  ProductModel copyWith({
    String? id,
    String? productCode,
    String? name,
    String? description,
    String? arabicName,
    String? arabicDescription,
    String? coverPictureUrl,
    double? price,
    int? stock,
    double? weight,
    String? color,
    double? rating,
    int? reviewsCount,
    double? discountPercentage,
    List<String>? categories,
    bool? isLiked,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      name: name ?? this.name,
      description: description ?? this.description,
      arabicName: arabicName ?? this.arabicName,
      arabicDescription: arabicDescription ?? this.arabicDescription,
      coverPictureUrl: coverPictureUrl ?? this.coverPictureUrl,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      categories: categories ?? this.categories,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object> get props => [
    id,
    productCode,
    name,
    description,
    arabicName,
    arabicDescription,
    coverPictureUrl,
    price,
    stock,
    weight,
    color,
    rating,
    reviewsCount,
    discountPercentage,
    categories,
    isLiked,
  ];
}
