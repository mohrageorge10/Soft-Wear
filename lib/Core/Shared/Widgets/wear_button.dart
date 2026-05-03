
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';

class WearButton extends StatelessWidget {
  const WearButton({
    super.key,
    required this.isActionLoading,
    required this.cubit,
  });

  final bool isActionLoading;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: isActionLoading ? null : () => cubit.wearOutfit(),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isActionLoading ? Colors.grey.shade400 : AppColors.primaryButton,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: isActionLoading ? 0 : 5,
          shadowColor: AppColors.titleColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("WEAR OUTFIT",
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            SizedBox(width: 8),
            Icon(Icons.check_circle_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}