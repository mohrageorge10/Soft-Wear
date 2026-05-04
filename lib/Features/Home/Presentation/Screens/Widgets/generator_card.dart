import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class GeneratorCard extends StatelessWidget {
  const GeneratorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 140,
          decoration: BoxDecoration(
            color:  AppColors.chartMustard.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryButton, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.titleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
