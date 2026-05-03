
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class NavIcon extends StatelessWidget {
  const NavIcon({super.key, required this.icon, required this.isSelected});
  final IconData icon;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 30,
      color: isSelected ? Colors.white : AppColors.primaryButton,
    );
  }
}