import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laza/core/utils/app_colors.dart';
import 'package:laza/core/utils/app_styles.dart';

class BrandCard extends StatelessWidget {
  final String image;
  final String name;
  final bool isSelected;

  const BrandCard({
    required this.image,
    required this.name,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      width: 110.w, // مستطيل ثابت العرض
      height: 44.h,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.LightPurple : AppColors.SoftCloud,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 28.w, height: 28.w, fit: BoxFit.contain),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              name,
              style: isSelected
                  ? AppTextStyles.AlmostBlack15Semibold.copyWith(
                      color: AppColors.White,
                    )
                  : AppTextStyles.AlmostBlack15Semibold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
