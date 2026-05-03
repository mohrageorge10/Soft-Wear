
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class ORdivider extends StatelessWidget {
  const ORdivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.borderColor),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "OR",
            style: TextStyle(
              color: AppColors.hintText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.borderColor),
        ),
      ],
    );
  }
}
