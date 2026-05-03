import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_images.dart';
import 'package:soft_wear/Core/Constants/app_constants.dart'; 
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Core/Shared%20Pref/cache_helper.dart';
import 'package:soft_wear/Core/Shared/Widgets/custom_loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAppLogic();
    });
  }

  Future<void> _startAppLogic() async {
    print("⏳ Splash: Timer started for ${AppConstants.splashDelay} seconds...");
    await Future.delayed(const Duration(seconds: AppConstants.splashDelay));
    print("⏰ Splash: Timer finished!");

    if (!mounted) {
      print("❌ Splash: Screen is no longer mounted.");
      return;
    }

    try {
      print("🔍 Splash: Checking Onboarding status...");
      bool hasSeenOnboarding = CacheHelper.getData(key: AppConstants.prefsSeenOnboarding) ?? false;
      print("📊 Splash: hasSeenOnboarding = $hasSeenOnboarding");

      if (!hasSeenOnboarding) {
        print("➡️ Splash: Navigating to OnboardingScreen...");
        Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
        return;
      }

      print("🔍 Splash: Checking Firebase User...");
      final user = FirebaseAuth.instance.currentUser;
      print("👤 Splash: Current user is ${user?.email ?? 'NULL (Not logged in)'}");

      if (user != null) {
        print("➡️ Splash: Navigating to MainLayoutScreen...");
        Navigator.pushReplacementNamed(context, AppRoutes.mainLayoutScreen);
      } else {
        print("➡️ Splash: Navigating to LoginScreen...");
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }
    } catch (e, stacktrace) {
      print("❌ ERROR IN SPLASH LOGIC: $e");
      print(stacktrace);
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.imagesSoftWearLogo, width: 220),
            const SizedBox(height: 30),
            const CustomLoadingIndicator(size: 40, strokeWidth: 3), 
          ],
        ),
      ),
    );
  }
}