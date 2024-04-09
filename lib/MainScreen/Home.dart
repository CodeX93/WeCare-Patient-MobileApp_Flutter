import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Functions/Firebase/LoginUser.dart';
import 'package:wecare_patient_mobile/Models/User.dart';

import '../Screen/BookAppointment.dart';
import '../Section/DepartmentSection.dart';
import '../Section/DoctorSection.dart';
import '../Section/FeelingIll.dart';
import '../Widgets/BookingCard.dart';
import '../Widgets/HomeAppBar.dart';
import '../Widgets/MyDrawer.dart';
import '../Widgets/WelcomeText.dart';
// Import your custom widgets...

class Home extends StatelessWidget {

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Patient?>(
      future: _loadCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          Patient? patient = snapshot.data;
          return _buildMainContent(context, patient);
        } else {
          return const Scaffold(
              body: Center(
                  child:
                      Text('Failed to load user data or no user logged in.')));
        }
      },
    );
  }

  Widget _buildMainContent(BuildContext context, Patient? patient) {
    return Scaffold(
      drawer: MyDrawer(
        Name: "${patient!.firstName} ${patient.lastName}" ?? 'Guest User', // Replace 'Default Name' with an actual default value
        ImageURI: patient?.profileImage ?? 'assets/default-profile.png', // Replace with a local asset or a default network image
        Email: FirebaseAuth.instance.currentUser?.email ?? 'no-email@example.com', // Provide a default email if it's null
      ),

      // Your custom drawer widget
      appBar: HomeAppBar(location: "${patient!.city} Pakistan"),
      // Your custom app bar widget
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 10),
            GreetingSearchBar(name: patient.lastName ?? 'Guest'),
            // Your custom greeting/search bar widget
            const SizedBox(height: 10),
            // BookingCard(
            //     onTap: () => {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) =>
            //                     const BookAppointment(), // Push the LoginScreen onto the stack
            //               )),
            //         } // Your custom booking card widget
            //     ),
            const SizedBox(height: 10),
            DepartmentSection(),
            // Your custom department section widget
            const SizedBox(height: 10),
            DoctorSection(),
            // Your custom doctor section widget
            const SizedBox(height: 10),
            // const SymptomsGrid(),
            // Your custom symptoms grid widget
            const SizedBox(height: 10),
            // Add any other widgets for your home screen here...
          ],
        ),
      ),
      // Include any other properties for your Scaffold here...
    );
  }

  Future<Patient?> _loadCurrentUser() async {
    LoginUser loginUser = LoginUser();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return await loginUser.fetchUserDetails(uid);
    } else {
      print("No user logged in.");
      return null;
    }
  }
}

// Placeholder for other custom widgets...
// Implement GreetingSearchBar, BookingCard, DepartmentSection, DoctorSection, SymptomsGrid accordingly.
