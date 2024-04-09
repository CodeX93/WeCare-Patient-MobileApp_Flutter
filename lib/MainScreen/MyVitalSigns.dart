//
// import 'package:flutter/material.dart';
// import 'package:heka_health/heka_health_widget.dart';
// import 'package:heka_health/utils.dart';
// import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';
//
// class MyVitalSigns extends StatefulWidget {
//   const MyVitalSigns({super.key});
//
//   @override
//   State<MyVitalSigns> createState() => _MyVitalSignsState();
// }
//
// class _MyVitalSignsState extends State<MyVitalSigns> {
//   static const _userUuid = 'testing-something-something';
//   final _apiKey = '06befb04-746b-4006-a3ba-56bdfb00449c';
//
//   @override
//   void initState() {
//     super.initState();
//     // Demonstrating how to check if a user is connected to a platform
//     // For Apple Healthkit, platformName is "apple_healthkit"
//     HekaManager.isUserConnected(
//             key: _apiKey, uuid: _userUuid, platformName: "google_fit")
//         .then((value) {
//       if (value) {
//         print("User is connected");
//       } else {
//         print("User is not connected");
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomScreenAppBar(
//         title: 'My Vital Signs',
//       ),
//       body: HekaHealthWidget(
//         apiKey: _apiKey,
//         userUuid: _userUuid,
//       ),
//     );
//   }
// }
