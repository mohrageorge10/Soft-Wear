
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart'; 

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;
  bool _isSuccess = false; 

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    Color currentBorderColor = _isSuccess
        ? AppColors.successColor
        : AppColors.borderColor;
    Color currentFocusedColor = _isSuccess
        ? AppColors.successColor
        : AppColors.secondaryColor;
    Color currentIconColor = _isSuccess
        ? AppColors.successColor
        : AppColors.primaryButton;

    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      onChanged: (value) {
        if (widget.validator != null) {
          setState(() {
            _isSuccess = widget.validator!(value) == null && value.isNotEmpty;
          });
        }
      },
      validator: (value) {
        if (widget.validator != null) {
          final error = widget.validator!(value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isSuccess =
                    (error == null && value != null && value.isNotEmpty);
              });
            }
          });
          return error;
        }
        return null;
      },
      style: const TextStyle(color: AppColors.titleColor),
      decoration: InputDecoration(
        errorMaxLines: 3,
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: AppColors.titleColor,
          fontWeight: FontWeight.w500,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.hintText),
        prefixIcon: Icon(widget.prefixIcon, color: currentIconColor),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: currentIconColor,
                ),
              )
            : (_isSuccess
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.successColor,
                      size: 20,
                    )
                  : null),

        filled: true,
        fillColor: AppColors.textFieldFill,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: currentBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: currentBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: currentFocusedColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
        ),
        errorStyle: const TextStyle(color: AppColors.errorColor),
      ),
    );
  }
}
