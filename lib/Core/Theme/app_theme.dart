import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soft_wear/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundColor,

      // ================= COLOR SCHEME (الأساس اللي بيبني عليه Material 3) =================
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryColor,
        onPrimary: AppColors.buttonText,
        primaryContainer: AppColors.textFieldFill,
        onPrimaryContainer: AppColors.titleColor,
        secondary: AppColors.secondaryColor,
        onSecondary: AppColors.buttonText,
        secondaryContainer: AppColors.textFieldFill,
        onSecondaryContainer: AppColors.titleColor,
        surface: AppColors.backgroundColor,
        onSurface: AppColors.titleColor,
        surfaceContainerHighest: AppColors.textFieldFill,
        error: AppColors.errorColor,
        onError: AppColors.buttonText,
        outline: AppColors.borderColor,
        outlineVariant: AppColors.dividerColor,
        shadow: AppColors.cardShadow,
        scrim: AppColors.cardShadow,
        inverseSurface: AppColors.titleColor,
        onInverseSurface: AppColors.backgroundColor,
        inversePrimary: AppColors.secondaryColor,
      ),

      // ================= TYPOGRAPHY =================
      textTheme: const TextTheme(
        // Huge text for splash screens or giant metrics
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: AppColors.titleColor,
          letterSpacing: -0.5,
        ),
        // Very large text for major focal points
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.titleColor,
        ),
        // Large text for short, high-emphasis phrases
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.titleColor,
        ),

        // Primary screen headers or large dialog titles
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.titleColor,
          letterSpacing: 0.5,
        ),
        // Secondary headers or major section titles
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.titleColor,
        ),
        // Sub-section titles or prominent card headers
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.titleColor,
        ),

        // Default AppBar title or prominent list item titles
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.titleColor,
          letterSpacing: 0.3,
        ),
        // Medium list item titles or subtle headers
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.titleColor,
        ),
        // Small list item titles or minimal emphasis headers
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.titleColor,
        ),

        // Primary paragraph text or long descriptions
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.titleColor,
          height: 1.5,
        ),
        // Default body text, secondary descriptions (most common)
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.subtitleColor,
          height: 1.5,
        ),
        // Fine print, metadata, or tertiary descriptions
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.subtitleColor,
          height: 1.4,
        ),

        // Primary button text, tabs, or prominent tags
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: AppColors.buttonText,
          letterSpacing: 1.2,
        ),
        // Chips, small buttons, or interactive element labels
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
          letterSpacing: 0.5,
        ),
        // Badges, captions, overline text, or tiny labels
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.subtitleColor,
          letterSpacing: 0.3,
        ),
      ),

      // ================= APP BAR =================
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.titleColor,
        elevation: 0,
        toolbarHeight: 60,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.titleColor,
        ),
        iconTheme: IconThemeData(color: AppColors.titleColor, size: 28),
        actionsIconTheme: IconThemeData(color: AppColors.titleColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // ================= BUTTONS =================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: AppColors.buttonText,
          disabledBackgroundColor: AppColors.disabledButton,
          disabledForegroundColor: AppColors.disabledText,
          elevation: 4,
          shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.buttonVerticalPadding,
            horizontal: 24,
          ),
          minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.buttonVerticalPadding,
            horizontal: 24,
          ),
          minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.titleColor,
          disabledForegroundColor: AppColors.disabledText,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          ),
        ),
      ),

      // ================= INPUTS (TextFields) =================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.textFieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.inputHorizontalPadding,
          vertical: AppDimens.inputVerticalPadding,
        ),
        hintStyle: const TextStyle(
          color: AppColors.hintText,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: AppColors.subtitleColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
        errorStyle: const TextStyle(
          color: AppColors.errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          borderSide: BorderSide.none,
        ), // بدون حواف في العادي
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.disabledButton,
            width: 1,
          ),
        ),
        prefixIconColor: AppColors.primaryColor,
        suffixIconColor: AppColors.subtitleColor,
      ),

      // ================= CARDS =================
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
          side: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        shadowColor: AppColors.cardShadow,
        clipBehavior: Clip.antiAlias,
      ),

      // ================= CHIPS =================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.textFieldFill,
        selectedColor: AppColors.primaryColor,
        disabledColor: AppColors.disabledButton,
        labelStyle: const TextStyle(
          color: AppColors.titleColor,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.buttonText,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        showCheckmark: false,
      ),

      // ================= TABS =================
      tabBarTheme: const TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 3.5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),

        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.subtitleColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          letterSpacing: 0.8,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),

        // 🚀 السر التالت: ده اللي بيمسح الخط الرمادي الطويل المزعج اللي بيبقى ممتد بعرض الشاشة
        dividerColor: Colors.transparent,
      ),

      // ================= DIALOGS & BOTTOM SHEETS =================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundColor,
        elevation: 10,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: AppColors.titleColor,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 15,
          color: AppColors.subtitleColor,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        clipBehavior: Clip.antiAlias,
        showDragHandle: false, // بنعملها إحنا كاستم شكلها أحلى
      ),

      // ================= SNACKBAR =================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.titleColor,
        actionTextColor: AppColors.secondaryColor,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // ================= SELECTION & CURSOR =================
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
        selectionColor: AppColors.secondaryColor.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.primaryColor,
      ),

      // ================= CHECKBOX, RADIO, SWITCH =================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return AppColors.primaryColor;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: AppColors.subtitleColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return AppColors.primaryColor;
          return AppColors.subtitleColor;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Colors.white
              : AppColors.hintText,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primaryColor
              : AppColors.textFieldFill,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Colors.transparent
              : AppColors.borderColor,
        ),
      ),

      // ================= OTHER COMPONENTS =================
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: 24,
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.primaryColor,
        textColor: AppColors.titleColor,
        subtitleTextStyle: TextStyle(
          color: AppColors.subtitleColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      iconTheme: const IconThemeData(color: AppColors.primaryColor, size: 24),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.buttonText,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
        linearTrackColor: AppColors.textFieldFill,
        circularTrackColor: AppColors.textFieldFill,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.titleColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

// ============================================================
//  AppDimens — كل الأبعاد في مكان واحد
// ============================================================
class AppDimens {
  AppDimens._();

  static const double screenPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double sectionSpacing = 30.0;
  static const double itemSpacing = 16.0;
  static const double smallSpacing = 8.0;

  static const double radiusSmall = 10.0;
  static const double radiusMedium =
      16.0; // كبرناها سنة عشان تدي نعومة الـ Modern UI
  static const double radiusLarge = 24.0;
  static const double radiusXL = 30.0;

  static const double buttonHeight = 56.0; // كبرنا الزرار سنة لسهولة الضغط
  static const double buttonVerticalPadding = 16.0;
  static const double inputVerticalPadding =
      18.0; // وسعنا الـ TextField عشان الفخامة
  static const double inputHorizontalPadding = 20.0;

  static const double fontXS = 11.0;
  static const double fontSM = 13.0;
  static const double fontMD = 15.0;
  static const double fontLG = 18.0;
  static const double fontXL = 22.0;
  static const double fontXXL = 26.0;
}

// ============================================================
//  AppTextStyles — ستايلات جاهزة للاستخدام السريع
// ============================================================
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.titleColor,
    letterSpacing: 0.5,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.titleColor,
  );
  static const TextStyle primaryButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: AppColors.buttonText,
    letterSpacing: 1.2,
  );
  static const TextStyle chipSelected = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
  static const TextStyle chipUnselected = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.titleColor,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.subtitleColor,
  );
  static const TextStyle badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.chartMustard,
  );
  static const TextStyle hintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.hintText,
  );
}
