import 'dart:io';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
   int age=0;
  Future<String> signUpAndUploadProfile({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dob,
    required String bloodGroup,
    required String city,
    required String contactNo,
    required File? profileImage,
  }) async {
    try {
      age=calculateAge(dob);
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );

      String profileImagePath = '';
      if (profileImage != null) {
        String fileName = 'profile_images/${userCredential.user!.uid}/${DateTime.now().millisecondsSinceEpoch}_${profileImage.path.split('/').last}';
        Reference ref = _storage.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(profileImage);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
        profileImagePath = await snapshot.ref.getDownloadURL();
      }




      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'email':email,
        'lastName': lastName,
        'gender': gender,
        'dob': dob.toIso8601String(),
        'bloodGroup': bloodGroup,
        'city': city,
        'contactNo': contactNo,
        'profileImage': profileImagePath,
        'age':age
      });

      return "Sign Up Success";
    } on FirebaseAuthException catch (authError) {
      return authError.message ?? "An error occurred during sign up.";
    } catch (error) {
      return "An unexpected error occurred.";
    }
  }

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to sign in the user with Firebase Authentication
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // If successful, return a success message
      return "Login Success";
    } on FirebaseAuthException catch (e) {
      // If Firebase throws an FirebaseAuthException, we catch it and return the message
      // This can be a wrong password, user not found, etc.
      print('Firebase Auth Error: ${e.message}');
      return e.message ?? "An error occurred during login.";
    } catch (e) {
      // Catch any other exceptions and return a generic error message
      print('Error during login: $e');
      return "An unexpected error occurred.";
    }
  }


  int calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }







}

