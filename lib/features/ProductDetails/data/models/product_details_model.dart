import 'package:equatable/equatable.dart';

class ProductDetailsModel extends Equatable {
  final String id;
  final String productCode;
  final String name;
  final String description;
  final String nameArabic;
  final String descriptionArabic;
  final String coverPictureUrl;
  final List<String> productPictures;
  final List<String> categories;
  final double price;
  final int stock;
  final double weight;
  final String color;
  final double discountPercentage;
  final double rating;
  final int reviewsCount;
  final String sellerId;

  const ProductDetailsModel({
    required this.id,
    required this.productCode,
    required this.name,
    required this.description,
    required this.nameArabic,
    required this.descriptionArabic,
    required this.coverPictureUrl,
    required this.productPictures,
    required this.categories,
    required this.price,
    required this.stock,
    required this.weight,
    required this.color,
    required this.discountPercentage,
    required this.rating,
    required this.reviewsCount,
    required this.sellerId,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] as String? ?? '',
      productCode: json['productCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      nameArabic: json['nameArabic'] as String? ?? '',
      descriptionArabic: json['descriptionArabic'] as String? ?? '',
      coverPictureUrl: json['coverPictureUrl'] as String? ?? '',
      productPictures:
          (json['productPictures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String? ?? '',
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      sellerId: json['sellerId'] as String? ?? '',
    );
  }

  @override
  bool get inStock => stock > 0;

  List<Object?> get props => [
    id,
    productCode,
    name,
    description,
    nameArabic,
    descriptionArabic,
    coverPictureUrl,
    productPictures,
    categories,
    price,
    stock,
    weight,
    color,
    discountPercentage,
    rating,
    reviewsCount,
    sellerId,
  ];
}
