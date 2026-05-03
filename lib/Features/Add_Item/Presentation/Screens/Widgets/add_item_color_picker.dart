import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class AddItemColorPicker extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const AddItemColorPicker({super.key, required this.selectedColor, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: AppColors.clothingColors.keys.length,
        itemBuilder: (context, index) {
          String colorName = AppColors.clothingColors.keys.elementAt(index);
          Color colorValue = AppColors.getColorFromName(colorName);
          bool isSelected = selectedColor == colorName;

          return GestureDetector(
            onTap: () => onColorSelected(colorName),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              width: isSelected ? 50 : 40,
              height: isSelected ? 50 : 40,
              decoration: BoxDecoration(
                color: colorValue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : Colors.black12,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected ? [BoxShadow(color: colorValue.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))] : [],
              ),
              child: isSelected
                  ? Icon(Icons.check, color: colorValue.computeLuminance() > 0.5 ? Colors.black : Colors.white, size: 20)
                  : null,
            ),
          );
        },
      ),
    );
  }
}