import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/build_action_buttons.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/build_header.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/build_info_cards.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/build_ui_hero.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/edit_item_sheet.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ClothingItem item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late ClothingItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.titleColor),
        title: const Text(
          "Item Details",
          style: TextStyle(
            color: AppColors.titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            BuildUIHero(
              currentItem: _currentItem,
              hashCode: hashCode,
              context: context,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildHeader(currentItem: _currentItem),
                  const SizedBox(height: 26),
                  BuildInfoCards(currentItem: _currentItem),
                  const SizedBox(height: 30),
                  BuildActionButtons(
                    context: context,
                    onEdit: () => _showEditDialog(context),
                    onDelete: () => _confirmDelete(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ================= LOGIC & DIALOGS =================

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text("Delete Item?"),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete this item? This action cannot be undone.",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              showDialog(
                context: ctx,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );

              await context.read<WardrobeCubit>().deleteClothingItem(
                _currentItem.id,
              );

              if (!mounted) return;
              Navigator.pop(ctx); // قفل اللودينج
              Navigator.pop(ctx); // قفل رسالة التأكيد
              Navigator.pop(context); // الرجوع لشاشة الدولاب

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item deleted successfully 🗑️'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditItemSheet(
        item: _currentItem,
        onSave: (color, styles, seasons) async {
          await _saveEdits(color: color, styles: styles, seasons: seasons);
        },
      ),
    );
  }

  Future<void> _saveEdits({
    required String color,
    required List<ClothingStyle> styles,
    required List<ClothingSeason> seasons,
  }) async {
    final repo = WardrobeRepo();
    final result = await repo.updateItem(_currentItem.id, {
      'color': color,
      'styles': styles.map((s) => s.name).toList(),
      'seasons': seasons.map((s) => s.name).toList(),
    });

    if (!mounted) return;

    result.fold(
      (err) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: AppColors.errorColor),
      ),
      (_) {
        setState(() {
          _currentItem = ClothingItem(
            id: _currentItem.id,
            imageUrl: _currentItem.imageUrl,
            category: _currentItem.category,
            color: color,
            seasons: seasons,
            styles: styles,
            userId: _currentItem.userId,
            name: _currentItem.name,
            imageHash: _currentItem.imageHash,
          );
        });

        // 🚀 تحديث صامت للكيوبت عشان الشاشات التانية تسمع
        context.read<WardrobeCubit>().fetchWardrobe(
          forceRefresh: true,
          showLoader: false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item updated successfully! ✨'),
            backgroundColor: AppColors.successColor,
          ),
        );
      },
    );
  }
}
