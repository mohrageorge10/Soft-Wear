import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_images.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key, required this.height, required this.radius});
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.secondaryColor,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(100),
        child: Image.asset(
          Assets.imagesLogo,
          fit: BoxFit.cover,
          height: height,
        ),
      ),
    );
  }
}
