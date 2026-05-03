import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class ProfileStateCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;
  final String? routeName; // 🚀 خليناه اختياري
  final VoidCallback? onTapAction; // 🚀 ضفنا الأكشن المخصص ده
  final bool isLoading; 

  const ProfileStateCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    this.routeName, // 🚀 مبقاش required
    this.onTapAction, // 🚀 الاختراع بتاعنا
    this.isLoading = false, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 🚀 لو باعتين أكشن مخصص هينفذه، لو مش باعتين هيفتح الـ routeName العادي
      onTap: onTapAction ?? () {
        if (routeName != null) {
          Navigator.pushNamed(context, routeName!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, color.withValues(alpha: 0.03)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isLoading)
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 3,
                    ),
                  )
                else
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.subtitleColor,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}