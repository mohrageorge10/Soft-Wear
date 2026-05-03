import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the currently logged-in user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Create a new user account with email and password
  static Future<UserCredential> signUp({
    required String email, 
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
  }

  // Authenticate an existing user with email and password
  static Future<UserCredential> login({
    required String email, 
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password,
    );
  }

  // Send a password reset link to the user's email
  static Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update the display name of the current user
  static Future<void> updateDisplayName({required String name}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
    }
  }

  // Delete the current user's account permanently
  static Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  // Sign out the current user
  static Future<void> logOut() async {
    await _auth.signOut();
  }
}