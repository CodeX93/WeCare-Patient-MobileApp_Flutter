import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:wecare_patient_mobile/Screen/ScreenLayout.dart';
import 'package:wecare_patient_mobile/Screen/WelcomeOne.dart';


import 'package:firebase_core/firebase_core.dart';

import 'Functions/Firebase/AuthServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Stripe.publishableKey = dotenv.env['stripe_publishable_key']!;
  print(dotenv.env['stripe_publishable_key']!);
  // print(dotenv.env['stripe_secret_key']!);
  Stripe.publishableKey="pk_test_51OxWu1Hdm4ffwvcmi9EKQdEFRNwStMxm7rwGnN77iGXtg6uiYcbzZE8CafzhhiAR1lDgZC8momWK1IrVvqT7Fj0K00TCjCzH2y";
  await Stripe.instance.applySettings();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCnbRZ_iZPXSyAP_g-aQft0Cp7GGaewJ28",
              authDomain: "wecare-b2c6a.firebaseapp.com",
              projectId: "wecare-b2c6a",
              storageBucket: "wecare-b2c6a.appspot.com",
              messagingSenderId: "52371940980",
              appId: "1:52371940980:web:846422c4938f3be227d321"));
    } else {
      await Firebase.initializeApp();
    }

    AuthService authService = AuthService();
    await authService.initialize();

    runApp(MyApp(authService: authService));
  } catch (e) {
    print("Firebase initialization failed: $e");
    // Handle the error or display an error message in the app.
  }
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({required this.authService});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: authService.checkAuthState(), // Check authentication state
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while checking auth state
        } else {
          if (snapshot.data == true) {
            // User is authenticated, navigate to the home screen
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: ScreenLayout(), // Replace HomeScreen with your home screen widget
            );
          } else {
            // User is not authenticated, navigate to the welcome screen
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: WelcomeOne(),
            );
          }
        }
      },
    );
  }
}
