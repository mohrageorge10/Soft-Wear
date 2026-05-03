import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/AI/outfit_engine.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Home/Data/Models/weather_model.dart';
import 'package:soft_wear/Features/Home/Data/Repo/weather_repo.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final WeatherRepository weatherRepository;
  final WardrobeRepo wardrobeRepo;

  HomeCubit(this.weatherRepository, this.wardrobeRepo) : super(HomeInitial());

  WeatherModel? currentWeather;
  Outfit? currentOutfit;
  String _currentStyle = 'Casual';
  String? _currentSavedOutfitId;
// ================= Fetch Weather =================
  Future<void> fetchWeather({String? userCity, bool forceGps = false}) async {
    emit(HomeWeatherLoading());

    final prefs = await SharedPreferences.getInstance();

    // 1. نجيب الكلمة سواء اليوزر لسه باعتها، أو متسجلة في الذاكرة
    String? finalCity = userCity ?? prefs.getString('saved_city');

    // 🚀 2. الفلتر الفولاذي: أي كلمة فيها gps أو auto تتمسح فوراً مهما كان مصدرها!
    if (finalCity != null && (finalCity.toLowerCase().contains('gps') || finalCity.toLowerCase().contains('auto'))) {
      forceGps = true; // شغل الـ GPS
      finalCity = null; // دمر الكلمة عشان الـ API ميشوفهاش
    }

    // 3. لو الـ GPS مطلوب، ننظف الذاكرة عشان التطبيق ينسى الكلمة الغلط
    if (forceGps) {
      await prefs.remove('saved_city');
      finalCity = null; // تأكيد إنها فاضية للـ Repo
    } else if (finalCity != null && finalCity.isNotEmpty) {
      // لو مدينة حقيقية، نحفظها
      await prefs.setString('saved_city', finalCity);
    }

    try {
      // 4. نبعت للـ Repo (دلوقتي مستحيل يتبعتله كلمة Auto أو GPS)
      final weather = await weatherRepository.getWeather(cityName: finalCity);

      if (weather != null) {
        currentWeather = weather;
        if (!isClosed) {
          emit(HomeWeatherLoaded(weather));
        }
      } else {
        if (!isClosed) emit(HomeWeatherError(AppStrings.weatherFailed));
      }
    } catch (e) {
      if (!isClosed) emit(HomeWeatherError("Error fetching weather: ${e.toString()}"));
    }
  }

  // ================= Generate Outfit (Smart Logic + Score System) =================
  Future<void> generateOutfit(
    String style, {
    bool forceFallback = false,
  }) async {
    if (currentWeather == null) return;

    emit(HomeOutfitLoading());

    final result = await wardrobeRepo.getWardrobeItems();

    result.fold((error) => emit(HomeWardrobeError(error)), (allItems) async {
      if (allItems.isEmpty) {
        emit(HomeWardrobeEmpty());
        return;
      }

      final targetStyle = _resolveStyle(userChoice: style);

      ClothingSeason currentSeason;
      if (currentWeather!.temperature < 15)
        currentSeason = ClothingSeason.winter;
      else if (currentWeather!.temperature < 25)
        currentSeason = ClothingSeason.autumn;
      else
        currentSeason = ClothingSeason.summer;

      final strictItems = allItems
          .where(
            (i) =>
                i.matchesStyle(targetStyle) &&
                (i.matchesSeason(currentSeason) ||
                    i.matchesSeason(ClothingSeason.all)),
          )
          .toList();
      String? missingItemDescription = OutfitEngine.getMissingPiece(
        strictItems,
        currentSeason,
        targetStyle,
      );

      bool isFormalOrParty =
          targetStyle == ClothingStyle.formal ||
          targetStyle == ClothingStyle.party;

      if (missingItemDescription != null &&
          !isFormalOrParty &&
          !forceFallback) {
        emit(
          HomeOutfitRequiresConsent(
            missingItem: missingItemDescription,
            style: style,
          ),
        );
        return;
      }

      // نجيب الـ worn scores من الأطقم المحفوظة عشان الـ Engine يبعد عنها
      final wornScores = await wardrobeRepo.getSavedOutfitsWornScores();

      final suggestedOutfits = OutfitEngine.generate(
        currentTemp: currentWeather!.temperature.toInt(),
        style: targetStyle,
        wardrobe: allItems,
        wornScores: wornScores,
      );

      if (suggestedOutfits.isEmpty) {
        emit(HomeInsufficientItems(style: style));
        return;
      }

      final random = Random();
      final topChoicesCount = suggestedOutfits.length > 10
          ? 10
          : suggestedOutfits.length;

      Outfit selectedOutfit;
      if (currentOutfit != null && topChoicesCount > 1) {
        int attempts = 0;
        do {
          selectedOutfit = suggestedOutfits[random.nextInt(topChoicesCount)];
          attempts++;
        } while (attempts < 10 &&
            _isSameOutfit(selectedOutfit, currentOutfit!));
      } else {
        selectedOutfit = suggestedOutfits[random.nextInt(topChoicesCount)];
      }

      currentOutfit = selectedOutfit;
      _currentStyle = style;
      _currentSavedOutfitId = null;

      // 💡 هنا بنخلي showNotification = true عشان يقولك "Outfit is ready" أول ما يتكون
      emit(
        HomeOutfitGenerated(
          outfit: currentOutfit!,
          style: _currentStyle,
          showNotification: true, 
        ),
      );
    });
  }

  // ================= Save Outfit =================
  Future<void> saveOutfit() async {
    if (currentOutfit == null) return;

    emit(HomeOutfitActionLoading());
    try {
      final result = await wardrobeRepo.saveOutfit(
        currentOutfit!,
        _currentStyle,
      );
      result.fold(
        (error) {
          emit(HomeOutfitActionError(error));
          // 💡 لاحظي هنا الـ showNotification: false
          emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
        },
        (id) {
          _currentSavedOutfitId = id;
          emit(HomeOutfitSaved());
          emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
        },
      );
    } catch (e) {
      emit(HomeOutfitActionError("Failed to save outfit: $e"));
      emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
    }
  }

  // ================= Add to Favorites =================
  Future<void> saveOutfitToFavorites() async {
    if (currentOutfit == null) return;

    emit(HomeOutfitActionLoading());
    try {
      final result = await wardrobeRepo.addToFavorites(
        currentOutfit!,
        _currentStyle,
      );
      result.fold(
        (error) {
          emit(HomeOutfitActionError(error));
          emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
        },
        (_) {
          emit(HomeOutfitFavorited());
          emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
        },
      );
    } catch (e) {
      emit(HomeOutfitActionError("Failed to add to favorites: $e"));
      emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
    }
  }

  // ================= Wear Outfit (Score + LastWorn) =================
  Future<void> wearOutfit() async {
    if (currentOutfit == null) return;

    emit(HomeOutfitActionLoading());
    try {
      // 1. نحفظ الطقم في saved_outfits لو مش محفوظ
      String outfitId = _currentSavedOutfitId ?? '';
      if (outfitId.isEmpty) {
        final saveResult = await wardrobeRepo.saveOutfit(
          currentOutfit!,
          _currentStyle,
        );
        saveResult.fold((_) {}, (id) => outfitId = id);
      }

      // 2. نزود الـ worn score
      if (outfitId.isNotEmpty) {
        await wardrobeRepo.incrementOutfitWornScore(outfitId);
        _currentSavedOutfitId = outfitId;
      }

      // 3. نحدث lastWornDays لكل قطعة
      for (var item in currentOutfit!.items) {
        await wardrobeRepo.updateLastWorn(item.id);
      }

      emit(HomeOutfitWorn());
      emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
    } catch (e) {
      emit(HomeOutfitActionError("Failed to update wardrobe: $e"));
      emit(HomeOutfitGenerated(outfit: currentOutfit!, style: _currentStyle, showNotification: false));
    }
  }

  // ================= Smart Suggestion =================
  String getSmartSuggestion(int temp) {
    if (temp == 0) return AppStrings.suggestionDefault;
    if (temp < 15) return AppStrings.suggestionCold;
    if (temp < 22) return AppStrings.suggestionChilly;
    if (temp > 30) return AppStrings.suggestionHot;
    return AppStrings.suggestionGreat;
  }

  bool _isSameOutfit(Outfit a, Outfit b) {
    if (a.items.length != b.items.length) return false;
    final aIds = a.items.map((i) => i.id).toSet();
    final bIds = b.items.map((i) => i.id).toSet();
    return aIds.containsAll(bIds) && bIds.containsAll(aIds);
  }

  ClothingStyle _resolveStyle({required String userChoice}) {
    switch (userChoice.toLowerCase()) {
      case 'formal':
        return ClothingStyle.formal;
      case 'party':
        return ClothingStyle.party;
      case 'sporty':
        return ClothingStyle.sporty;
      default:
        return ClothingStyle.casual;
    }
  }
}