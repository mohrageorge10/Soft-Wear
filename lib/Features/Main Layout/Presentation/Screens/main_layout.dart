import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_icons.dart';
import 'package:soft_wear/Features/Add_Item/Presentation/Screens/add_item.dart';
import 'package:soft_wear/Features/Add_Item/Presentation/cubit/add_item_cubit.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/home_screen.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/Screens/Widgets/nav_icon.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/cubit/layout_cubit.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/wardrobe_screen.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          extendBody: true,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: _buildScreen(context, state.bottomNavIndex),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: state.bottomNavIndex,
            height: 65.0,
            backgroundColor: Colors.transparent,
            color: AppColors.secondaryColor.withValues(alpha: 0.3),
            buttonBackgroundColor: AppColors.primaryButton,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 400),
            onTap: (index) =>
                context.read<LayoutCubit>().changeBottomNav(index),
            items: [
              NavIcon(
                icon: AppIcons.home,
                isSelected: state.bottomNavIndex == 0,
              ),
              NavIcon(
                icon: AppIcons.add,
                isSelected: state.bottomNavIndex == 1,
              ),
              NavIcon(
                icon: AppIcons.wardrobe,
                isSelected: state.bottomNavIndex == 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const HomeScreen(key: ValueKey('home'));
      case 1:
        return BlocProvider(
          key: UniqueKey(),
          create: (_) => AddItemCubit(),
          child: const AddItemScreen(),
        );
      case 2:
        return BlocProvider(
          key: const ValueKey('wardrobe'),
          create: (_) => WardrobeCubit(WardrobeRepo())..fetchWardrobe(),
          child: const WardrobeScreen(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

