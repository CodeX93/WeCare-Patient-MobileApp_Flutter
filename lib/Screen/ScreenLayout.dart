import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/MainScreen/MyAppointment.dart';
import 'package:wecare_patient_mobile/MainScreen/MyVitalSigns.dart';
import 'package:wecare_patient_mobile/Screen/VitalSigns.dart';


import '../MainScreen/Home.dart';
import '../MainScreen/MyChats.dart';
import 'Intake.dart';

// import 'package:untitled/Screen/HomeScreen.dart';
// import 'package:untitled/Screen/VitalSignsScreen.dart';
// import 'package:untitled/Screen/AppointmentsScreen.dart';
// import 'package:untitled/Screen/ChatScreen.dart';
// import 'package:untitled/Screen/AccountScreen.dart';

class ScreenLayout extends StatefulWidget {
  const ScreenLayout({super.key});

  @override
  State<ScreenLayout> createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
  }

  void onNavBarTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children:  [
          // Replace with your actual screen widgets

          Center(child: Home()),
          Center(child: MyVitalSigns()),
          Center(child: MyAppointmentScreen()),
          Center(child: MedicineIntakeScreen()),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onNavBarTapped,
        currentIndex: currentPage,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Icon for vital signs
            label: 'Vital',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range), // Icon for appointments
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add_outlined), // Icon for chat
            label: 'Todo',
          ),

        ],
      ),
    );
  }
}
