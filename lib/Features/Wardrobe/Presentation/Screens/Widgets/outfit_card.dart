import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/AI/saved_outfit_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/item_details_screen.dart';

class OutfitCard extends StatelessWidget {
  final SavedOutfit outfit;
  final VoidCallback onActionPressed; 
  final IconData actionIcon; 
  final Color actionIconColor; 
  
  // 🚀 التعديل هنا: خليناها Nullable عشان لو مش عايزين الزرار يظهر
  final VoidCallback? onWearPressed; 
  final bool showWornScore;

  const OutfitCard({
    super.key,
    required this.outfit,
    required this.onActionPressed,
    required this.actionIcon,
    required this.actionIconColor,
    this.onWearPressed, // 🚀 شيلنا الـ required من هنا
    this.showWornScore = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.titleColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // 1. بادج الستايل
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        outfit.style.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    // 3. بادج مرات اللبس
                    if (showWornScore && outfit.wornScore > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.chartMustard.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.checkroom_rounded, size: 14, color: AppColors.chartMustard),
                            const SizedBox(width: 4),
                            Text(
                              "Worn ${outfit.wornScore}x",
                              style: const TextStyle(
                                color: AppColors.chartMustard,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // 💡 زرار الأكشن (سلة أو قلب مكسور)
              IconButton(
                onPressed: onActionPressed,
                icon: Icon(actionIcon, color: actionIconColor, size: 26),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ================= ITEMS ROW =================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: outfit.items.map((item) {
                String label = item.category.name[0].toUpperCase() + item.category.name.substring(1);
                if (item.category == ClothingCategory.jacket && outfit.hasOptionalJacket) {
                  label = "Jacket (Optional)";
                }
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.textFieldFill,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                                ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                                : Icon(Icons.checkroom_outlined, size: 36, color: AppColors.subtitleColor.withValues(alpha: 0.4)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: const TextStyle(fontSize: 11, color: AppColors.subtitleColor, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.dividerColor),
          const SizedBox(height: 12),

          // ================= FOOTER =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Added ${_formatDate(outfit.savedAt)}",
                style: const TextStyle(color: AppColors.subtitleColor, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              
              // 🚀 التعديل هنا: الزرار هيظهر بس لو اتبعتتله دالة onWearPressed
              if (onWearPressed != null)
                ElevatedButton.icon(
                  onPressed: onWearPressed,
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text("WEAR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.titleColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 13),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return "${diff}d ago";
  }
}