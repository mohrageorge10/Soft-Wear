import 'package:dartz/dartz.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/AI/outfit_engine.dart';
import 'package:soft_wear/Core/AI/saved_outfit_model.dart';
import 'package:soft_wear/Core/Constants/firebase_constants.dart';
import 'package:soft_wear/Core/Networking/firebase/firebase_auth_service.dart';
import 'package:soft_wear/Core/Networking/firebase/firestore_service.dart';

class WardrobeRepo {
  /// Helper to get generic outfits from any sub-collection
  Future<Either<String, List<SavedOutfit>>> _getOutfitsFrom(
    String subCollection,
  ) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return const Left('User not authenticated');

      final wardrobeResult = await getWardrobeItems();
      List<ClothingItem> wardrobeItems = [];
      wardrobeResult.fold((_) {}, (items) => wardrobeItems = items);

      final docs = await FirestoreService.getSubCollectionOrdered(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: subCollection,
        orderByField: 'saved_at',
        descending: true,
      );

      final outfits = docs
          .map(
            (docData) =>
                SavedOutfit.fromMap(docData['doc_id'], docData, wardrobeItems),
          )
          .where((o) => o.items.isNotEmpty)
          .toList();

      return Right(outfits);
    } catch (e) {
      return Left('Failed to load outfits: ${e.toString()}');
    }
  }

  /// Helper to save an outfit to any sub-collection
  Future<Either<String, String>> _saveOutfitTo(
    Outfit outfit,
    String style,
    String subCollection,
    String duplicateMsg,
  ) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return const Left('User not authenticated');

      List<String> itemIds = outfit.items.map((i) => i.id).toList();
      itemIds.sort();
      String uniqueOutfitId = itemIds.join('_');

      final exists = await FirestoreService.checkSubCollectionDocExists(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: subCollection,
        docId: uniqueOutfitId,
      );

      if (exists) return Left(duplicateMsg);

      final saved = SavedOutfit(
        id: uniqueOutfitId,
        items: outfit.items,
        style: style,
        matchScore: outfit.matchScore,
        hasOptionalJacket: outfit.hasOptionalJacket,
        savedAt: DateTime.now(),
        wornScore: 0,
      );

      await FirestoreService.setSubCollectionDocument(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: subCollection,
        docId: uniqueOutfitId,
        data: saved.toMap(),
      );

      return Right(uniqueOutfitId);
    } catch (e) {
      return Left('Failed to save outfit: ${e.toString()}');
    }
  }

  /// Helper to delete a specific outfit from a sub-collection
  Future<Either<String, void>> _deleteOutfitFrom(
    String outfitId,
    String subCollection,
  ) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return const Left('User not authenticated');

      await FirestoreService.deleteSubCollectionDocument(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: subCollection,
        docId: outfitId,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete outfit: ${e.toString()}');
    }
  }

  /// Helper to count documents in a sub-collection
  Future<int> _getCountFrom(String subCollection) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return 0;

      final docs = await FirestoreService.getSubCollection(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: subCollection,
      );
      return docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Helper to scan and delete an item from saved/favorite outfits
  Future<void> _removeItemFromOutfits(
    String userId,
    String itemId,
    String subCollection,
  ) async {
    final docs = await FirestoreService.getSubCollection(
      parentCollection: FirebaseConstants.usersCollection,
      parentDocId: userId,
      subCollectionName: subCollection,
    );

    for (var data in docs) {
      bool containsItem = false;
      if (data['items'] != null) {
        containsItem = (data['items'] as List).any(
          (item) => item['id'] == itemId,
        );
      } else if (data['item_ids'] != null) {
        containsItem = (data['item_ids'] as List).contains(itemId);
      }

      if (containsItem) {
        await FirestoreService.deleteSubCollectionDocument(
          parentCollection: FirebaseConstants.usersCollection,
          parentDocId: userId,
          subCollectionName: subCollection,
          docId: data['doc_id'],
        );
      }
    }
  }

  // ================= 👕 CORE WARDROBE ITEMS =================

  Future<Either<String, List<ClothingItem>>> getWardrobeItems() async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return const Left('User not authenticated');

      final docs = await FirestoreService.getSubCollection(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: FirebaseConstants.wardrobeCollection,
      );
      docs.sort(
        (a, b) => (b['created_at'] ?? 0).compareTo(a['created_at'] ?? 0),
      );

      final items = docs
          .map((docData) => ClothingItem.fromMap(docData['doc_id'], docData))
          .toList();
      return Right(items);
    } catch (e) {
      return Left('Failed to load wardrobe: ${e.toString()}');
    }
  }

 Future<Either<String, void>> addItem(ClothingItem item) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return const Left('User not authenticated');

      final data = item.toMap();
      data['created_at'] = DateTime.now().millisecondsSinceEpoch;

      await FirestoreService.addSubCollectionDocument(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: FirebaseConstants.wardrobeCollection,
        data: data,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to add item: ${e.toString()}');
    }
  }

  Future<Either<String, void>> deleteItem(String itemId) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return const Left('User not authenticated');

      await FirestoreService.deleteSubCollectionDocument(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: FirebaseConstants.wardrobeCollection,
        docId: itemId,
      );

      await _removeItemFromOutfits(
        user.uid,
        itemId,
        FirebaseConstants.savedOutfitsCollection,
      );
      await _removeItemFromOutfits(
        user.uid,
        itemId,
        FirebaseConstants.favoriteOutfitsCollection,
      );

      return const Right(null);
    } catch (e) {
      return Left('Failed to delete item: ${e.toString()}');
    }
  }

  Future<Either<String, void>> updateLastWorn(String itemId) async {
    return updateItem(itemId, {'lastWornDays': 0});
  }

  Future<Either<String, void>> updateItem(
    String itemId,
    Map<String, dynamic> data,
  ) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return const Left('User not authenticated');

      await FirestoreService.updateSubCollectionDocument(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: FirebaseConstants.wardrobeCollection,
        docId: itemId,
        data: data,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to update item: ${e.toString()}');
    }
  }

  Future<bool> isImageDuplicate(String hash, String userId) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return false;

      final docs = await FirestoreService.getSubCollectionWithCondition(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: FirebaseConstants.wardrobeCollection,
        field: FirebaseConstants.fieldImageHash,
        isEqualTo: hash,
      );
      return docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ================= 🔖 SAVED OUTFITS =================

  Future<Either<String, String>> saveOutfit(Outfit outfit, String style) =>
      _saveOutfitTo(
        outfit,
        style,
        FirebaseConstants.savedOutfitsCollection,
        'You already saved this outfit! 👗',
      );

  Future<Either<String, List<SavedOutfit>>> getSavedOutfits() =>
      _getOutfitsFrom(FirebaseConstants.savedOutfitsCollection);

  Future<Either<String, void>> deleteSavedOutfit(String outfitId) =>
      _deleteOutfitFrom(outfitId, FirebaseConstants.savedOutfitsCollection);

  Future<int> getSavedCount() =>
      _getCountFrom(FirebaseConstants.savedOutfitsCollection);

  Future<void> incrementOutfitWornScore(String outfitId) async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return;

      final doc = await FirestoreService.getSubCollectionDocument(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: FirebaseConstants.savedOutfitsCollection,
        docId: outfitId,
      );

      if (doc != null) {
        await FirestoreService.updateSubCollectionDocument(
          parentCollection: FirebaseConstants.usersCollection,
          parentDocId: user.uid,
          subCollectionName: FirebaseConstants.savedOutfitsCollection,
          docId: outfitId,
          data: {
            'worn_score': (doc['worn_score'] ?? 0) + 1,
            'last_worn_at': DateTime.now().millisecondsSinceEpoch,
          },
        );
      }
    } catch (e) {
      print("Error updating worn score: $e");
    }
  }

  Future<Map<String, int>> getSavedOutfitsWornScores() async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) return {};

      final docs = await FirestoreService.getSubCollection(
        parentCollection: FirebaseConstants.usersCollection,
        parentDocId: user.uid,
        subCollectionName: FirebaseConstants.savedOutfitsCollection,
      );

      final Map<String, int> scores = {};
      for (final data in docs) {
        final List<String> itemIds = List<String>.from(data['item_ids'] ?? []);
        final int wornScore = data['worn_score'] ?? 0;
        final int? lastWornMs = data['last_worn_at'];

        int daysSince = lastWornMs != null
            ? DateTime.now()
                  .difference(DateTime.fromMillisecondsSinceEpoch(lastWornMs))
                  .inDays
            : 999;
        final int recentnessScore = wornScore > 0
            ? (30 - daysSince).clamp(0, 30)
            : 0;

        for (final id in itemIds) {
          scores[id] = (scores[id] ?? 0) + recentnessScore;
        }
      }
      return scores;
    } catch (e) {
      return {};
    }
  }

  // ================= ❤️ FAVORITE OUTFITS =================

  Future<Either<String, String>> addToFavorites(Outfit outfit, String style) =>
      _saveOutfitTo(
        outfit,
        style,
        FirebaseConstants.favoriteOutfitsCollection,
        'This outfit is already in your favorites! ❤️',
      );

  Future<Either<String, List<SavedOutfit>>> getFavoriteOutfits() =>
      _getOutfitsFrom(FirebaseConstants.favoriteOutfitsCollection);

  Future<Either<String, void>> removeFromFavorites(String outfitId) =>
      _deleteOutfitFrom(outfitId, FirebaseConstants.favoriteOutfitsCollection);

  Future<int> getFavoritesCount() =>
      _getCountFrom(FirebaseConstants.favoriteOutfitsCollection);
}
