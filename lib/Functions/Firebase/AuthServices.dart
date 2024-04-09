import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize Firebase authentication
  Future<void> initialize() async {
    if (kIsWeb) {
      // If the platform is web-based, set persistence to local
      await _auth.setPersistence(Persistence.LOCAL);
    } else {
      // For non-web platforms, initialize Firebase without setting persistence
      await Firebase.initializeApp();
    }
  }

  // Send a password reset email to the user's email address
  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent successfully';
    } catch (e) {
      return e.toString();
    }
  }

  // Check the current authentication state
  Future<bool> checkAuthState() async {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  // Sign in with email and password
  Future<String> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Login Success';
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
