import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';

class CityDropDownButton extends StatelessWidget {
  final List<String> cities;
  final String? selectedCity;
  final void Function(String?) onChanged; 

  const CityDropDownButton({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedCity, 
      hint: const Text(
        AppStrings.selectCity,
        style: TextStyle(color: AppColors.hintText),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.primaryButton,
      ),
      dropdownColor: AppColors.backgroundColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.location_city_outlined,
          color: AppColors.primaryButton,
        ),
        filled: true,
        fillColor: AppColors.textFieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.secondaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
        ),
      ),
      items: cities.map((String city) {
        return DropdownMenuItem<String>(
          value: city, 
          child: Text(
            city,
            style: const TextStyle(color: AppColors.titleColor),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}