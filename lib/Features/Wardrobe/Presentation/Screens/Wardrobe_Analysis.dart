import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class WardrobeAnalysisScreen extends StatelessWidget {
  const WardrobeAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WardrobeCubit(WardrobeRepo())..fetchWardrobe(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WARDROBE INSIGHTS'),
          centerTitle: true,
        ),
        body: BlocBuilder<WardrobeCubit, WardrobeState>(
          builder: (context, state) {
            return switch (state) {
              WardrobeLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
              WardrobeError(message: final msg) => Center(
                child: Text(
                  msg,
                  style: const TextStyle(color: AppColors.errorColor),
                ),
              ),
              WardrobeLoaded(items: final items) => _buildBody(items),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildBody(List<ClothingItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: AppColors.subtitleColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add items to see your wardrobe analysis ✨',
              style: TextStyle(
                color: AppColors.subtitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Color Palette',
              subtitle: 'Dominant colors in your closet',
              child: _buildDonutChart(items),
            ),
            const SizedBox(height: 24),
            _buildSectionCard(
              title: 'Category Statistics',
              subtitle: 'Count per clothing type',
              child: _buildBarChart(items),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Donut Chart (Modern Pie Chart) ---
  Widget _buildDonutChart(List<ClothingItem> items) {
    final Map<String, int> colorCounts = {};
    for (var item in items) {
      colorCounts[item.color] = (colorCounts[item.color] ?? 0) + 1;
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 60,
              sections: colorCounts.entries.map((entry) {
                return PieChartSectionData(
                  color: AppColors.getColorFromName(entry.key),
                  value: entry.value.toDouble(),
                  radius: 25,
                  showTitle: false,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: colorCounts.keys
              .map((colorName) => _buildLegendItem(colorName))
              .toList(),
        ),
      ],
    );
  }

  // --- Bar Chart (Professional with Gradients) ---
  Widget _buildBarChart(List<ClothingItem> items) {
    final counts = {
      ClothingCategory.top: 0,
      ClothingCategory.bottom: 0,
      ClothingCategory.dress: 0,
      ClothingCategory.jacket: 0,
      ClothingCategory.shoes: 0,
    };
    for (var item in items) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
    }

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (counts.values.reduce((a, b) => a > b ? a : b) + 2).toDouble(),

          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => AppColors.primaryButton,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.toInt().toString(),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ),

          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const titles = [
                    'Tops',
                    'Bottoms',
                    'Shoes',
                    'Dresses',
                    'Jackets',
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      titles[value.toInt()],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.subtitleColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: List.generate(5, (index) {
            final category = ClothingCategory.values[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: counts[category]!.toDouble(),
                  color: AppColors.primaryColor,
                  width: 22,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY:
                        counts.values
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble() +
                        2,
                    color: AppColors.textFieldFill,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // --- UI Reusable Components ---

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.subtitleColor,
            ),
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }

  Widget _buildLegendItem(String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.getColorFromName(name),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 11, color: AppColors.titleColor),
        ),
      ],
    );
  }
}
