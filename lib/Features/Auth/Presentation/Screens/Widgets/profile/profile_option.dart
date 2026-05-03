import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class ProfileOptionWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileOptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = isDestructive ? AppColors.errorColor : AppColors.primaryButton;

    return Container(
      margin: const EdgeInsets.only(bottom: 18), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(15), 
          ),
          child: Icon(
            icon,
            color: mainColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDestructive ? AppColors.errorColor : AppColors.titleColor,
          ),
        ),
        trailing: Icon(
          isDestructive ? null : Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.black12,
        ),
        onTap: onTap,
      ),
    );
  }
}