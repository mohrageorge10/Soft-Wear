import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_icons.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/outfit_card.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/outfit_filter_sheet.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Local UI State for filters
  List<ClothingStyle> activeStyles = [];
  List<ClothingSeason> activeSeasons = [];
  String currentType = 'all';

  @override
  void initState() {
    super.initState();
    // Trigger Cubit to fetch data
    context.read<WardrobeCubit>().fetchFavoriteOutfits();
  }

  Future<void> _showFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return OutfitFilterSheet(
          initialStyles: activeStyles,
          initialSeasons: activeSeasons,
          initialType: currentType,
          showSort: false,
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        activeStyles = result['styles'] as List<ClothingStyle>;
        activeSeasons = result['seasons'] as List<ClothingSeason>;
        currentType = result['type'] as String;
      });
    }
  }

  Future<bool?> _showConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.heart_broken_rounded, color: AppColors.errorColor),
            SizedBox(width: 8),
            Text("Remove from Favorites?"),
          ],
        ),
        content: const Text("This outfit will be removed from your favorites list."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Remove", style: TextStyle(color: Colors.white)),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasActiveFilters = activeStyles.isNotEmpty || activeSeasons.isNotEmpty || currentType != 'all';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.titleColor),
        title: const Text(
          "FAVORITE OUTFITS",
          style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(AppIcons.filter),
                if (hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.errorColor, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterSheet,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<WardrobeCubit, WardrobeState>(
        builder: (context, state) {
          if (state is WardrobeLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          }
          if (state is WardrobeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: AppColors.errorColor),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: AppColors.subtitleColor)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<WardrobeCubit>().fetchFavoriteOutfits(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Let Cubit handle the heavy lifting
          final processedOutfits = context.read<WardrobeCubit>().getFilteredFavorites(
            styles: activeStyles,
            seasons: activeSeasons,
            type: currentType,
          );

          if (processedOutfits.isEmpty) return _buildEmptyState(hasActiveFilters);

          return RefreshIndicator(
            onRefresh: () => context.read<WardrobeCubit>().fetchFavoriteOutfits(),
            color: AppColors.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: processedOutfits.length,
              itemBuilder: (context, index) {
                final outfit = processedOutfits[index];
                return OutfitCard(
                  outfit: outfit,
                  actionIcon: Icons.heart_broken_rounded,
                  actionIconColor: AppColors.favColor,
                  onActionPressed: () async {
                    bool? confirm = await _showConfirmDialog(context);
                    if (confirm == true) {
                      context.read<WardrobeCubit>().removeFavoriteOutfit(outfit.id);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool hasActiveFilters) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border_rounded, size: 80, color: AppColors.favColor),
          const SizedBox(height: 20),
          Text(
            hasActiveFilters ? "No favorites match this filter" : "No favorite outfits yet",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.titleColor),
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? "Try adjusting your filters to see more results."
                : "Generate an outfit and tap the\nheart icon to add it to favorites!",
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.subtitleColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}