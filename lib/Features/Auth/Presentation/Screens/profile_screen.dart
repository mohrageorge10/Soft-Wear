import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/profile_header.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/profile_recently_added.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/profile_states.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/profile_style_insights.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // جلب بيانات المستخدم وخزينة الملابس عند فتح الشاشة
    context.read<AuthCubit>().getUserData();
    context.read<WardrobeCubit>().fetchWardrobe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.titleColor),
        title: const Text(
          AppStrings.profile,
          style: TextStyle(
            color: AppColors.titleColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الجزء الخاص ببيانات المستخدم العلوية (الصورة، الاسم، المدينة)[cite: 12]
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final authCubit = context.read<AuthCubit>();
                final user = authCubit.currentUserModel;

                return ProfileHeaderWidget(
                  userName: user?.name ?? "Loading...",
                  userEmail: user?.email ?? "Loading...",
                  userCity: user?.city ?? "Loading...",
                );
              },
            ),

            const SizedBox(height: 35),

            // الجزء الخاص بإحصائيات الدولاب والمفضلة[cite: 6, 12]
            BlocBuilder<WardrobeCubit, WardrobeState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ويدجت المربعات (Wardrobe, Favorites, etc.)[cite: 6]
                    const ProfileStates(), 

                    const SizedBox(height: 40),

                    // عرض التحليلات والقطع المضافة مؤخراً فقط عند اكتمال التحميل[cite: 12]
                    if (state is WardrobeLoaded) ...[
                      const ProfileStyleInsights(),
                      const SizedBox(height: 40),
                      const RecentlyAdded(),
                      const SizedBox(height: 40),
                    ] else if (state is WardrobeLoading || state is WardrobeInitial) ...[
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}