import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Presentation/onboarding_screen.dart';
import 'package:soft_wear/Core/Shared%20Pref/cache_helper.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/login_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/Screens/main_layout.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';
import 'package:soft_wear/Features/Home/Data/Repo/weather_repo.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';
import 'package:soft_wear/Features/Add_Item/Presentation/cubit/add_item_cubit.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/cubit/layout_cubit.dart';

class AuthWrapperScreen extends StatelessWidget {
  const AuthWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          
          // 1. لو اليوزر مسجل دخول بالفعل
          if (snapshot.hasData) {
            // ✅ حلينا مشكلة الـ Providers هنا عشان التطبيق ميفصلش
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => LayoutCubit()),
                BlocProvider(create: (context) => HomeCubit(WeatherRepository(), WardrobeRepo())..fetchWeather()),
                BlocProvider(create: (context) => WardrobeCubit(WardrobeRepo())..fetchWardrobe()),
                BlocProvider(create: (context) => AddItemCubit()),
              ],
              child:  MainLayoutScreen(),
            );
          } 
          
          // 2. لو مش مسجل دخول (بنشيك على الأونبوردينج)
          else {
            // 💡 قراءة لحظية من الميموري باستخدام CacheHelper من غير أي FutureBuilder!
            final bool hasSeenOnboarding = CacheHelper.getData(key: 'seenOnboarding') ?? false;

            if (hasSeenOnboarding) {
              // لو شاف الأونبوردينج قبل كده -> وديه للوجين
              return BlocProvider(
                create: (context) => AuthCubit(),
                child: const LoginScreen(),
              );
            } else {
              // لو أول مرة يفتح التطبيق -> وديه للأونبوردينج
              return const OnboardingScreen();
            }
          }
          
        },
      ),
    );
  }
}