import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/custom_app_bar.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/custom_drawer.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/home_body.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/wardrobe_warning_dialog.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/missing_item_dialog.dart';

// 🚀 1. استدعاء الـ LayoutCubit عشان نقدر نتحكم في التابات
import 'package:soft_wear/Features/Main%20Layout/Presentation/cubit/layout_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeOutfitGenerated && state.showNotification) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.style} outfit is ready!'),
              backgroundColor: AppColors.primaryButton,
            ),
          );
        } else if (state is HomeWardrobeEmpty) {
          // 🚀 2. تمرير دالة تغيير التاب للديالوج
          showDialog(
            context: context,
            builder: (_) => WardrobeWarningDialog(
              title: AppStrings.emptyWardrobe,
              message: AppStrings.emptyWardrobeMSG,
              onAddPressed: () {
                context.read<LayoutCubit>().changeBottomNav(1); // 💡 تغيير التاب لصفحة الإضافة
              },
            ),
          );
        } else if (state is HomeInsufficientItems) {
          // 🚀 3. تمرير دالة تغيير التاب للديالوج التاني
          showDialog(
            context: context,
            builder: (_) => WardrobeWarningDialog(
              title: 'Not enough items',
              message: 'You don\'t have enough ${state.style.toLowerCase()} items. Add more tops, bottoms, or shoes!',
              onAddPressed: () {
                context.read<LayoutCubit>().changeBottomNav(1); // 💡 تغيير التاب لصفحة الإضافة
              },
            ),
          );
        } else if (state is HomeWardrobeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is HomeOutfitRequiresConsent) {
          final myCubit = context.read<HomeCubit>();
          showDialog(
            context: context,
            builder: (_) => MissingItemDialog(
              missingItem: state.missingItem,
              onGeneratePressed: () {
                myCubit.generateOutfit(state.style, forceFallback: true);
              },
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: const CustomAppBar(),
          drawer: const CustomDrawer(),
          body: RefreshIndicator(
            onRefresh: () async => await cubit.fetchWeather(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: HomeBody(cubit: cubit, state: state),
            ),
          ),
        );
      },
    );
  }
}