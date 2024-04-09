import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/MainScreen/MyProfile.dart';
import 'package:wecare_patient_mobile/Screen/ContactUs.dart';
import 'package:wecare_patient_mobile/Screen/Login.dart';
import 'package:wecare_patient_mobile/Screen/MedicalRecord.dart';

import '../Screen/Intake.dart';

class MyDrawer extends StatelessWidget {
  final String Name, ImageURI, Email;

  const MyDrawer(
      {Key? key,
      required this.Name,
      required this.ImageURI,
      required this.Email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    Name, // Use the Name parameter directly
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(Email),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(ImageURI),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check_box),
                  title: const Text('To do'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MedicineIntakeScreen()), // Push the LoginScreen onto the stack
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.record_voice_over),
                  title: const Text('Medical Records'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MedicalRecordScreen()), // Push the LoginScreen onto the stack
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text('Your Bills'),
                  onTap: () {
                    // Handle the action
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_support_outlined),
                  title: const Text('Contact Us'),
                  onTap: () {
                    // Handle the action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                           ContactUsScreen()), // Push the LoginScreen onto the stack
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ProfileScreen()), // Push the LoginScreen onto the stack
                    );
                  },
                ),
              ],
            ),
          ),
          // Logout button at the bottom of the drawer
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Handle the log out action
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ).then((_) => Navigator.popUntil(context, (route) => route.isFirst));

            },
          ),
        ],
      ),
    );
  }
}
