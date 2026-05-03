import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Add_Item/Presentation/cubit/add_item_cubit.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/cubit/layout_cubit.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

// 🚀 الويدجتس المفصولة
import 'Widgets/add_item_image_picker.dart';
import 'Widgets/add_item_color_picker.dart';
import 'Widgets/add_item_chips_selection.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  ClothingCategory? selectedCategory;
  String? selectedColor;
  List<ClothingStyle> selectedStyles = [];
  List<ClothingSeason> selectedSeasons = [];

  final _sectionHeaderStyle = const TextStyle(color: AppColors.titleColor, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2);

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  void _saveItem(BuildContext context) {
    if (_image == null) return _showMessage('Please upload an image first 📸');
    if (selectedCategory == null) return _showMessage('Please select a Category 👕');
    if (selectedColor == null) return _showMessage('Please select a color 🎨');
    if (selectedSeasons.isEmpty || selectedStyles.isEmpty) {
      return _showMessage('Please select at least one Season and Style ✨');
    }

    if (_formKey.currentState!.validate()) {
      context.read<AddItemCubit>().saveItem(
            category: selectedCategory!,
            color: selectedColor!,
            styles: selectedStyles,
            seasons: selectedSeasons,
            imageFile: _image,
          );
    }
  }

  void _showMessage(String message, {Color color = AppColors.errorColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _image = null;
      selectedCategory = null;
      selectedColor = null;
      selectedStyles.clear();
      selectedSeasons.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.addItem.toUpperCase(),
          style: const TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AddItemCubit, AddItemState>(
        listener: (context, state) {
          if (state is AddItemSuccess) {
            context.read<WardrobeCubit>().fetchWardrobe(forceRefresh: true, showLoader: false);
            _showMessage('Added to your wardrobe! ✨', color: AppColors.successColor);
            
            
            _resetForm();
            context.read<LayoutCubit>().changeBottomNav(2); 
          } else if (state is AddItemError) {
            _showMessage(state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📸 Image Picker
                  AddItemImagePicker(image: _image, onPickImage: _pickImage),
                  const SizedBox(height: 24),

                  // 🎨 Color
                  Text("Main Color".toUpperCase(), style: _sectionHeaderStyle),
                  const SizedBox(height: 12),
                  AddItemColorPicker(
                    selectedColor: selectedColor,
                    onColorSelected: (color) => setState(() => selectedColor = color),
                  ),
                  const SizedBox(height: 24),

                  // 👕 Category
                  Text("Classification".toUpperCase(), style: _sectionHeaderStyle),
                  const SizedBox(height: 14),
                  AddItemChipsSelection.buildCategoryChips(
                    selectedCategory: selectedCategory,
                    onSelected: (cat) => setState(() => selectedCategory = cat),
                  ),
                  const SizedBox(height: 24),

                  // ☀️ Season
                  Text("Season (Max 2)".toUpperCase(), style: _sectionHeaderStyle),
                  const SizedBox(height: 12),
                  AddItemChipsSelection.buildMultiSelectChips<ClothingSeason>(
                    items: ClothingSeason.values,
                    selectedItems: selectedSeasons,
                    onSelectionChanged: (season, selected) {
                      setState(() {
                        if (selected && selectedSeasons.length < 2) {
                          selectedSeasons.add(season);
                        } else if (!selected) {
                          selectedSeasons.remove(season);
                        } else {
                          _showMessage("You can only select up to 2 seasons", color: Colors.orange);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // 👔 Style
                  Text("Occasion (Max 2)".toUpperCase(), style: _sectionHeaderStyle),
                  const SizedBox(height: 12),
                  AddItemChipsSelection.buildMultiSelectChips<ClothingStyle>(
                    items: ClothingStyle.values,
                    selectedItems: selectedStyles,
                    onSelectionChanged: (style, selected) {
                      setState(() {
                        if (selected && selectedStyles.length < 2) {
                          selectedStyles.add(style);
                        } else if (!selected) {
                          selectedStyles.remove(style);
                        } else {
                          _showMessage("You can only select up to 2 styles", color: Colors.orange);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 36),

                  // 💾 Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AddItemLoading ? null : () => _saveItem(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: state is AddItemLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('ADD TO WARDROBE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}