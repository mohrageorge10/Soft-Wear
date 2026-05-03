import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Core/Utils/app_validators.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/custom_text_field.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/forget_password_text.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/login_sign_up_button.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/login_sign_up_question.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/login_sub_title_text.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/login_welcome_text.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/logo_image.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context).loginFunction(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacementNamed(context, AppRoutes.authWrapper); 
              } 
              else if (state is AuthError) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Logo
                      const LogoImage(height: 150, radius: 78),
                      const SizedBox(height: 24),
                      //Welcome
                      const LoginWelcomeText(),
                      const SizedBox(height: 8),
                      //Sub title
                      const loginSubTitleText(),
                      const SizedBox(height: 40),

                      // Email Text Field
                      CustomTextField(
                        controller: _emailController,
                        labelText: AppStrings.email,
                        hintText: AppStrings.emailExample,
                        prefixIcon: Icons.email_outlined,
                        validator: AppValidators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      // Password Text Field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: AppStrings.pass,
                        hintText: AppStrings.passHint,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: AppValidators.validatePassword,
                      ),
                      const SizedBox(height: 8),
                      // Forget Password
                      const ForgetPasswordText(),
                      const SizedBox(height: 32),

                      // Login Button
                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : LoginSignUpButton(
                              page: AppStrings.login,
                              onPressed: () => login(context),
                            ),
                      const SizedBox(height: 24),

                      // Don't have an account
                      const LoginSignUpQuestion(
                        navPage: AppRoutes.signUpScreen,
                        question: AppStrings.signUpQuestion,
                        page: AppStrings.signUp,
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