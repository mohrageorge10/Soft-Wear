import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class AddItemChipsSelection {
  static String formatEnumName(String name) {
    String cleanName = name.split('.').last;
    String spaced = cleanName.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  static Widget buildCategoryChips({
    required ClothingCategory? selectedCategory,
    required ValueChanged<ClothingCategory> onSelected,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ClothingCategory.values.map((cat) {
          bool isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(formatEnumName(cat.name)),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.primaryColor,
              backgroundColor: AppColors.textFieldFill,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.titleColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
              onSelected: (selected) { if (selected) onSelected(cat); },
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget buildMultiSelectChips<T>({
    required List<T> items,
    required List<T> selectedItems,
    required void Function(T item, bool selected) onSelectionChanged,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items.map((item) {
          bool isSelected = selectedItems.contains(item);
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(formatEnumName(item.toString())),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.primaryColor,
              backgroundColor: AppColors.textFieldFill,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.titleColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
              onSelected: (selected) => onSelectionChanged(item, selected),
            ),
          );
        }).toList(),
      ),
    );
  }
}