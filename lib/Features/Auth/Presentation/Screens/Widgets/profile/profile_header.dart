import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/user_avatar_widget.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userCity;

  const ProfileHeaderWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userCity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_note_rounded,
                  size: 28,
                  color: AppColors.subtitleColor,
                ),
                onPressed: () async {
                  final authCubit = context.read<AuthCubit>();

                  // 1. نفتح شاشة التعديل ونستنى النتيجة
                  final updated = await Navigator.pushNamed(
                    context,
                    AppRoutes.editProfileScreen,
                    arguments: authCubit,
                  );

                  // 2. 🚀 لو حصل تعديل، نطلب تحديث البيانات فوراً وأحنا في نفس الشاشة
                  if (updated == true) {
                    authCubit
                        .getUserData(); // دي هتخلي الـ BlocBuilder في البروفايل والـ AppBar يتحدثوا
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_rounded,
                  size: 26,
                  color: AppColors.subtitleColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.settingsScreen,
                    arguments: context.read<AuthCubit>(),
                  );
                },
              ),
            ],
          ),
          Column(
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final authCubit = context.read<AuthCubit>();
                  return UserAvatarWidget(
                    radius: 50,
                    borderWidth: 3.0,
                    pickedImage: authCubit.pickedProfileImage,
                    profilePicUrl: authCubit.currentUserModel?.profilePic,
                  );
                },
              ),
              const SizedBox(height: 15),
              Text(
                userName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleColor,
                ),
              ),
              Text(
                userEmail,
                style: const TextStyle(
                  color: AppColors.subtitleColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    userCity,
                    style: const TextStyle(
                      color: AppColors.subtitleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
