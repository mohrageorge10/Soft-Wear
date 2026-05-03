import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Core/Constants/firebase_constants.dart';
import 'package:soft_wear/Core/Networking/firebase/firebase_auth_service.dart';
import 'package:soft_wear/Core/Networking/firebase/firestore_service.dart';
import 'package:soft_wear/Features/Auth/Data/Models/user_model.dart';


class AuthRepo {
  
  /// Registers a new user and saves their data in Firestore
  Future<Either<String, UserCredential>> signUp({
    required String name, 
    required String email,
    required String password,
    required String city, 
  }) async {
    try {
      final credential = await FirebaseAuthService.signUp(
        email: email,
        password: password,
      );
      
      UserModel userModel = UserModel(
        uId: credential.user!.uid, 
        name: name,
        email: email,
        city: city,
      );

      await FirestoreService.setDocument(
        collectionName: FirebaseConstants.usersCollection,
        docId: credential.user!.uid,
        data: userModel.toMap(),
      );

      return Right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const Left(AppStrings.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        return const Left(AppStrings.emailInUse);
      } else {
        return Left(e.message ?? AppStrings.authFailed);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Authenticates an existing user
  Future<Either<String, UserCredential>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuthService.login(
        email: email,
        password: password,
      );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left(AppStrings.userNotFound);
      } else if (e.code == 'wrong-password') {
        return const Left(AppStrings.wrongPassword);
      } else if (e.code == 'invalid-credential') {
        return const Left(AppStrings.invalidCredential);
      } else {
        return Left(e.message ?? AppStrings.loginFailed);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Sends a password reset link to the provided email
  Future<Either<String, void>> resetPassword({required String email}) async {
    try {
      await FirebaseAuthService.resetPassword(email: email);
      return const Right(null); 
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left(AppStrings.userNotFound);
      } else {
        return Left(e.message ?? AppStrings.resetEmailFailed);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Updates the user's profile picture URL in Firestore
  Future<Either<String, void>> updateProfilePicture({required String uId, required String imageUrl}) async {
    try {
      await FirestoreService.updateDocument(
        collectionName: FirebaseConstants.usersCollection,
        docId: uId,
        data: {'profilePic': imageUrl},
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}