
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class LoginSignUpButton extends StatelessWidget {
  final String page;
  final VoidCallback onPressed; 

  const LoginSignUpButton({
    super.key,
    required this.page,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 115),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        page,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.buttonText,
        ),
      ),
    );
  }
}