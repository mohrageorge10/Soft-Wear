import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/item_details_screen.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class RecentlyAdded extends StatelessWidget {
  const RecentlyAdded({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WardrobeCubit, WardrobeState>(
      builder: (context, state) {
        if (state is WardrobeLoaded) {
          final recentItems = context.read<WardrobeCubit>().getRecentlyAdded();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "RECENTLY ADDED",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.titleColor,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 15),

              if (recentItems.isEmpty)
                const Text(
                  "No items added yet. Add some clothes to your wardrobe!",
                  style: TextStyle(color: AppColors.subtitleColor),
                ),

              if (recentItems.isNotEmpty)
                SizedBox(
                  height: 120, // فضلنا محتفظين بالارتفاع ده
                  child: ListView.builder(
                    // 🚀 عشان لو الضل كبير أوي الـ ListView متقصوش
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: recentItems.length,
                    itemBuilder: (context, index) {
                      final item = recentItems[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemDetailsScreen(item: item),
                            ),
                          );
                        },
                        child: Container(
                          // 🚀 السحر هنا: ضفنا Margin فوق وتحت عشان الضل يلاقي مكان يظهر فيه
                          margin: const EdgeInsets.only(
                            right: 15,
                            bottom: 10, // مساحة للضل من تحت
                            top: 5, // مساحة صغيرة من فوق
                          ),
                          width: 90,
                          decoration: BoxDecoration(
                            color: AppColors.textFieldFill,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [AppColors.boxShadow()],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                item.imageUrl != null &&
                                    item.imageUrl!.isNotEmpty
                                ? Image.network(
                                    item.imageUrl!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: AppColors.primaryColor,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
