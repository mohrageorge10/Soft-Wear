
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<String> chips;
  final Color chipColor;
  final Color labelColor;

  const InfoCard({required this.title, required this.chips, required this.chipColor, required this.labelColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.boxShadow()],
        border: Border.all(color: AppColors.borderColor),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.titleColor)),
          const SizedBox(height: 10),
          Wrap(
            direction: Axis.vertical,
            spacing: 10,
            children: chips.map((label) => Chip(
              label: Text(label), backgroundColor: chipColor,
              labelStyle: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 12),
              side: BorderSide.none,
            )).toList(),
          ),
        ],
      ),
    );
  }
}