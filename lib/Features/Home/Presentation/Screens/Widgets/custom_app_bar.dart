import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/user_avatar_widget.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/cubit/layout_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        AppStrings.appName,
        style: TextStyle(
          color: AppColors.titleColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.secondaryColor.withValues(alpha: 0.2),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.titleColor),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final authCubit = context.read<AuthCubit>();

              final result = await Navigator.pushNamed(
                context,
                AppRoutes.profileScreen,
                arguments: authCubit,
              );
              if (result == 2) {
                context.read<LayoutCubit>().changeBottomNav(2);
              }
              authCubit.getUserData();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final authCubit = context.read<AuthCubit>();
                  final user = authCubit.currentUserModel;

                  // 🚀 ValueKey هو السر لضمان تحديث الصورة فوراً في الـ AppBar
                  return UserAvatarWidget(
                    key: ValueKey(user?.profilePic ?? 'default_avatar'),
                    radius: 18,
                    borderWidth: 1.5,
                    profilePicUrl: user?.profilePic,
                    pickedImage: authCubit.pickedProfileImage,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
