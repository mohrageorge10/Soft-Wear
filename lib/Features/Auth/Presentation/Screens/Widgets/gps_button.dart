import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class GpsButton extends StatelessWidget {
  const GpsButton({super.key, required this.useGps, required this.selectedCity, required this.onPressed});
  final bool useGps;
  final String? selectedCity;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
                        onPressed: onPressed,
                        icon: Icon(
                          useGps
                              ? Icons.check_circle
                              : Icons.my_location_rounded,
                          color: useGps
                              ? Colors.green
                              : AppColors.chartMustard,
                        ),
                        label: Text(
                          useGps ? "GPS Selected" : "Detect Location (GPS)",
                          style: TextStyle(
                            color: useGps
                                ? Colors.green
                                : AppColors.chartMustard,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: useGps
                                ? Colors.green
                                : AppColors.chartMustard,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      );
  }
}