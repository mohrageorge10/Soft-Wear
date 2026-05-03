
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';

class SignUpSubTitleText extends StatelessWidget {
  const SignUpSubTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      AppStrings.signUpSubTitle,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: AppColors.subtitleColor),
    );
  }
}
