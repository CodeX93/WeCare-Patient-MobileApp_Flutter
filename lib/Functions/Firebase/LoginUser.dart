import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wecare_patient_mobile/Models/User.dart';

class LoginUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<String?> getCurrentUserName() async {
    String? user = FirebaseAuth.instance.currentUser?.displayName;
    return user;
  }

  Future<Patient?> fetchUserDetails(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        // Handling 'dob' as Timestamp or String
        DateTime dob;
        if (data['dob'] is Timestamp) {
          dob = (data['dob'] as Timestamp).toDate();
        } else if (data['dob'] is String) {
          String dobString = data['dob'];
          try {
            dob = DateTime.parse(dobString);
          } catch (e) {
            print("Error parsing date: $e");
            dob = DateTime.now(); // Default or error handling
          }
        } else {
          dob = DateTime
              .now(); // Default if 'dob' is missing or in an unexpected format
        }

        // Constructing the Patient object
        Patient userData = Patient(
          uid: uid,
          email: data['email'],
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          // email: data['email'] ?? '',
          bloodGroup: data['bloodGroup'] ?? '',
          city: data['city'] ?? '',
          contactNo: data['contactNo'] ?? '',
          displayName: data['displayName'] ?? '',
          dob: dob,
          // Properly parsed DateTime
          gender: data['gender'] ?? '',
          profileImage: data['profileImage'] ?? '',
          age: data['age'] ?? 0,
        );

        return userData;
      } else {
        print("No user found with UID: $uid");
        return null;
      }
    } catch (error) {
      print("Error fetching user details: $error");
      return null;
    }
  }
}
