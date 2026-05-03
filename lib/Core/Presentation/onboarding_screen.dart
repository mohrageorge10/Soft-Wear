import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_constants.dart';
import 'package:soft_wear/Core/Constants/app_images.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Presentation/widgets/build_indicator.dart';
import 'package:soft_wear/Core/Presentation/widgets/on_boarding_page.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Core/Shared%20Pref/cache_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    await CacheHelper.saveData(
      key: AppConstants.prefsSeenOnboarding,
      value: true,
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              OnBoardingPage(
                image: Assets.imagesOnBoarding1,
                title: AppStrings.onBoardingTitle1,
                description: AppStrings.onBoardingSub1,
              ),
              OnBoardingPage(
                image: Assets.imagesOnBoarding2,
                title: AppStrings.onBoardingTitle2,
                description: AppStrings.onBoardingSub2,
              ),
              OnBoardingPage(
                image: Assets.imagesOnBoarding3,
                title: AppStrings.onBoardingTitle3,
                description: AppStrings.onBoardingSub3,
              ),
            ],
          ),

          // 2. Animated Indicator
          Positioned(
            bottom: 180,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) =>
                    BuildIndicator(currentPage: _currentPage, index: index),
              ),
            ),
          ),

          // 3. Button
          Container(
            alignment: const Alignment(0, 0.88),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                foregroundColor: Colors.white,
                minimumSize: const Size(260, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              onPressed: () {
                if (_currentPage < 2) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _completeOnboarding();
                }
              },
              child: Text(
                _currentPage == 2 ? AppStrings.startStyling : AppStrings.next,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
