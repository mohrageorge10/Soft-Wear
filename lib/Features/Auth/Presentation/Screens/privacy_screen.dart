import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text("PRIVACY & SECURITY")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.shield_outlined, size: 80, color: AppColors.primaryColor),
            const SizedBox(height: 20),
            _buildPrivacyItem("Data Encryption", "Your wardrobe photos and personal data are encrypted and stored securely on Google Cloud and Cloudinary."),
            _buildPrivacyItem("Account Protection", "We use Firebase Auth to ensure that only you can access your private digital closet."),
            _buildPrivacyItem("Third-Party Sharing", "Soft Wear does not sell or share your personal fashion data with any third-party advertisers."),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyItem(String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }
}