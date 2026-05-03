import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/placeholder_icon.dart';

class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({
    super.key,
    required this.label,
    required this.itemName,
    this.imageUrl,
  });

  final String label;
  final String itemName;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        PlaceholderIcon(label: label),
                  ),
                )
              : PlaceholderIcon(label: label),
        ),
        const SizedBox(height: 8),
        Text(
          itemName,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
      ],
    );
  }
}
