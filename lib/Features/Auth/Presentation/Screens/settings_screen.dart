import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationsEnabled = true;

  // دالة تسجيل الخروج
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.errorColor),
            SizedBox(width: 10),
            Text("Log Out", style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "Are you sure you want to log out of your account?",
          style: TextStyle(color: AppColors.subtitleColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: AppColors.subtitleColor, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AuthCubit>().logOut(); // تفريغ البيانات والخرج
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  AppRoutes.loginScreen, 
                  (route) => false,
                );
              }
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.titleColor),
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            color: AppColors.titleColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password reset email sent! Check your inbox."), backgroundColor: AppColors.primaryColor),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Account"),
              _buildSettingTile(
                icon: Icons.lock_outline_rounded,
                title: "Change Password",
                onTap: () {
                  // تفعيل إرسال إيميل إعادة تعيين كلمة المرور
                  final email = context.read<AuthCubit>().currentUserModel?.email;
                  if (email != null) {
                    context.read<AuthCubit>().resetPasswordFunction(email: email);
                  }
                },
              ),
              _buildSettingTile(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy & Security",
                onTap: ()=> Navigator.pushNamed(context, AppRoutes.privacyScreen),
              ),
              const SizedBox(height: 20),

              _buildSectionHeader("About"),
              _buildSettingTile(
                icon: Icons.info_outline_rounded, 
                title: "About Soft Wear", 
                onTap: ()=> Navigator.pushNamed(context, AppRoutes.aboutScreen),
              ),
              const SizedBox(height: 30),

              _buildSettingTile(
                icon: Icons.logout_rounded,
                title: "Log Out",
                titleColor: AppColors.errorColor,
                iconColor: AppColors.errorColor,
                hideArrow: true,
                onTap: () => _showLogoutDialog(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.subtitleColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
    bool hideArrow = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.textFieldFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primaryColor).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor ?? AppColors.titleColor,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        trailing: trailing ?? (hideArrow ? null : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.subtitleColor)),
      ),
    );
  }
}