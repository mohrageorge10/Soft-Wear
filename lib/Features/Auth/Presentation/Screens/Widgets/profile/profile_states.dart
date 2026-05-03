import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/profile_state_card.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class ProfileStates extends StatelessWidget {
  const ProfileStates({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WardrobeCubit, WardrobeState>(
      builder: (context, state) {
        // 🚀 Determine if data is still loading
        bool isLoading = state is WardrobeLoading || state is WardrobeInitial;

        String wardrobeCount = "00";
        String favCount = "00";
        String savedCount = "00";
        String canvasCount = "00";

        if (state is WardrobeLoaded) {
          wardrobeCount = state.items.length.toString().padLeft(2, '0');
          favCount = state.favCount.toString().padLeft(2, '0');
          savedCount = state.savedCount.toString().padLeft(2, '0');
        }

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ProfileStateCard(
              title: "WARDROBE",
              count: wardrobeCount,
              color: Colors.blueAccent,
              icon: Icons.checkroom_rounded,
              isLoading: isLoading,
              onTapAction: () {
                Navigator.pop(context, 2);
              },
            ),
            ProfileStateCard(
              title: "FAVORITES",
              count: favCount,
              color: AppColors.favColor,
              icon: Icons.favorite_rounded,
              routeName: AppRoutes.favoriteOutfitsScreen,
              isLoading: isLoading,
            ),
            ProfileStateCard(
              title: "SAVED",
              count: savedCount,
              color: AppColors.chartMustard,
              icon: Icons.bookmarks_rounded,
              routeName: AppRoutes.savedOutfitsScreen,
              isLoading: isLoading,
            ),
          ],
        );
      },
    );
  }
}
