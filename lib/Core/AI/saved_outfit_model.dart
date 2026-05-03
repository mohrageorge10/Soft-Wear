import 'package:soft_wear/Core/AI/clothing_item_model.dart';

class SavedOutfit {
  final String id;
  final List<ClothingItem> items;
  final String style;
  final int matchScore;
  final bool hasOptionalJacket;
  final DateTime savedAt;
  final DateTime? lastWornAt;
  int wornScore;

  SavedOutfit({
    required this.id,
    required this.items,
    required this.style,
    required this.matchScore,
    this.hasOptionalJacket = false,
    required this.savedAt,
    this.lastWornAt,
    this.wornScore = 0,
  });

  // ============ Firestore → Model ============
  factory SavedOutfit.fromMap(
    String id,
    Map<String, dynamic> map,
    List<ClothingItem> wardrobeItems,
  ) {
    final List<String> itemIds = List<String>.from(map['item_ids'] ?? []);

    // نجمع القطع الفعلية من الـ wardrobe بناءً على الـ IDs
    final List<ClothingItem> outfitItems = itemIds
        .map((itemId) => wardrobeItems.where((i) => i.id == itemId).firstOrNull)
        .where((item) => item != null)
        .cast<ClothingItem>()
        .toList();

    return SavedOutfit(
      id: id,
      items: outfitItems,
      style: map['style'] ?? 'casual',
      matchScore: map['match_score'] ?? 0,
      hasOptionalJacket: map['has_optional_jacket'] ?? false,
      savedAt: map['saved_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['saved_at'])
          : DateTime.now(),
      lastWornAt: map['last_worn_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_worn_at'])
          : null,
      wornScore: map['worn_score'] ?? 0,
    );
  }

  // ============ Model → Firestore ============
  Map<String, dynamic> toMap() {
    return {
      'item_ids': items.map((i) => i.id).toList(),
      'style': style,
      'match_score': matchScore,
      'has_optional_jacket': hasOptionalJacket,
      'saved_at': savedAt.millisecondsSinceEpoch,
      'last_worn_at': lastWornAt?.millisecondsSinceEpoch,
      'worn_score': wornScore,
    };
  }

  SavedOutfit copyWith({int? wornScore, DateTime? lastWornAt}) {
    return SavedOutfit(
      id: id,
      items: items,
      style: style,
      matchScore: matchScore,
      hasOptionalJacket: hasOptionalJacket,
      savedAt: savedAt,
      lastWornAt: lastWornAt ?? this.lastWornAt,
      wornScore: wornScore ?? this.wornScore,
    );
  }

  /// كم يوم عدى من آخر مرة اتلبس
  int get daysSinceLastWorn {
    if (lastWornAt == null) return 999;
    return DateTime.now().difference(lastWornAt!).inDays;
  }
}
