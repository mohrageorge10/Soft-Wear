import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class CustomFilterWrap<T> extends StatelessWidget {
  final Iterable<T> items; 
  final List<T> selectedItems; 
  final String Function(T) labelBuilder;
  final void Function(T item, bool isSelected) onSelectionChanged;

  const CustomFilterWrap({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.labelBuilder,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        
        return FilterChip(
          label: Text(labelBuilder(item)),
          selected: isSelected,
          showCheckmark: false,
          backgroundColor: Colors.white,
          selectedColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.titleColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
          onSelected: (selected) {
            onSelectionChanged(item, selected);
          },
        );
      }).toList(),
    );
  }
}