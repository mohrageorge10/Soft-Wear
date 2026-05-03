import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/logo_image.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';
import 'package:soft_wear/Features/Home/Presentation/Screens/Widgets/drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: Column(
        children: [
          // 🆕 Favorite Outfits
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: AppColors.backgroundColor),
            child: LogoImage(height: 100, radius: 53),
          ),
          // 🆕 Favorite Outfits
          DrawerItem(
            icon: Icons.analytics_outlined,
            text: AppStrings.wardrobeAnalysis,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.wardrobeAnalysisScreen),
          ),
          // 🆕 Saved Outfits
          DrawerItem(
            icon: Icons.bookmark_outlined,
            text: AppStrings.savedOutfits,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.savedOutfitsScreen),
          ),
          // 🆕 Favorite Outfits
          DrawerItem(
            icon: Icons.favorite_border_rounded,
            text: AppStrings.favorites,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.favoriteOutfitsScreen),
          ),

          // 🆕 Settings
          DrawerItem(
            icon: Icons.settings_outlined,
            text: AppStrings.settings,
            onTap: () {
              final authCubit = BlocProvider.of<AuthCubit>(context);
              Navigator.pushNamed(
                context,
                AppRoutes.settingsScreen,
                arguments: authCubit,
              );
            },
          ),

          // 🆕 Outfit Canvas
          DrawerItem(
            icon: Icons.auto_awesome_mosaic_outlined,
            color: AppColors.disabledText,
            text: AppStrings.outfitCanvas,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.outfitCanvasScreen),
          ),
        ],
      ),
    );
  }
}
