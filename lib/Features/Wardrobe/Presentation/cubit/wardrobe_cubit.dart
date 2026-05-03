import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/AI/outfit_engine.dart';
import 'package:soft_wear/Core/AI/saved_outfit_model.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';

part 'wardrobe_state.dart';

class WardrobeCubit extends Cubit<WardrobeState> {
  final WardrobeRepo _wardrobeRepo;
  int currentTabIndex = 0;

  // Local storage for outfits
  List<SavedOutfit> favoriteOutfits = [];
  List<SavedOutfit> savedOutfits = [];

  WardrobeCubit(this._wardrobeRepo) : super(WardrobeInitial());

  void changeTabIndex(int index) {
    currentTabIndex = index;
    if (state is WardrobeLoaded) {
      final currentState = state as WardrobeLoaded;
      emit(WardrobeLoaded(
        items: List.from(currentState.items),
        favCount: currentState.favCount,
        savedCount: currentState.savedCount,
      ));
    }
  }

  // ================= CORE WARDROBE =================

  Future<void> fetchWardrobe({bool forceRefresh = false, bool showLoader = true}) async {
    if (!forceRefresh && state is WardrobeLoaded) return; 

    if (showLoader) emit(WardrobeLoading());

    try {
      final favCount = await _wardrobeRepo.getFavoritesCount();
      final savedCount = await _wardrobeRepo.getSavedCount();
      final result = await _wardrobeRepo.getWardrobeItems();

      result.fold(
        (error) => emit(WardrobeError(error)), 
        (items) {
          emit(WardrobeLoaded(
            items: List.from(items),
            favCount: favCount, 
            savedCount: savedCount, 
          ));
        },
      );
    } catch (e) {
      emit(WardrobeError(e.toString()));
    }
  }

  Future<void> deleteClothingItem(String itemId) async {
    final result = await _wardrobeRepo.deleteItem(itemId);
    result.fold(
      (error) => emit(WardrobeError(error)),
      (_) => fetchWardrobe(forceRefresh: true, showLoader: false),
    );
  }

  // ================= SAVED & FAVORITE DATA FETCHING =================

  Future<void> fetchFavoriteOutfits() async {
    emit(WardrobeLoading());
    final result = await _wardrobeRepo.getFavoriteOutfits();
    result.fold(
      (error) => emit(WardrobeError(error)),
      (outfits) {
        favoriteOutfits = outfits;
        fetchWardrobe(forceRefresh: true, showLoader: false);
      },
    );
  }

  Future<void> fetchSavedOutfits() async {
    emit(WardrobeLoading());
    final result = await _wardrobeRepo.getSavedOutfits();
    result.fold(
      (error) => emit(WardrobeError(error)),
      (outfits) {
        savedOutfits = outfits;
        fetchWardrobe(forceRefresh: true, showLoader: false);
      },
    );
  }

  // ================= OPTIMISTIC ACTIONS =================

  Future<void> removeFavoriteOutfit(String outfitId) async {
    favoriteOutfits.removeWhere((o) => o.id == outfitId); // Optimistic UI
    _refreshLoadedState();
    final result = await _wardrobeRepo.removeFromFavorites(outfitId);
    result.fold(
      (error) => emit(WardrobeError(error)),
      (_) => fetchWardrobe(forceRefresh: true, showLoader: false),
    );
  }

  Future<void> deleteSavedOutfit(String outfitId) async {
    savedOutfits.removeWhere((o) => o.id == outfitId); // Optimistic UI
    _refreshLoadedState();
    final result = await _wardrobeRepo.deleteSavedOutfit(outfitId);
    result.fold(
      (error) => emit(WardrobeError(error)),
      (_) => fetchWardrobe(forceRefresh: true, showLoader: false),
    );
  }

  Future<void> wearSavedOutfit(SavedOutfit outfit) async {
    final index = savedOutfits.indexWhere((o) => o.id == outfit.id);
    if (index != -1) {
      savedOutfits[index].wornScore += 1; // Optimistic UI
      _refreshLoadedState();
    }
    await _wardrobeRepo.incrementOutfitWornScore(outfit.id);
    fetchWardrobe(forceRefresh: true, showLoader: false);
  }

  void _refreshLoadedState() {
    if (state is WardrobeLoaded) {
      final current = state as WardrobeLoaded;
      emit(WardrobeLoaded(
        items: current.items,
        favCount: favoriteOutfits.length,
        savedCount: savedOutfits.length,
      ));
    }
  }

  // ================= FILTERING & SORTING LOGIC =================

  List<SavedOutfit> _filterAndSortOutfits({
    required List<SavedOutfit> outfits,
    required List<ClothingStyle> activeStyles,
    required List<ClothingSeason> activeSeasons,
    required String currentType,
    String? currentSort,
  }) {
    var processed = outfits.where((outfit) {
      bool styleMatch = activeStyles.isEmpty ||
          activeStyles.any((s) => s.name.trim().toLowerCase() == outfit.style.trim().toLowerCase());

      bool typeMatch = true;
      bool hasDress = outfit.items.any((i) => i.category == ClothingCategory.dress);
      bool hasTopAndBottom = outfit.items.any((i) => i.category == ClothingCategory.top) &&
          outfit.items.any((i) => i.category == ClothingCategory.bottom);

      if (currentType == 'dress') typeMatch = hasDress;
      else if (currentType == 'two_piece') typeMatch = hasTopAndBottom;

      bool seasonMatch = true;
      if (activeSeasons.isNotEmpty) {
        ClothingItem mainItem = outfit.items.firstWhere(
          (i) => i.category == ClothingCategory.dress || i.category == ClothingCategory.top,
          orElse: () => outfit.items.first,
        );
        seasonMatch = activeSeasons.any((s) => mainItem.matchesSeason(s));
      }

      return styleMatch && typeMatch && seasonMatch;
    }).toList();

    // Apply Sorting
    if (currentSort == 'most_worn') {
      processed.sort((a, b) => b.wornScore.compareTo(a.wornScore));
    } else if (currentSort == 'least_worn') {
      processed.sort((a, b) => a.wornScore.compareTo(b.wornScore));
    } else {
      processed.sort((a, b) => b.savedAt.compareTo(a.savedAt)); // newest default
    }

    return processed;
  }

  List<SavedOutfit> getFilteredFavorites({
    required List<ClothingStyle> styles,
    required List<ClothingSeason> seasons,
    required String type,
  }) {
    return _filterAndSortOutfits(outfits: favoriteOutfits, activeStyles: styles, activeSeasons: seasons, currentType: type);
  }

  List<SavedOutfit> getFilteredSavedOutfits({
    required List<ClothingStyle> styles,
    required List<ClothingSeason> seasons,
    required String type,
    required String sort,
  }) {
    return _filterAndSortOutfits(outfits: savedOutfits, activeStyles: styles, activeSeasons: seasons, currentType: type, currentSort: sort);
  }

  // ================= PROFILE ANALYTICS & RECENT =================

  /// Analyzes wardrobe items to determine top style percentages
  List<Map<String, dynamic>> calculateStyleInsights() {
    if (state is WardrobeLoaded) {
      final items = (state as WardrobeLoaded).items;
      if (items.isEmpty) return [];

      int totalStyleTags = 0;
      Map<String, int> styleCounts = {"Casual": 0, "Formal": 0, "Sporty": 0, "Party": 0};

      for (var item in items) {
        for (var styleEnum in item.styles) {
          String styleName = styleEnum.name[0].toUpperCase() + styleEnum.name.substring(1); 
          if (styleCounts.containsKey(styleName)) {
            styleCounts[styleName] = styleCounts[styleName]! + 1;
            totalStyleTags++;
          }
        }
      }
      if (totalStyleTags == 0) return []; 
      
      List<Map<String, dynamic>> insights = [];
      styleCounts.forEach((key, count) {
        if (count > 0) insights.add({"title": key, "percentage": count / totalStyleTags});
      });
      insights.sort((a, b) => (b['percentage'] as double).compareTo(a['percentage'] as double));
      return insights;
    }
    return [];
  }

 /// Retrieves the 5 most recently added wardrobe items
  List<ClothingItem> getRecentlyAdded() {
    if (state is WardrobeLoaded) {
      final items = (state as WardrobeLoaded).items;
      return items.take(5).toList();
    }
    return [];
  }

  // ================= ADD TO FAVORITES & SAVED =================

  Future<void> addOutfitToFavorites(Outfit outfit, String style) async {
    final result = await _wardrobeRepo.addToFavorites(outfit, style);
    result.fold(
      (error) => emit(WardrobeError(error)),
      (_) {
        fetchWardrobe(forceRefresh: true, showLoader: false);
      },
    );
  }

  Future<void> saveNewOutfit(Outfit outfit, String style) async {
    final result = await _wardrobeRepo.saveOutfit(outfit, style);
    result.fold(
      (error) => emit(WardrobeError(error)),
      (_) {
        fetchWardrobe(forceRefresh: true, showLoader: false);
      },
    );
  }
}