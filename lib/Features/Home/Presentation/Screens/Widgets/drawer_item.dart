import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color = AppColors.titleColor,
  });
  final IconData icon;
  final Color? color;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        horizontalTitleGap: 5,
        leading: Icon(icon, color: color, size: 26),
        title: Text(
          text,
          style:  TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
