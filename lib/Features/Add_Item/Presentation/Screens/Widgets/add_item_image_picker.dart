import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class AddItemImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onPickImage;

  const AddItemImagePicker({super.key, required this.image, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Container(
          width: 180,
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.textFieldFill,
            borderRadius: BorderRadius.circular(30),
            border: image == null
                ? Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3), width: 2)
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: image != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(image!, fit: BoxFit.cover),
                      const Positioned(
                        bottom: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_rounded, size: 50, color: AppColors.primaryColor.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      const Text("Upload Photo", style: TextStyle(color: AppColors.subtitleColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}