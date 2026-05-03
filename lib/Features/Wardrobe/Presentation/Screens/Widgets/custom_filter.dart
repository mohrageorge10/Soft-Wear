import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_icons.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/filter_bottom_buttons.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/filter_color_selection.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/filter_label.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/filter_season_selection.dart';

class CustomFilter extends StatefulWidget {
  final List<String> filterColors;
  final List<ClothingSeason> filterSeasons;
  final List<ClothingStyle> filterStyles;

  const CustomFilter({
    super.key,
    required this.filterColors,
    required this.filterSeasons,
    required this.filterStyles,
  });

  @override
  State<CustomFilter> createState() => _CustomFilterState();
}

class _CustomFilterState extends State<CustomFilter> {
  late List<String> filterColors;
  late List<ClothingSeason> filterSeasons;
  late List<ClothingStyle> filterStyles;

@override
  void initState() {
    super.initState();
    filterColors = List.from(widget.filterColors);
    filterSeasons = List.from(widget.filterSeasons);
    filterStyles = List.from(widget.filterStyles);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // ================= HEADER & DRAG HANDLE =================
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
                Center(
                  child: Text(
                    AppStrings.filter,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.black12, height: 1),

          // ================= SCROLLABLE FILTERS =================
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎨 Color Filter
                  FilterLabel(txt: "Color", icon: AppIcons.color),
                  const SizedBox(height: 16),
                  FilterColorSelection(filterColors: filterColors),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.black12, height: 1),
                  const SizedBox(height: 30),

                  // ☀️ Season Filter
                  FilterLabel(txt: "Season", icon: AppIcons.season),
                  const SizedBox(height: 16),
                  CustomFilterWrap<ClothingSeason>(
                    items: ClothingSeason.values.where(
                      (s) => s != ClothingSeason.all,
                    ),
                    selectedItems: filterSeasons,
                    labelBuilder: (season) => season.name.toUpperCase(),
                    onSelectionChanged: (season, selected) {
                      setState(() {
                        if (selected) {
                          filterSeasons.add(season);
                        } else {
                          filterSeasons.remove(season);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.black12, height: 1),
                  const SizedBox(height: 30),

                  // 👔 Style Filter
                  FilterLabel(txt: "Style", icon: AppIcons.style),
                  const SizedBox(height: 16),
                  CustomFilterWrap<ClothingStyle>(
                    items: ClothingStyle.values,
                    selectedItems: filterStyles,
                    labelBuilder: (style) => style.name.toUpperCase(),
                    onSelectionChanged: (style, selected) {
                      setState(() {
                        if (selected) {
                          filterStyles.add(style);
                        } else {
                          filterStyles.remove(style);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

        // ================= STICKY BOTTOM BUTTONS =================
          FilterBottomButtons(
            onClear: () {
              Navigator.pop(context, {
                'colors': <String>[],
                'seasons': <ClothingSeason>[],
                'styles': <ClothingStyle>[],
              });
            },
            onApply: () {
              Navigator.pop(context, {
                'colors': filterColors,
                'seasons': filterSeasons,
                'styles': filterStyles,
              });
            },
          ),
        ],
      ),
    );
  }
}
