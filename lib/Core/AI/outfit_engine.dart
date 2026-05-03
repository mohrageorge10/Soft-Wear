import 'package:soft_wear/Core/AI/clothing_item_model.dart';

class Outfit {
  final List<ClothingItem> items;
  final bool hasOptionalJacket;
  final int matchScore;

  Outfit({required this.items, this.hasOptionalJacket = false, this.matchScore = 0});
}


class OutfitEngine {
  static final List<String> _neutralColors = [
    'black', 'white', 'gray', 'beige', 'brown', 'navy', 'silver',
    'gold', 'denim', 'cream', 'khaki', 'off-white'
  ];

  static bool _doColorsMatch(String color1, String color2) {
    final c1 = color1.toLowerCase().trim();
    final c2 = color2.toLowerCase().trim();
    if (c1 == c2) return true;
    if (_neutralColors.contains(c1) || _neutralColors.contains(c2)) return true;
    return false;
  }

 static bool _isClash(String c1, String c2) {
    final pair = [c1.toLowerCase().trim(), c2.toLowerCase().trim()]..sort();
    
    final clashPairs = [
      // 1. الألوان الغامقة اللي بتطفي بعض لو اتلبست مع بعض (Dark Clashes)
      ['black', 'navy'], 
      ['black', 'brown'],
      ['charcoal', 'navy'],
      ['charcoal', 'brown'],

      // 2. المهرجانات والألوان اللي بتدي إيحاءات غريبة (High Contrast Clashes)
      ['red', 'green'],       // شجرة الكريسماس
      ['blue', 'yellow'],     // آيكيا / مينيونز (زي ما طلبتي)
      ['red', 'yellow'],      // ماكدونالدز
      ['purple', 'yellow'],   // طقم لوس أنجلوس ليكرز
      ['red', 'pink'],        // الفلانتين
      ['orange', 'pink'],     
      ['green', 'orange'],    

      // 3. درجات متضاربة ومش مريحة للعين (Undertone Clashes)
      ['burgundy', 'red'],    // أحمر غامق مع أحمر صريح
      ['rust', 'pink'],       // طوبي/صدئ مع بمبى
      ['terracotta', 'pink'], // تيراكوتا مع بمبى
      ['teal', 'red'],        // بطاطي/تيل مع أحمر
      ['mustard', 'purple'],  // مستردة مع بنفسجي
      ['olive', 'blue'],      // زيتي مع أزرق صريح
      ['turquoise', 'red'],   // تركواز مع أحمر
    ];

    for (var p in clashPairs) {
      // بنرتب عناصر الـ list الصغيرة عشان لو جت معكوسة يقفشها برضو
      p.sort(); 
      if (p[0] == pair[0] && p[1] == pair[1]) return true; // دول أعداء!
    }
    return false;
  }
  static int _calculateHarmony(String top, String bottom, String shoe, {String? jacket}) {
    int score = 0;
    
    if (_isClash(top, bottom) || _isClash(bottom, shoe)) return -50; // طقم بشع!

    if (_doColorsMatch(top, bottom)) score += 3;
    if (_doColorsMatch(bottom, shoe) || _doColorsMatch(top, shoe)) score += 2;
    
    if (jacket != null) {
      if (_isClash(jacket, top) || _isClash(jacket, bottom)) return -50;
      if (_doColorsMatch(jacket, top)) score += 4; 
    }
    return score;
  }

  static String? getMissingPiece(List<ClothingItem> validItems, ClothingSeason season, ClothingStyle style) {
    bool hasTop = validItems.any((i) => i.category == ClothingCategory.top);
    bool hasBottom = validItems.any((i) => i.category == ClothingCategory.bottom);
    bool hasShoes = validItems.any((i) => i.category == ClothingCategory.shoes);
    bool hasDress = validItems.any((i) => i.category == ClothingCategory.dress);

    if ((hasDress && hasShoes) || (hasTop && hasBottom && hasShoes)) return null;

    String sName = season.name;
    String stName = style.name;

    if (!hasShoes) return "$sName $stName shoes";
    if (!hasDress && !hasTop) return "$sName $stName top";
    if (!hasDress && hasTop && !hasBottom) return "$sName $stName bottom";
    return "$sName $stName items";
  }

  static List<Outfit> generate({
    required int currentTemp,
    required ClothingStyle style,
    required List<ClothingItem> wardrobe,
    Map<String, int>? wornScores, // 🆕 سكورات اللبس من الأطقم المحفوظة
  }) {
    List<Outfit> allPossibleOutfits = [];

    ClothingSeason currentSeason;
    if (currentTemp < 15) currentSeason = ClothingSeason.winter;
    else if (currentTemp < 25) currentSeason = ClothingSeason.autumn;
    else currentSeason = ClothingSeason.summer;

    List<ClothingItem> validItems = wardrobe.where((item) {
      return item.matchesStyle(style) &&
          (item.matchesSeason(currentSeason) || item.matchesSeason(ClothingSeason.all));
    }).toList();

    bool hasEnoughItems = getMissingPiece(validItems, currentSeason, style) == null;

    if (!hasEnoughItems) {
      validItems = wardrobe.where((item) => item.matchesStyle(style)).toList();
    }

    final tops = validItems.where((i) => i.category == ClothingCategory.top).toList();
    final bottoms = validItems.where((i) => i.category == ClothingCategory.bottom).toList();
    final shoes = validItems.where((i) => i.category == ClothingCategory.shoes).toList();
    final dresses = validItems.where((i) => i.category == ClothingCategory.dress).toList();
    final jackets = validItems.where((i) => i.category == ClothingCategory.jacket).toList();

    bool needsJacket = currentTemp < 22 || style == ClothingStyle.formal || style == ClothingStyle.party;
    bool isJacketOptional = style == ClothingStyle.formal || style == ClothingStyle.party;

    // 🆕 دالة مساعدة لحساب penalty السكور (كل ما اتلبس أكتر، السكور بينزل)
    int _wornPenalty(List<ClothingItem> items) {
      if (wornScores == null || wornScores.isEmpty) return 0;
      int penalty = 0;
      for (final item in items) {
        penalty += wornScores[item.id] ?? 0;
      }
      return penalty;
    }

    // 👗 فساتين
    for (var dress in dresses) {
      for (var shoe in shoes) {
        int baseScore = _doColorsMatch(dress.color, shoe.color) ? 3 : 0;
        int penalty = _wornPenalty([dress, shoe]);

        if (!needsJacket || isJacketOptional) {
          allPossibleOutfits.add(Outfit(
            items: [dress, shoe],
            hasOptionalJacket: false,
            matchScore: baseScore - penalty,
          ));
        }

        if (jackets.isNotEmpty && needsJacket) {
          for (var jacket in jackets) {
            int jacketScore = baseScore + (_doColorsMatch(jacket.color, dress.color) ? 4 : -10);
            int jacketPenalty = _wornPenalty([dress, shoe, jacket]);
            allPossibleOutfits.add(Outfit(
              items: [dress, shoe, jacket],
              hasOptionalJacket: isJacketOptional,
              matchScore: jacketScore - jacketPenalty,
            ));
          }
        }
      }
    }

    // 👕 توب وبوطم
    for (var top in tops) {
      for (var bottom in bottoms) {
        for (var shoe in shoes) {
          int baseScore = _calculateHarmony(top.color, bottom.color, shoe.color);
          int penalty = _wornPenalty([top, bottom, shoe]);

          if (!needsJacket || isJacketOptional) {
            allPossibleOutfits.add(Outfit(
              items: [top, bottom, shoe],
              hasOptionalJacket: false,
              matchScore: baseScore - penalty,
            ));
          }

          if (jackets.isNotEmpty && needsJacket) {
            for (var jacket in jackets) {
              int jacketScore = _calculateHarmony(top.color, bottom.color, shoe.color, jacket: jacket.color);
              int jacketPenalty = _wornPenalty([top, bottom, shoe, jacket]);
              allPossibleOutfits.add(Outfit(
                items: [top, bottom, shoe, jacket],
                hasOptionalJacket: isJacketOptional,
                matchScore: jacketScore - jacketPenalty,
              ));
            }
          }
        }
      }
    }

    // ترتيب من الأشيك للأوحش
    allPossibleOutfits.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    if (allPossibleOutfits.isEmpty) {
      if (dresses.isNotEmpty && shoes.isNotEmpty) {
        List<ClothingItem> fallback = [dresses.first, shoes.first];
        if (needsJacket && jackets.isNotEmpty) fallback.add(jackets.first);
        allPossibleOutfits.add(Outfit(items: fallback, hasOptionalJacket: isJacketOptional));
      } else if (tops.isNotEmpty && bottoms.isNotEmpty && shoes.isNotEmpty) {
        List<ClothingItem> fallback = [tops.first, bottoms.first, shoes.first];
        if (needsJacket && jackets.isNotEmpty) fallback.add(jackets.first);
        allPossibleOutfits.add(Outfit(items: fallback, hasOptionalJacket: isJacketOptional));
      }
    }

    var topOutfits = allPossibleOutfits.take(15).toList();
    topOutfits.shuffle();

    return topOutfits;
  }
}
