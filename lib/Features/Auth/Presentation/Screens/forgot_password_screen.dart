import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Utils/app_validators.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/custom_text_field.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void resetPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context).resetPasswordFunction(
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.titleColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppStrings.resetLinkSent),
                    backgroundColor: AppColors.successColor, 
                  ),
                );
                Navigator.pop(context); // نرجعه للوجين بعد ما اللينك يتبعت
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.lock_reset_rounded,
                        size: 80,
                        color: AppColors.secondaryColor,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        AppStrings.resetPasswordTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        AppStrings.resetPasswordSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: AppColors.subtitleColor),
                      ),
                      const SizedBox(height: 40),

                      // Email
                      CustomTextField(
                        controller: _emailController,
                        labelText: AppStrings.email, 
                        hintText: AppStrings.emailHintForgot,
                        prefixIcon: Icons.email_outlined,
                        validator: AppValidators.validateEmail,
                      ),
                      const SizedBox(height: 32),

                      // Send Link Button
                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () => resetPassword(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryButton,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                AppStrings.sendResetLink,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.buttonText,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}