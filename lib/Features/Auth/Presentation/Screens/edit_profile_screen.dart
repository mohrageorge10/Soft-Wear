import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/Widgets/profile/edit_profile_text_field.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController cityController;
  late TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().currentUserModel;
    nameController = TextEditingController(text: user?.name ?? '');
    cityController = TextEditingController(text: user?.city ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    emailController.dispose();
    super.dispose();
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
          "EDIT PROFILE",
          style: TextStyle(
            color: AppColors.titleColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully! ✨'),
                backgroundColor: AppColors.successColor,
              ),
            );
            Navigator.pop(context, true); 
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          final authCubit = context.read<AuthCubit>();
          final user = authCubit.currentUserModel;
          final pickedImage = authCubit.pickedProfileImage;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.primaryButton,
                            backgroundImage: pickedImage != null
                                ? FileImage(File(pickedImage.path))
                                : (user?.profilePic != null &&
                                          user!.profilePic!.isNotEmpty
                                      ? NetworkImage(user.profilePic!)
                                            as ImageProvider
                                      : null),
                            child:
                                (pickedImage == null &&
                                    (user?.profilePic == null ||
                                        user!.profilePic!.isEmpty))
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              context.read<AuthCubit>().pickProfileImage(
                                ImageSource.gallery,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryButton,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  EditProfileTextField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person_outline_rounded,
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your name" : null,
                    isReadOnly: false,
                  ),
                  const SizedBox(height: 20),

                  EditProfileTextField(
                    controller: cityController,
                    label: "City",
                    icon: Icons.location_city_rounded,
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your city" : null,
                    isReadOnly: false,
                  ),
                  const SizedBox(height: 20),

                  EditProfileTextField(
                    controller: emailController,
                    label: "Email Address",
                    icon: Icons.email_outlined,
                    isReadOnly: true,
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                authCubit.updateUserProfile(
                                  name: nameController.text.trim(),
                                  city: cityController.text.trim(),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "SAVE CHANGES",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
