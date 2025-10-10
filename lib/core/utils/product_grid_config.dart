import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGridConfig {
  static const int crossAxisCount = 2;
  static const double aspectRatio = 0.6; // Adjusted ratio to prevent overflow

  static SliverGridDelegateWithFixedCrossAxisCount get gridDelegate =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ); // Standard card dimensions
  static double get cardWidth =>
      (1.sw - 48.w) / 2; // Account for padding and spacing
  static double get cardHeight => cardWidth / aspectRatio;
  static double get imageHeight =>
      cardHeight * 0.6; // 60% of card height for image
}
