import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_wear/Core/Constants/api_constants.dart';
import 'package:soft_wear/Core/Constants/firebase_constants.dart';
import 'package:soft_wear/Core/Networking/firebase/firebase_auth_service.dart';
import 'package:soft_wear/Core/Networking/firebase/firestore_service.dart';
import 'package:soft_wear/Features/Auth/Data/Models/user_model.dart';
import 'package:soft_wear/Features/Auth/Data/Repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepo _authRepo = AuthRepo();
  
  UserModel? currentUserModel;
  XFile? pickedProfileImage;
  final ImagePicker _picker = ImagePicker();

  /// Handles user registration and caches the city locally[cite: 23]
  Future<void> signUpFunction({
    required String email,
    required String password,
    required String name,
    required String city,
  }) async {
    emit(AuthLoading()); 

    final result = await _authRepo.signUp(
      email: email,
      password: password,
      name: name,
      city: city,
    );

    result.fold(
      (error) {
        if (!isClosed) emit(AuthError(message: error)); 
      },
      (user) async { 
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_city', city);
        if (!isClosed) emit(AuthSuccess()); 
      },
    );
  }

  /// Handles user login and retrieves saved city from Firestore[cite: 23]
  Future<void> loginFunction({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _authRepo.login(email: email, password: password);

    result.fold(
      (error) {
        if (!isClosed) emit(AuthError(message: error));
      },
      (user) async { 
        try {
          final currentUser = FirebaseAuthService.getCurrentUser();
          if (currentUser != null) {
            final data = await FirestoreService.getDocument(
              collectionName: FirebaseConstants.usersCollection,
              docId: currentUser.uid,
            );
            
            if (data != null && data.containsKey('city')) {
              final String userCity = data['city'];
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('saved_city', userCity);
            }
          }
        } catch (e) {
          print("Error fetching city during login: $e");
        }

        if (!isClosed) emit(AuthSuccess());
      },
    );
  }

  /// Triggers a password reset email[cite: 23]
  Future<void> resetPasswordFunction({required String email}) async {
    emit(AuthLoading());
    final result = await _authRepo.resetPassword(email: email);

    result.fold(
      (error) {
        if (!isClosed) emit(AuthError(message: error));
      },
      (_) {
        if (!isClosed) emit(AuthSuccess());
      },
    );
  }

  /// Logs the user out and clears local preferences[cite: 23]
  Future<void> logOut() async {
    await FirebaseAuthService.logOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    // 🚀 تفريغ البيانات القديمة عشان اليوزر الجديد ميشوفهاش
    currentUserModel = null; 
    pickedProfileImage = null; 
    
    if (!isClosed) emit(AuthInitial());
  }

  /// Fetches the user's profile details from Firestore[cite: 23]
  Future<void> getUserData() async {
    try {
      final user = FirebaseAuthService.getCurrentUser();
      
      if (user != null) {
        final data = await FirestoreService.getDocument(
          collectionName: FirebaseConstants.usersCollection,
          docId: user.uid,
        );

        if (data != null) {
          currentUserModel = UserModel.fromMap(data);
          
          if (currentUserModel!.name.isEmpty || currentUserModel!.email.isEmpty) {
            currentUserModel = UserModel(
              uId: user.uid,
              name: currentUserModel!.name.isNotEmpty ? currentUserModel!.name : (user.displayName ?? "My Profile"),
              email: currentUserModel!.email.isNotEmpty ? currentUserModel!.email : (user.email ?? "No Email"),
              city: currentUserModel!.city,
              profilePic: currentUserModel!.profilePic,
            );
          }
        } else {
          currentUserModel = UserModel(
            uId: user.uid,
            name: user.displayName ?? "My Profile",
            email: user.email ?? "No Email",
            city: "Unknown",
          );
        }
        
        if (!isClosed) emit(ProfileDataLoaded()); 
      }
    } catch (e) {
      if (!isClosed) emit(AuthError(message: e.toString()));
    }
  }

  /// Uploads image to Cloudinary and updates Firestore profile URL[cite: 23]
  Future<void> uploadAndChangeProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      emit(AuthLoading());
      
      // 🚀 إظهار الصورة فوراً لليوزر كـ Feedback سريع قبل الرفع
      pickedProfileImage = image; 
      emit(ProfileImageUpdated()); 

      final user = FirebaseAuthService.getCurrentUser();
      if (user == null) {
        emit(AuthError(message: "User not authenticated"));
        return;
      }

      final url = Uri.parse("${ApiConstants.cloudinaryBaseUrl}${ApiConstants.cloudName}${ApiConstants.imageUploadEndpoint}");
      var request = http.MultipartRequest("POST", url);
      request.fields['upload_preset'] = ApiConstants.uploadPreset;
      
      // 🚀 إنشاء فولدر منظم لصور البروفايل في Cloudinary عشان ميتلخبطوش مع الهدوم
      request.fields['folder'] = 'profile_pictures/${user.uid}'; 
      
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var jsonResponse = jsonDecode(responseString);

      if (response.statusCode == 200) {
        String uploadedImageUrl = jsonResponse['secure_url'];
        
        final result = await _authRepo.updateProfilePicture(uId: user.uid, imageUrl: uploadedImageUrl);
        
        result.fold(
          (error) => emit(AuthError(message: error)),
          (_) {
            // 🚀 تأمين الكود لو اليوزر موديل كان null لسبب ما
            if (currentUserModel != null) {
              currentUserModel = UserModel(
                uId: currentUserModel!.uId,
                name: currentUserModel!.name,
                email: currentUserModel!.email,
                city: currentUserModel!.city,
                profilePic: uploadedImageUrl,
              );
            } else {
              getUserData(); // نعمل Fetch من الأول
            }
            
            // 🚀 تفريغ الصورة المحلية عشان التطبيق يبدأ يستخدم الـ Network Image (الرابط الجديد)
            pickedProfileImage = null; 
            
            if (!isClosed) {
              emit(ProfileImageUpdated());
              emit(ProfileDataLoaded());
            }
          },
        );
      } else {
        pickedProfileImage = null; // مسح الصورة لو الرفع فشل
        if (!isClosed) {
          emit(AuthError(message: ApiConstants.errorUploadFailed));
          emit(ProfileDataLoaded());
        }
      }
    } catch (e) {
      pickedProfileImage = null;
      if (!isClosed) {
        emit(AuthError(message: e.toString()));
        emit(ProfileDataLoaded());
      }
    }
  }
  
  /// Selects an image from the device locally[cite: 23]
  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        pickedProfileImage = image;
        if (!isClosed) emit(ProfileImageUpdated());
      }
    } catch (e) {
      if (!isClosed) emit(AuthError(message: "Failed to pick image"));
    }
  }

  /// Updates user profile data (Name and City) in Firestore
  /// Updates user profile data (Name, City, and Image) in Firestore and Cloudinary
  Future<void> updateUserProfile({required String name, required String city}) async {
    // 1. نبدأ التحميل عشان زرار الحفظ يلف
    emit(AuthLoading());
    try {
      final user = FirebaseAuthService.getCurrentUser();
      
      // تأمين: لو مفيش يوزر، نطلع إيرور ونوقف عشان ميعلقش
      if (user == null) {
        emit(AuthError(message: "User not authenticated"));
        return;
      }

      String? newProfilePicUrl;

      // 2. 🚀 لو اليوزر اختار صورة جديدة، نرفعها الأول على كلاوديناري
      if (pickedProfileImage != null) {
        final url = Uri.parse("${ApiConstants.cloudinaryBaseUrl}${ApiConstants.cloudName}${ApiConstants.imageUploadEndpoint}");
        var request = http.MultipartRequest("POST", url);
        request.fields['upload_preset'] = ApiConstants.uploadPreset;
        request.fields['folder'] = 'profile_pictures/${user.uid}';
        request.files.add(await http.MultipartFile.fromPath('file', pickedProfileImage!.path));

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.toBytes();
          var jsonResponse = jsonDecode(String.fromCharCodes(responseData));
          newProfilePicUrl = jsonResponse['secure_url']; // أخدنا الرابط بنجاح
        } else {
          // لو الرفع فشل، نطلع إيرور ونوقف هنا بدل ما الشاشة تعلق
          emit(AuthError(message: "Failed to upload image. Please try again."));
          return; 
        }
      }

      // 3. 🚀 نجهز الداتا اللي هتتحدث في الفايربيز
      Map<String, dynamic> updatedData = {
        'name': name,
        'city': city,
      };
      
      // لو رفعنا صورة، نضيف الرابط الجديد للداتا
      if (newProfilePicUrl != null) {
        updatedData['profilePic'] = newProfilePicUrl;
      }

      // 4. نحدث الفايربيز[cite: 19]
      await FirestoreService.updateDocument(
        collectionName: FirebaseConstants.usersCollection,
        docId: user.uid,
        data: updatedData,
      );

      // 5. نحدث الموديل المحلي عشان البروفايل يسمع في نفس اللحظة
      if (currentUserModel != null) {
        currentUserModel = UserModel(
          uId: currentUserModel!.uId,
          name: name,
          email: currentUserModel!.email,
          city: city,
          profilePic: newProfilePicUrl ?? currentUserModel!.profilePic,
        );
      } else {
        await getUserData(); 
      }

      pickedProfileImage = null; 

      if (!isClosed) {
        emit(ProfileDataLoaded()); 
        emit(AuthSuccess()); 
      }
    } catch (e) {
      if (!isClosed) emit(AuthError(message: "Error updating profile: ${e.toString()}"));
    }
  }
}