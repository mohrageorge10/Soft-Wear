
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';

class LoginWelcomeText extends StatelessWidget {
  const LoginWelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      AppStrings.loginWelcome,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.titleColor,
      ),
    );
  }
}
