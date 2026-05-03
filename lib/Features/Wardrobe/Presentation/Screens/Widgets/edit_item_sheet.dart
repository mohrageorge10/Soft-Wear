
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/custom_button.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/item_details_screen.dart';

class EditItemSheet extends StatefulWidget {
  final ClothingItem item;
  final Function(String color, List<ClothingStyle> styles, List<ClothingSeason> seasons) onSave;

  const EditItemSheet({required this.item, required this.onSave});

  @override
  State<EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends State<EditItemSheet> {
  late List<ClothingStyle> selectedStyles;
  late List<ClothingSeason> selectedSeasons;
  late String? selectedColor;

  @override
  void initState() {
    super.initState();
    selectedStyles = List.from(widget.item.styles);
    selectedSeasons = List.from(widget.item.seasons);
    selectedColor = widget.item.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(color: AppColors.backgroundColor, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: AppColors.subtitleColor.withOpacity(0.3), borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            const Text("Edit Item", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.titleColor)),
            const SizedBox(height: 20),
            
            const Text("Color", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.subtitleColor)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: AppColors.clothingColors.entries.map((entry) {
                final isSelected = selectedColor == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = entry.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : AppColors.textFieldFill,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: isSelected ? AppColors.primaryColor : AppColors.borderColor, width: isSelected ? 1.5 : 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 24, height: 24, decoration: BoxDecoration(color: entry.value, shape: BoxShape.circle, border: Border.all(color: Colors.black12))),
                        const SizedBox(width: 8),
                        Text(entry.key, style: TextStyle(color: isSelected ? AppColors.primaryColor : AppColors.titleColor, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            
            const Text("Style & Occasion", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.subtitleColor)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: ClothingStyle.values.map((style) {
                final isSelected = selectedStyles.contains(style);
                return FilterChip(
                  label: Text(style.name.toUpperCase()), selected: isSelected, showCheckmark: false, selectedColor: AppColors.primaryColor,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.titleColor, fontWeight: FontWeight.w600),
                  onSelected: (val) => setState(() => val ? selectedStyles.add(style) : selectedStyles.remove(style)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            
            const Text("Suitable Seasons", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.subtitleColor)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: ClothingSeason.values.map((season) {
                final isSelected = selectedSeasons.contains(season);
                return FilterChip(
                  label: Text(season.name.toUpperCase()), selected: isSelected, showCheckmark: false, selectedColor: AppColors.primaryColor,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.titleColor, fontWeight: FontWeight.w600),
                  onSelected: (val) => setState(() => val ? selectedSeasons.add(season) : selectedSeasons.remove(season)),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            
            CustomButton(
              title: "SAVE CHANGES", icon: Icons.save_rounded, color: AppColors.primaryButton,
              onPressed: () {
                if (selectedStyles.isEmpty || selectedSeasons.isEmpty || selectedColor == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select color, styles, and seasons'), backgroundColor: AppColors.errorColor));
                  return;
                }
                Navigator.pop(context);
                widget.onSave(selectedColor!, selectedStyles, selectedSeasons);
              },
            ),
          ],
        ),
      ),
    );
  }
}