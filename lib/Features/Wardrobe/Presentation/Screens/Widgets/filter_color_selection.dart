import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class FilterColorSelection extends StatefulWidget {
  final List<String> filterColors;
  const FilterColorSelection({super.key, required this.filterColors});

  @override
  State<FilterColorSelection> createState() => _FilterColorSelectionState();
}

class _FilterColorSelectionState extends State<FilterColorSelection> {
  late List<String> filterColors;
  
  @override
  void initState() {
    super.initState();
    filterColors = widget.filterColors;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: AppColors.clothingColors.entries.map((entry) {
        final colorName = entry.key;
        final colorValue = entry.value;
        final isSelected = filterColors.contains(colorName);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                filterColors.remove(colorName);
              } else {
                filterColors.add(colorName);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.only(
              left: 6,
              right: 14,
              top: 6,
              bottom: 6,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorValue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  colorName,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.titleColor,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
