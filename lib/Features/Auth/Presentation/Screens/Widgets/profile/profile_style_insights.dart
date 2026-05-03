import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Shared/Widgets/custom_loading_indicator.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/profile_style_progress.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class ProfileStyleInsights extends StatelessWidget {
  const ProfileStyleInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.styleInsights,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.subtitleColor,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 15),

        BlocBuilder<WardrobeCubit, WardrobeState>(
          builder: (context, state) {
            if (state is WardrobeLoading) {
              return const Center(child: CustomLoadingIndicator(size: 30));
            }

            if (state is WardrobeLoaded) {
              List<Map<String, dynamic>> styleData = context.read<WardrobeCubit>().calculateStyleInsights();

              if (styleData.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      "Add items to your wardrobe to unlock your Style Insights! ✨",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.subtitleColor),
                    ),
                  ),
                );
              }
              List<Color> rankColors = [
                AppColors.primaryButton,
                Colors.blueAccent,
                Colors.teal,
                Colors.deepOrangeAccent,
              ];

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(styleData.length, (index) {
                    Color progressColor = index < rankColors.length
                        ? rankColors[index]
                        : Colors.grey;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == styleData.length - 1 ? 0 : 15,
                      ),
                      child: ProfileStyleProgress(
                        title: styleData[index]['title'],
                        percentage: styleData[index]['percentage'],
                        color: progressColor,
                      ),
                    );
                  }),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}