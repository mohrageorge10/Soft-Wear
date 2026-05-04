import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart'; 
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/image_place_holder.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/item_details_screen.dart'; 

class WeatherStyledOOTDCard extends StatelessWidget {
  // 🚀 ضفنا الـ cubit هنا عشان نقرأ الطقم مباشرة
  const WeatherStyledOOTDCard({super.key, required this.state, required this.cubit});

  final HomeState state;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    // 💡 دايرة التحميل هتترسم "جوه" الكارت لو بنحفظ أو بنغير الطقم
    if (state is HomeOutfitLoading || state is HomeOutfitActionLoading) {
      return _buildContainer(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        ),
      );
    }

    // 💡 بنقرا الطقم من الكيوبت مباشرة 
    final outfit = cubit.currentOutfit;
    if (outfit == null) return const SizedBox.shrink(); 

    final outfitItems = outfit.items;

    return _buildContainer(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: outfitItems.map((item) {
            String itemLabel = item.category.name[0].toUpperCase() + item.category.name.substring(1);
            if (item.category == ClothingCategory.jacket && outfit.hasOptionalJacket) {
              itemLabel = "Jacket (Optional)";
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailsScreen(item: item),
                    ),
                  );
                },
                child: ImagePlaceHolder(
                  label: itemLabel, 
                  itemName: item.color,
                  imageUrl: item.imageUrl,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.chartMustard.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: child,
    );
  }
}