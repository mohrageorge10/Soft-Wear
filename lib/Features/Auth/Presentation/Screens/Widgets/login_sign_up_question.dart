import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class LoginSignUpQuestion extends StatelessWidget {
  const LoginSignUpQuestion({super.key, required this.navPage, required this.question, required this.page});
  final String navPage;
  final String question;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          question,
          style: TextStyle(color: AppColors.subtitleColor),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, navPage);
          },
          child:  Text(
            page,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
