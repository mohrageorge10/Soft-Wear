import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double strokeWidth;
  final double? size; 
  final Color color;

  const CustomLoadingIndicator({
    super.key,
    this.strokeWidth = 2.0,
    this.size, 
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}