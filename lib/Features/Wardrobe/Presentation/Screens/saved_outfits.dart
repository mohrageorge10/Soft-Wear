import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_icons.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/outfit_card.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/outfit_filter_sheet.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class SavedOutfitsScreen extends StatefulWidget {
  const SavedOutfitsScreen({super.key});

  @override
  State<SavedOutfitsScreen> createState() => _SavedOutfitsScreenState();
}

class _SavedOutfitsScreenState extends State<SavedOutfitsScreen> {
  // Local UI State for filters
  List<ClothingStyle> activeStyles = [];
  List<ClothingSeason> activeSeasons = [];
  String currentSort = 'newest';
  String currentType = 'all';

  @override
  void initState() {
    super.initState();
    // Trigger Cubit to fetch data
    context.read<WardrobeCubit>().fetchSavedOutfits();
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
          initialSort: currentSort,
          initialType: currentType,
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        activeStyles = result['styles'] as List<ClothingStyle>;
        activeSeasons = result['seasons'] as List<ClothingSeason>;
        currentSort = result['sort'] as String;
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
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text("Delete Outfit?"),
          ],
        ),
        content: const Text("This outfit will be removed from your saved list."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
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
    bool hasActiveFilters = activeStyles.isNotEmpty || activeSeasons.isNotEmpty || currentSort != 'newest' || currentType != 'all';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.titleColor),
        title: const Text(
          "SAVED OUTFITS",
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
                    onPressed: () => context.read<WardrobeCubit>().fetchSavedOutfits(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Let Cubit handle the heavy lifting
          final processedOutfits = context.read<WardrobeCubit>().getFilteredSavedOutfits(
            styles: activeStyles,
            seasons: activeSeasons,
            type: currentType,
            sort: currentSort,
          );

          if (processedOutfits.isEmpty) return _buildEmptyState(hasActiveFilters);

          return RefreshIndicator(
            onRefresh: () => context.read<WardrobeCubit>().fetchSavedOutfits(),
            color: AppColors.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: processedOutfits.length,
              itemBuilder: (context, index) {
                final outfit = processedOutfits[index];
                return Dismissible(
                  key: Key(outfit.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _showConfirmDialog(context);
                  },
                  onDismissed: (direction) {
                    context.read<WardrobeCubit>().deleteSavedOutfit(outfit.id);
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 30),
                  ),
                  child: OutfitCard(
                    outfit: outfit,
                    actionIcon: AppIcons.delete,
                    actionIconColor: AppColors.errorColor,
                    onActionPressed: () async {
                      bool? confirm = await _showConfirmDialog(context);
                      if (confirm == true) {
                        context.read<WardrobeCubit>().deleteSavedOutfit(outfit.id);
                      }
                    },
                    onWearPressed: () {
                      context.read<WardrobeCubit>().wearSavedOutfit(outfit);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Awesome choice! Outfit marked as worn. ✨"),
                          backgroundColor: AppColors.successColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      );
                    },
                  ),
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
          Icon(Icons.style_outlined, size: 80, color: AppColors.subtitleColor.withValues(alpha: 0.3)),
          const SizedBox(height: 20),
          Text(
            hasActiveFilters ? "No outfits match this filter" : "No saved outfits yet",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.titleColor),
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? "Try adjusting your filters to see more results."
                : "Generate an outfit and tap the\nbookmark icon to save it!",
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.subtitleColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}