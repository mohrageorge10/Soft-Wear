import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/api_constants.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';

part 'add_item_state.dart';

class AddItemCubit extends Cubit<AddItemState> {
  final WardrobeRepo _wardrobeRepo = WardrobeRepo();

  AddItemCubit() : super(AddItemInitial());

  Future<void> saveItem({
    required ClothingCategory category,
    required String color,
    required List<ClothingStyle> styles,
    required List<ClothingSeason> seasons,
    File? imageFile,
  }) async {
    emit(AddItemLoading());

    try {
      String? imageUrl;
      String? fileHash; // 🆕 متغير لحفظ البصمة
      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        emit(AddItemError(message: ApiConstants.errorNotLoggedIn));
        return;
      }

      // 1. 🚀 عمل بصمة للصورة والتحقق من التكرار (قبل الرفع!)
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        fileHash = md5.convert(bytes).toString(); // دي البصمة (Hash)
        print("🔍🔍🔍 IMAGE HASH: $fileHash 🔍🔍🔍");
        final isDuplicate = await _wardrobeRepo.isImageDuplicate(fileHash, currentUserId);
        
        if (isDuplicate) {
          // لو مكررة هنوقف كل حاجة ونطلع الإيرور
          emit(AddItemError(message: "This item is already in your wardrobe! 🚫"));
          return; 
        }

        // 2. رفع الصورة لـ Cloudinary (نفس الكود القديم بتاعك)
        final url = Uri.parse('${ApiConstants.cloudinaryBaseUrl}${ApiConstants.cloudName}${ApiConstants.imageUploadEndpoint}');
        final request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = ApiConstants.uploadPreset
          ..fields['folder'] = '${ApiConstants.wardrobeFolder}/$currentUserId'
          ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

        final response = await request.send();
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);

        if (response.statusCode == 200) {
          final jsonMap = jsonDecode(responseString);
          imageUrl = jsonMap['secure_url'];
        } else {
          throw Exception("Upload failed");
        }
      }

      // 3. تجهيز الداتا للحفظ (متنسيش تمرري البصمة)
      final item = ClothingItem(
        id: '',
        userId: currentUserId,
        category: category,
        color: color,
        styles: styles,
        seasons: seasons,
        imageUrl: imageUrl,
        imageHash: fileHash, // 🆕 حفظ البصمة في الموديل
        lastWornDays: 10,
        name: 'New Item',
      );

      final result = await _wardrobeRepo.addItem(item);

      result.fold(
        (error) => emit(AddItemError(message: error)),
        (_) => emit(AddItemSuccess()),
      );
    } catch (e) {
      if (!isClosed) emit(AddItemError(message: 'Error: ${e.toString()}'));
    }
  }
}
