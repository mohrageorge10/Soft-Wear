import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text("ABOUT SOFT WEAR")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100), // لو عندك لوجو
              const SizedBox(height: 20),
              const Text("Soft Wear", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.titleColor)),
              const Text("Version 1.0.0", style: TextStyle(color: AppColors.subtitleColor)),
              const SizedBox(height: 30),
              const Text(
                "Soft Wear is your AI-powered digital closet that helps you organize your wardrobe, get weather-based outfit suggestions, and style your looks effortlessly.",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.5, color: AppColors.titleColor),
              ),
              const Spacer(),
              const Text("Made with ❤️ for Fashion Tech", style: TextStyle(fontSize: 12, color: AppColors.subtitleColor)),
            ],
          ),
        ),
      ),
    );
  }
}