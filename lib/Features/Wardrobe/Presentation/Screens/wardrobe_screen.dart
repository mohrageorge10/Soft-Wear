import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/custom_filter.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

import 'item_details_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen>
    with SingleTickerProviderStateMixin {
  List<String> filterColors = [];
  List<ClothingSeason> filterSeasons = [];
  List<ClothingStyle> filterStyles = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<WardrobeCubit>();

    _tabController = TabController(
      length: ClothingCategory.values.length,
      vsync: this,
      initialIndex: cubit.currentTabIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        cubit.currentTabIndex = _tabController.index;
      }
    });

    cubit.fetchWardrobe();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showFilterBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomFilter(
          filterColors: filterColors,
          filterSeasons: filterSeasons,
          filterStyles: filterStyles,
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        filterColors = result['colors'] as List<String>;
        filterSeasons = result['seasons'] as List<ClothingSeason>;
        filterStyles = result['styles'] as List<ClothingStyle>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppStrings.myWardrobe,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list_rounded),
                if (filterColors.isNotEmpty ||
                    filterSeasons.isNotEmpty ||
                    filterStyles.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterBottomSheet,
          ),
          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController, // 🚀 5. باصينا الكونترولر هنا
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          tabs: ClothingCategory.values
              .map((cat) => Tab(text: cat.name.toUpperCase()))
              .toList(),
        ),
      ),
      // 🚀 6. استخدمنا BlocConsumer عشان نتصنت على أمر تغيير التاب
      body: BlocConsumer<WardrobeCubit, WardrobeState>(
        listener: (context, state) {
          // السحر هنا: لو شاشة الإضافة غيرت الرقم في الكيوبت، التاب هيتحرك فوراً
          final cubitIndex = context.read<WardrobeCubit>().currentTabIndex;
          if (_tabController.index != cubitIndex) {
            _tabController.animateTo(cubitIndex);
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController, // 🚀 7. باصينا الكونترولر هنا كمان
            children: ClothingCategory.values.map((category) {
              if (state is WardrobeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (state is WardrobeError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.errorColor),
                  ),
                );
              } else if (state is WardrobeLoaded) {
                final filteredItems = state.items.where((item) {
                  if (item.category != category) return false;
                  if (filterColors.isNotEmpty &&
                      !filterColors.contains(item.color))
                    return false;
                  if (filterSeasons.isNotEmpty &&
                      !filterSeasons.any((s) => item.matchesSeason(s)))
                    return false;
                  if (filterStyles.isNotEmpty &&
                      !filterStyles.any((s) => item.matchesStyle(s)))
                    return false;
                  return true;
                }).toList();

                return _buildItemsGrid(filteredItems);
              }
              return const SizedBox();
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid(List<ClothingItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: AppColors.subtitleColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "No items found.",
              style: TextStyle(
                color: AppColors.subtitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(ClothingItem item) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(item: item),
          ),
        );

        if (!context.mounted) return;
        context.read<WardrobeCubit>().fetchWardrobe(
          forceRefresh: true,
          showLoader: false,
        ); // 💡 خفينا اللودينج هنا عشان الشاشة مترعش لما نرجع من التفاصيل
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppColors.boxShadow()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Hero(
                  tag: item.id.isNotEmpty ? item.id : item.hashCode.toString(),
                  child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.textFieldFill,
                                child: const Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                      : Container(
                          color: AppColors.textFieldFill,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.getColorFromName(item.color),
                    radius: 8,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.color,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
