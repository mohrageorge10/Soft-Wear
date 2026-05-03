class FirebaseConstants {
  // ================= Collections =================
  static const String usersCollection = 'users';
  static const String outfitsCollection = 'outfits';
  static const String wardrobeCollection = 'wardrobe';
  static const String savedOutfitsCollection = 'saved_outfits';
  static const String favoriteOutfitsCollection = 'favorite_outfits';

  // ================= User Fields =================
  static const String fieldUid = 'uid';
  static const String fieldName = 'name';
  static const String fieldEmail = 'email';
  static const String fieldProfilePic = 'profile_picture';
  static const String fieldCity = 'city';
  static const String fieldCreatedAt = 'created_at';

  // ================= Wardrobe Fields =================
  static const String fieldCategory = 'category'; 
  static const String fieldColor = 'color';
  static const String fieldStyle = 'style'; 
  static const String fieldImageUrl = 'image_url';
  static const String fieldUserId = 'user_id';
  static const String fieldImageHash = 'image_hash';
  static const String fieldWornCount = 'worn_count'; 

  // ================= Storage Paths =================
  static const String profileImagesPath = 'profile_images/';
  static const String wardrobeImagesPath = 'wardrobe_images/';

  // ================= Outfit Fields =================
  static const String fieldLastWornDays = 'lastWornDays';
  static const String fieldSeason = 'season';
}