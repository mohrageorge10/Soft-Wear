
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class FilterLabel extends StatelessWidget {
  const FilterLabel({
    super.key, required this.txt, required this.icon,
  });

  final String txt;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
     children: [
       Icon(
         icon, 
         size: 20,
         color: AppColors.primaryColor,
       ),
       SizedBox(width: 8),
       Text(
         txt,
         style: TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.bold,
           color: AppColors.titleColor,
         ),
       ),
     ],
                      );
  }
}