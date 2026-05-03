class AppConstants {
  // ================= Validation Numbers =================
  static const int passwordMinLength = 8;
  static const int nameMinLength = 3;

  // ================= Regular Expressions =================
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{3,}$';
  static const String passwordRegex = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  // ================= Timers & Delays =================
  static const int splashDelay = 3; 
  static const int apiTimeout = 30;

  // ================= SharedPreferences Keys  =================
  static const String prefsSavedCity = 'saved_city';
  static const String prefsIsCelsius = 'is_celsius';
  static const String prefsIsDarkTheme = 'is_dark_theme';
  static const String prefsSeenOnboarding = 'seenOnboarding';
}