class ApiConstants {
  // ================= OpenWeatherMap API =================
  static const String weatherBaseUrl = "https://api.openweathermap.org/data/2.5/";
  static const String weatherApiKey = "163d9c0b2630075780c696a4c7f7e0d7"; 

  // ================= Cloudinary API =================
  static const String cloudName = 'dthvsfo4y';
  static const String uploadPreset = 'soft_wear';
  static const String cloudinaryBaseUrl = 'https://api.cloudinary.com/v1_1/';
  static const String imageUploadEndpoint = '/image/upload';
  static const String wardrobeFolder = 'wardrobe';
  static const String bgRemovalAddon = 'pixelz';

  // ================= API Error Messages =================
  static const String networkError = "Network Error: ";
  static const String badRequest = "Bad Request: ";
  static const String unauthorized = "Unauthorized: Invalid API Key";
  static const String serverError = "Server Error: ";
  static const String fetchWeatherError = "Error fetching weather: ";
  
  // ================= Cloudinary Error Messages =================
  static const String errorNotLoggedIn = 'User not logged in!';
  static const String errorUploadFailed = 'Failed to upload image. Please check settings.';
}