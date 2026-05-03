import 'package:soft_wear/Core/Constants/firebase_constants.dart';

enum ClothingCategory { top, bottom, shoes, dress, jacket }

enum ClothingSeason { summer, winter, autumn, spring, all }

enum ClothingStyle { casual, formal, sporty, party }

class ClothingItem {
  final String id;
  final String userId;
  final ClothingCategory category;
  final String color;

  final List<ClothingStyle> styles;
  final List<ClothingSeason> seasons;

  final String? imageUrl;
  final String? imageHash; 

  final int lastWornDays;
  final String name;

  ClothingItem({
    required this.id,
    required this.userId,
    required this.category,
    required this.color,
    required this.styles,
    required this.seasons,
    this.imageUrl,
    this.imageHash, 
    this.lastWornDays = 10,
    required this.name,
  });

  // ============ Firestore → Model ============
  factory ClothingItem.fromMap(String id, Map<String, dynamic> map) {
    try {
      return ClothingItem(
        id: id,
        userId: map[FirebaseConstants.fieldUserId] ?? '',
        color: map[FirebaseConstants.fieldColor] ?? '',
        imageUrl: map[FirebaseConstants.fieldImageUrl],
        imageHash: map[FirebaseConstants.fieldImageHash], 
        lastWornDays: map[FirebaseConstants.fieldLastWornDays] ?? 10,

        category: ClothingCategory.values.firstWhere(
          (e) => e.name == map[FirebaseConstants.fieldCategory],
          orElse: () => ClothingCategory.top,
        ),

        styles: (map['styles'] is List)
            ? (map['styles'] as List)
                  .map(
                    (e) => ClothingStyle.values.firstWhere(
                      (style) => style.name == e,
                      orElse: () => ClothingStyle.casual,
                    ),
                  )
                  .toList()
            : [],

        seasons: (map['seasons'] is List)
            ? (map['seasons'] as List)
                  .map(
                    (e) => ClothingSeason.values.firstWhere(
                      (season) => season.name == e,
                      orElse: () => ClothingSeason.all,
                    ),
                  )
                  .toList()
            : [],

        name: map['name'] ?? 'Unnamed Item',
      );
    } catch (e) {
      print("❌ CRITICAL ERROR PARSING ITEM $id: $e");
      return ClothingItem(
        id: id,
        userId: '',
        category: ClothingCategory.top,
        color: '',
        styles: [],
        seasons: [],
        name: 'Error Loading Item',
        imageHash: null, 
      );
    }
  }

  // ============ Model → Firestore ============
  Map<String, dynamic> toMap() {
    return {
      FirebaseConstants.fieldUserId: userId,
      FirebaseConstants.fieldCategory: category.name,
      FirebaseConstants.fieldColor: color,
      FirebaseConstants.fieldImageUrl: imageUrl,
      FirebaseConstants.fieldImageHash: imageHash,

      'styles': styles.map((e) => e.name).toList(),
      'seasons': seasons.map((e) => e.name).toList(),
      'lastWornDays': lastWornDays,
      'name': name,
    };
  }

  // ============ Helper ============
  bool matchesStyle(ClothingStyle targetStyle) {
    return styles.contains(targetStyle);
  }

  bool matchesSeason(ClothingSeason targetSeason) {
    return seasons.contains(targetSeason) ||
        seasons.contains(ClothingSeason.all);
  }
}
