import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_icons.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/filter_bottom_buttons.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/filter_label.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/filter_season_selection.dart';

class OutfitFilterSheet extends StatefulWidget {
  final List<ClothingStyle> initialStyles;
  final List<ClothingSeason> initialSeasons;
  final String initialSort;
  final String initialType; // 🚀 1. ضفنا النوع (all, two_piece, dress)
  final bool showSort;

  const OutfitFilterSheet({
    super.key,
    required this.initialStyles,
    required this.initialSeasons,
    this.initialSort = 'Newest',
    required this.initialType,
    this.showSort = true,
  });

  @override
  State<OutfitFilterSheet> createState() => _OutfitFilterSheetState();
}

class _OutfitFilterSheetState extends State<OutfitFilterSheet> {
  late List<ClothingStyle> selectedStyles;
  late List<ClothingSeason> selectedSeasons;
  late String selectedSort;
  late String selectedType; // 🚀

  @override
  void initState() {
    super.initState();
    selectedStyles = List.from(widget.initialStyles);
    selectedSeasons = List.from(widget.initialSeasons);
    selectedSort = widget.initialSort;
    selectedType = widget.initialType; // 🚀
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * 0.85, // كبرناها عشان المحتوى زاد
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // ================= HEADER =================
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.subtitleColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Filter & Sort",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black12, height: 1),

          // ================= FILTER CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showSort) ...[
                    // 🔽 1. Sort Section
                    FilterLabel(txt: "Sort By", icon: Icons.sort_rounded),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildSortChip('Newest First', 'newest'),
                        _buildSortChip('Most Worn', 'most_worn'),
                        _buildSortChip('Least Worn', 'least_worn'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(color: Colors.black12, height: 1),
                    const SizedBox(height: 30),
                  ],

                  // 👗 2. Outfit Type Section (النوع الجديد)
                  FilterLabel(
                    txt: "Outfit Type",
                    icon: Icons.checkroom_rounded,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildTypeChip('All Types', 'all'),
                      _buildTypeChip('Top & Bottom', 'two_piece'),
                      _buildTypeChip('Dress', 'dress'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.black12, height: 1),
                  const SizedBox(height: 30),

                  // 👔 3. Style Section
                  FilterLabel(txt: "Style / Occasion", icon: AppIcons.style),
                  const SizedBox(height: 16),
                  CustomFilterWrap<ClothingStyle>(
                    items: ClothingStyle.values,
                    selectedItems: selectedStyles,
                    labelBuilder: (style) => style.name.toUpperCase(),
                    onSelectionChanged: (style, selected) {
                      setState(() {
                        selected
                            ? selectedStyles.add(style)
                            : selectedStyles.remove(style);
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.black12, height: 1),
                  const SizedBox(height: 30),

                  // ☀️ 4. Season Section
                  FilterLabel(txt: "Season", icon: AppIcons.season),
                  const SizedBox(height: 16),
                  CustomFilterWrap<ClothingSeason>(
                    items: ClothingSeason.values.where(
                      (s) => s != ClothingSeason.all,
                    ),
                    selectedItems: selectedSeasons,
                    labelBuilder: (season) => season.name.toUpperCase(),
                    onSelectionChanged: (season, selected) {
                      setState(() {
                        selected
                            ? selectedSeasons.add(season)
                            : selectedSeasons.remove(season);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ================= BOTTOM BUTTONS =================
          FilterBottomButtons(
            onClear: () {
              Navigator.pop(context, {
                'styles': <ClothingStyle>[],
                'seasons': <ClothingSeason>[],
                'sort': 'newest',
                'type': 'all', // 🚀
              });
            },
            onApply: () {
              Navigator.pop(context, {
                'styles': selectedStyles,
                'seasons': selectedSeasons,
                'sort': selectedSort,
                'type': selectedType, // 🚀
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = selectedSort == value;
    return _buildCustomChip(
      label,
      isSelected,
      () => setState(() => selectedSort = value),
    );
  }

  // 🚀 دالة لزراير النوع
  Widget _buildTypeChip(String label, String value) {
    final isSelected = selectedType == value;
    return _buildCustomChip(
      label,
      isSelected,
      () => setState(() => selectedType = value),
    );
  }

  // دالة مشتركة للـ Chips عشان نقلل الكود
  Widget _buildCustomChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
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
        if (selected) onTap();
      },
    );
  }
}
