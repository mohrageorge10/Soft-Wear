import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class UserAvatarWidget extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final XFile? pickedImage;     // 🚀 ضفنا دي
  final String? profilePicUrl;  // 🚀 وضفنا دي

  const UserAvatarWidget({
    super.key,
    required this.radius,
    this.borderWidth = 2.0,
    this.pickedImage,          // 🚀 اختياري
    this.profilePicUrl,        // 🚀 اختياري
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryColor,
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.secondaryColor.withValues(alpha: 0.2),
        backgroundImage: pickedImage != null
            ? FileImage(File(pickedImage!.path))
            : (profilePicUrl != null && profilePicUrl!.isNotEmpty)
                ? NetworkImage(profilePicUrl!) as ImageProvider
                : null,
        child: (pickedImage == null && (profilePicUrl == null || profilePicUrl!.isEmpty))
            ? Icon(
                Icons.person_rounded,
                size: radius * 1.2,
                color: AppColors.primaryColor,
              )
            : null,
      ),
    );
  }
}