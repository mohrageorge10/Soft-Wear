import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/section_title.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/weather_card.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/weather_styled_ootd_card.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';

// 🚀 استدعاء الملفات الجديدة
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/occasion_bottom_sheet.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/outfit_action_buttons.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.cubit, required this.state});

  final HomeCubit cubit;
  final HomeState state;

  // 🚀 الدالة بقت سطرين بس بفضل الـ Widget المفصولة
  void _showOccasionBottomSheet(BuildContext context, HomeCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => OccasionBottomSheet(cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasOutfit = cubit.currentOutfit != null;
    bool isFirstLoading = state is HomeOutfitLoading && !hasOutfit;
    bool isActionLoading = state is HomeOutfitLoading || state is HomeOutfitActionLoading;

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeOutfitSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Outfit saved! 🗂️'), backgroundColor: AppColors.successColor),
          );
        } else if (state is HomeOutfitFavorited) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to Favorites 💖'), backgroundColor: AppColors.successColor),
          );
        } else if (state is HomeOutfitWorn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Awesome choice! Outfit logged. 👗✨'), backgroundColor: AppColors.successColor),
          );
        } else if (state is HomeOutfitActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.errorColor),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeatherCard(cubit: cubit, state: state),
          const SizedBox(height: 40),

          // 🚀 زرار الـ Generate الرئيسي
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showOccasionBottomSheet(context, cubit),
              icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
              label: const Text(
                "GENERATE OUTFIT",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 7,
                shadowColor: AppColors.titleColor.withValues(alpha: 0.6),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 🚀 الحالات المختلفة لعرض الطقم
          if (isFirstLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            )
          else if (hasOutfit) ...[
            SectionTitle(title: AppStrings.ootdTitle),
            const SizedBox(height: 20),
            
            WeatherStyledOOTDCard(state: state, cubit: cubit),
            const SizedBox(height: 24),

            // 🚀 استخدام الـ Widget المفصولة لزراير الأكشن
            OutfitActionButtons(
              cubit: cubit,
              state: state,
              isActionLoading: isActionLoading,
            ),
            
            const SizedBox(height: 30),
          ] else ...[
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.auto_awesome_rounded, size: 50, color: AppColors.subtitleColor.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  const Text("Tap Generate to see your outfit!", textAlign: TextAlign.center, style: TextStyle(color: AppColors.subtitleColor, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ],
      ),
    );
  }
}