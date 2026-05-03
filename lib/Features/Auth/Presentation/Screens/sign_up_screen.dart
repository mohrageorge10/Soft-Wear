import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Core/Shared%20Pref/cache_helper.dart';
import 'package:soft_wear/Core/Utils/app_validators.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/city_drop_down_button.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/create_account_text.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/custom_text_field.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/gps_button.dart'; // تأكدي من مسار زرار الـ GPS
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/login_sign_up_button.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/login_sign_up_question.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/logo_image.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/sign_up_sub_title_text.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';

import 'sign_up_mixin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// هنا السحر: ضفنا "with SignUpMixin" عشان الشاشة تقرأ كل حاجة من الملف الخارجي
class _SignUpScreenState extends State<SignUpScreen> with SignUpMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (!useGps && selectedCity != null) {
            CacheHelper.saveData(key: 'userCity', value: selectedCity);
          } else {
            CacheHelper.removeData(key: 'userCity');
          }
          Navigator.of(context).pushReplacementNamed(AppRoutes.authWrapper);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: formKey, // مقروءة من الـ Mixin مباشرة
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LogoImage(height: 100, radius: 53),
                      const SizedBox(height: 20),
                      const CreateAccountText(),
                      const SizedBox(height: 8),
                      const SignUpSubTitleText(),
                      const SizedBox(height: 32),

                      CustomTextField(
                        controller: nameController,
                        labelText: AppStrings.name,
                        hintText: AppStrings.enterName,
                        prefixIcon: Icons.person_outline,
                        validator: AppValidators.validateName,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: emailController,
                        labelText: AppStrings.email,
                        hintText: AppStrings.emailExample,
                        prefixIcon: Icons.email_outlined,
                        validator: AppValidators.validateEmail,
                      ),
                      const SizedBox(height: 16),

                      CityDropDownButton(
                        cities: cities,
                        selectedCity: selectedCity,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCity = newValue;
                            useGps = false;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      Row(
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
                      ),
                      const SizedBox(height: 12),

                      GpsButton(
                        useGps: useGps,
                        onPressed: () async {
                          await requestGpsPermission();
                        },
                        selectedCity: selectedCity,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: passwordController,
                        labelText: AppStrings.pass,
                        hintText: AppStrings.strongPass,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: AppValidators.validatePassword,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: confirmPasswordController,
                        labelText: AppStrings.passConfirm,
                        hintText: AppStrings.reEnterPass,
                        prefixIcon: Icons.lock_reset_outlined,
                        isPassword: true,
                        validator: (value) =>
                            AppValidators.validateConfirmPassword(
                              value,
                              passwordController.text,
                            ),
                      ),
                      const SizedBox(height: 32),

                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : LoginSignUpButton(
                              page: AppStrings.signUp,
                              onPressed: signUp,
                            ),
                      const SizedBox(height: 24),

                      const LoginSignUpQuestion(
                        navPage: AppRoutes.loginScreen,
                        question: AppStrings.loginQuestion,
                        page: AppStrings.login,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
