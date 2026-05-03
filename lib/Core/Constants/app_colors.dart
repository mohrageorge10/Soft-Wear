import 'package:flutter/material.dart';

class AppColors {
  // ================= Primary & Brand =================
  static const Color primaryColor = Color(0xFF8C6246);
  static const Color secondaryColor = Color(0xFFCD9E7F);

  // ================= Backgrounds & Surfaces =================
  static const Color backgroundColor = Color(0xFFF6F5F1);
  static const Color textFieldFill = Color(0xFFEBE7DF);
  static const Color cardShadow = Color(0x1A5C4633);
  static const Color dividerColor = Color(0xFFE8E3D9);
  static const Color borderColor = Color(0xFFD9D3C7);
  static const Color transparent = Colors.transparent;

  // ================= Typography =================
  static const Color titleColor = Color(0xFF5C4633);
  static const Color subtitleColor = Color(0xFF8E7B68);
  static const Color hintText = Color(0xFFA69B8D);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color disabledText = Color(0xFFA8A196);

  // ================= Actions & Icons =================
  static const Color primaryButton = Color(0xFF8C6246);
  static const Color disabledButton = Color(0xFFD6D0C4);
  static const Color iconUnselected = Color(0xFFBDAEA1);
  static const Color favColor = Color.fromARGB(255, 189, 53, 35);

  // ================= Status & Validation =================
  static const Color errorColor = Color(0xFFB85C50);
  static const Color successColor = Color(0xFF6B8E6B);

  // ================= Charts & Analytics =================
  static const Color chartMustard = Color(0xFFD4AA63);
  static const Color chartSage = Color(0xFF828C74);
  static const Color chartBrick = Color(0xFFC27A65);
  static const Color chartGrey = Color(0xFFA69B8F);

  // ================= Color Helper Function =================
  static Map<String, Color> clothingColors = {
    // ⚪️ الألوان المحايدة
    'White': Colors.white,
    'Silver': const Color(0xFFC0C0C0),
    'Gray': Colors.grey,
    'Charcoal': const Color(0xFF36454F),
    'Black': Colors.black,

    // 🟤 درجات البيج والبني
    'Cream': const Color(0xFFF5F5DC),
    'Beige': const Color(0xFFE8DCC4),
    'Khaki': const Color(0xFFF0E68C),
    'Camel': const Color(0xFFC19A6B),
    'Brown': Colors.brown,

    // 🟡 درجات الأصفر والذهبي
    'Yellow': Colors.yellow,
    'Mustard': const Color(0xFFE1AD01),
    'Gold': const Color.fromARGB(255, 204, 174, 3),

    // 🟠 درجات البرتقالي والخوخي
    'Peach': const Color(0xFFFFE5B4),
    'Orange': Colors.orange,
    'Coral': const Color(0xFFFF7F50),
    'Terracotta': const Color(0xFFE2725B),
    'Rust': const Color(0xFFB7410E),

    // 🔴 درجات الأحمر والبينك
    'Pink': Colors.pink,
    'Red': Colors.red,
    'Burgundy': const Color(0xFF800020),

    // 🟣 درجات البنفسجي
    'Lilac': const Color(0xFFC8A2C8),
    'Purple': Colors.purple,

    // 🔵 درجات الأزرق
    'Turquoise': const Color(0xFF40E0D0),
    'Denim': const Color(0xFF1E90FF),
    'Blue': Colors.blue,
    'Navy': const Color(0xFF000080),

    // 🟢 درجات الأخضر
    'Mint Green': const Color(0xFF98FF98),
    'Teal': Colors.teal,
    'Green': Colors.green,
    'Olive': const Color(0xFF556B2F),
  };

  static Color getColorFromName(String colorName) {
    return clothingColors[colorName] ?? Colors.grey;
  }

  static BoxShadow boxShadow() {
    return BoxShadow(
      color: AppColors.titleColor.withValues(alpha: 0.5),
      blurRadius: 5,
      offset: const Offset(-3, 8),
    );
  }
}
