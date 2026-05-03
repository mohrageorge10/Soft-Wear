

import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';

class loginSubTitleText extends StatelessWidget {
  const loginSubTitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      AppStrings.loginSubTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.subtitleColor,
      ),
    );
  }
}
