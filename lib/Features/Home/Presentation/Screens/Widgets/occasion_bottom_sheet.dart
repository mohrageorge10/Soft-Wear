import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';

class OccasionBottomSheet extends StatelessWidget {
  final HomeCubit cubit;

  const OccasionBottomSheet({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final occasions = ['Casual', 'Formal', 'Sporty', 'Party'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.subtitleColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "What's the occasion? ✨",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.titleColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: occasions.map((style) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  cubit.generateOutfit(style); // 🚀 بننادي على الكيوبت هنا
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldFill,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      style.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}