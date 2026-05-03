import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class BuildIndicator extends StatelessWidget {
  const BuildIndicator({
    super.key,
    required int currentPage,
    required this.index,
  }) : _currentPage = currentPage;

  final int _currentPage;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 5,
      width: _currentPage == index ? 35 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.primaryColor
            : AppColors.primaryColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
