import 'dart:convert' show utf8;


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

class ContactUsScreen extends StatelessWidget {
   ContactUsScreen({Key? key});

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomScreenAppBar(title: 'Contact Us'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/contact-us.png', height: 150),
              const SizedBox(height: 40),
              TextFormField(
                initialValue: FirebaseAuth.instance.currentUser?.email,
                decoration: InputDecoration(
                  labelText: 'Your Email',
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.email), // Added email icon
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Query',
                  hintText: 'Enter your query here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.question_answer), // Added query icon
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  sendEmail('wecareemrsystem345@gmail.com');
                },
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(48, 120, 103, 1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Or',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  callPhoneNumber('+921234567890');
                },
                icon: Icon(Icons.phone, color: Colors.white), // Added phone icon
                label: const Text(
                  'Call Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(48, 120, 103, 1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail(String email) async {
    final String subject = 'Query from WeCare App';
    final String body = messageController.text;

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject, 'body': body.toString()},
    );
    final String emailAddress = emailLaunchUri.toString();
    if (await canLaunch(emailAddress)) {
      await launch(emailAddress);
    } else {
      throw 'Could not launch $emailAddress';
    }
  }

  Future<void> callPhoneNumber(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
