import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Shared/Widgets/wear_button.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';

class OutfitActionButtons extends StatelessWidget {
  final HomeCubit cubit;
  final HomeState state;
  final bool isActionLoading;

  const OutfitActionButtons({
    super.key,
    required this.cubit,
    required this.state,
    required this.isActionLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // زرار Regenerate
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black12),
          ),
          child: IconButton(
            onPressed: isActionLoading
                ? null
                : () {
                    if (state is HomeOutfitGenerated) {
                      final generatedState = state as HomeOutfitGenerated;
                      cubit.generateOutfit(generatedState.style);
                    }
                  },
            icon: Icon(
              Icons.refresh_rounded,
              color: isActionLoading ? Colors.grey : AppColors.primaryColor,
            ),
            tooltip: 'Regenerate Outfit',
          ),
        ),
        const SizedBox(width: 10),

        // زرار Save
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black12),
          ),
          child: IconButton(
            onPressed: isActionLoading ? null : () => cubit.saveOutfit(),
            icon: Icon(Icons.bookmark_add_outlined,
                color: isActionLoading ? Colors.grey : AppColors.primaryColor),
            tooltip: 'Save Outfit',
          ),
        ),
        const SizedBox(width: 10),

        // زرار Favorite
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black12),
          ),
          child: IconButton(
            onPressed: isActionLoading ? null : () => cubit.saveOutfitToFavorites(),
            icon: Icon(Icons.favorite_border_rounded,
                color: isActionLoading ? Colors.grey : AppColors.favColor),
            tooltip: 'Add to Favorites',
          ),
        ),
        const SizedBox(width: 10),

        WearButton(isActionLoading: isActionLoading, cubit: cubit),
      ],
    );
  }
}