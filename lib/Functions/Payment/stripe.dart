import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../Screen/PaymentSuccess.dart';
import '../../Util/constant.dart';

class PaymentController extends GetxController {
  Future<void> makePayment(
      {required double amount,
      required String currency,
      required Map<String, dynamic> appointmentDetails}) async {
    try {
      var paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            merchantDisplayName: 'Your Merchant Name',
            customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
            paymentIntentClientSecret: paymentIntentData['clientSecret'],
            // Add other necessary parameters if needed
          ),
        );
        await displayPaymentSheet(
            appointmentDetails); // Pass the appointment details to the displayPaymentSheet method
      }
    } catch (e) {
      print('Error in makePayment: $e');
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      double amount, String currency) async {
    try {
      var response = await http.post(
        Uri.parse(
            'http://${Constant.IP}:4641/create-payment-intent'), // Adjust with your actual server URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'amount': calculateAmount(amount), 'currency': currency}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Handle response error
        print('Server error: ${response.body}');
        return null;
      }
    } catch (err) {
      print('Error creating payment intent: $err');
      // Handle or display error
      return null;
    }
  }

  Future<void> displayPaymentSheet(
      Map<String, dynamic> appointmentDetails) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // Show a success message to the user
      Get.snackbar(
        'Payment',
        'Payment Successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
      );

      // Here you post to Firebase using appointmentDetails
      await postAppointmentToFirebase(appointmentDetails);

      Get.offAll(() => PaymentSuccess());
    } on StripeException catch (e) {
      print('Stripe Exception: ${e.error.localizedMessage}');
    } catch (e) {
      print('Error displaying payment sheet: $e');
    }
  }

  Future<void> postAppointmentToFirebase(
      Map<String, dynamic> appointmentDetails) async {
    try {
      // Extracting appointment details
      var hospitalName = appointmentDetails['hospital']?? "";
      var doctorId = appointmentDetails[
          'doctorID']; // 'doctorID' should match the key in your appointmentDetails
      var doctorName = appointmentDetails['doctorName'];
      var department = appointmentDetails['department'];
      var slot = appointmentDetails['slot'];
      var date = appointmentDetails[
          'date']; // Assuming 'date' is already a properly formatted String
      var fee = appointmentDetails['fee'].toString();
      var complain = appointmentDetails['complain'];
      var patientId = appointmentDetails['patientId'];
      var slotId = appointmentDetails['slotId'];
      var patientName = appointmentDetails['patientFirstName'] +
          " " +
          appointmentDetails['patientLastName'];
      var profileImage = appointmentDetails['profileImage'];
      var meetingLink = appointmentDetails['meetingLink'] ?? "";
      var type = meetingLink != "" ? "Online" : "Physical";
      var email=appointmentDetails['email'];


    var appointmentData = {
        'hospital': hospitalName,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'department': department,
        'patientId': patientId,
        'slot': slot,
        'date': date, // Ensure Date is properly formatted as a string
        'fee': double.parse(fee).toInt(),
        'complain': complain,
        'slotId': slotId,
        'patientName': patientName,
        'profileImage': profileImage,
        'meetingLink':meetingLink,
        'type':type,
      'email':email

      };

      var url =
          Uri.parse('http://${Constant.IP}:3067/appointment/makeappointment');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(appointmentData), // Encode appointmentData to JSON
      );

      if (response.statusCode == 201) {
        updateSlotAvailability(doctorId, slotId);
        print('Appointment data posted successfully');
      } else {
        print('Error posting appointment data: ${response.statusCode}');
        // Handle or display error
      }
    } catch (e) {
      print('Error posting appointment data: $e');
      // Handle or display error
    }
  }

  void updateSlotAvailability(String doctorId, String slotId) async {
    try {
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "uniqueIdentifier": doctorId,
        "slotUuid": slotId,
        "newStatus": "Booked"
      };

      // Convert the request body to JSON
      String requestBodyJson = jsonEncode(requestBody);

      // Make the POST request
      final response = await http.post(
        Uri.parse('http://${Constant.IP}:5001/api/slots/updateAvailibility'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        // Request was successful
        print('Slot availability updated successfully');
      } else {
        // Request failed
        print(
            'Failed to update slot availability. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating slot availability: $e');
    }
  }

  String calculateAmount(double amount) {
    int amountInCents = (amount * 100).round();
    return amountInCents.toString();
  }
}
