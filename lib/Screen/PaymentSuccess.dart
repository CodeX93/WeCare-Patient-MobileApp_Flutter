import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

import 'ScreenLayout.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomScreenAppBar(title: 'Back to Home', onBackTap: (){},),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center the children vertically
      crossAxisAlignment: CrossAxisAlignment.center, // Center children horizontally
      children: [
        Image.asset('assets/images/appointment_success.png'),
        SizedBox(height: 20), // Add some space between the image and text
        Text(
          'Your payment is successfully made',
          style: TextStyle(
            fontSize: 18, // Example text size, adjust as needed
            fontWeight: FontWeight.bold, // Example text weight
            // Add more styling as needed
          ),
          textAlign: TextAlign.center, // Center the text if it's multiline
        ),
        SizedBox(height: 20), // Add some space between the image and text
        ElevatedButton(onPressed: (){
          Navigator.pushReplacement( // Use pushReplacement to replace the login screen
            context,
            MaterialPageRoute(builder: (context) => const ScreenLayout()),
          );

        }, child: Text('Move to Home Screen')),
      ],
    ),

    );
  }
}
