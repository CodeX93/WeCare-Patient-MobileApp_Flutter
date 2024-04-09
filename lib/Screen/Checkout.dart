import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

import '../Functions/Payment/stripe.dart';

class Checkout extends StatelessWidget {
  final String DoctorName;
  final String Department;
  final String PatientId;
  final String email;
  final String Slot;
  final String Complain;
  final DateTime Date;
  final double Fee;
  final String DoctorId;
  final String SlotUuid;
  final String appointmentLink;
  final String patientFirstName;
  final String patientLastName;
  final String patientProfileImage;
  final String HospitalName;

  const Checkout({
    Key? key,
    required this.HospitalName,
    required this.email,
    required this.DoctorName,
    required this.appointmentLink,
    required this.Department,
    required this.SlotUuid,
    required this.Slot,
    required this.Date,
    required this.Fee,
    required this.DoctorId,
    required this.Complain,
    required this.PatientId,
    required this.patientFirstName,
    required this.patientLastName,
    required this.patientProfileImage,




  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());

    return Scaffold(
      appBar: const CustomScreenAppBar(
        title: 'Make Your Payment',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20), // Removed width: double.infinity
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Appointment details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hospital name: $HospitalName',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Doctor name: $DoctorName',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Patient name: $patientFirstName" $patientLastName',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Doctor department: $Department',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Slot: $Slot',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Fees: \$${Fee.toStringAsFixed(2)}',
                        // Corrected Fee display
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),


                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(children: [
                  paymentButton(context, 'Pay with Bank Cards', Colors.green,
                      Icons.payment, () {
                        paymentController.makePayment(
                            amount: Fee,
                            currency: 'USD',
                            appointmentDetails: {
                              'hospital':HospitalName,
                              'doctorID':DoctorId,
                              'doctorName': DoctorName,
                              'department': Department,
                              'slot': Slot,
                              'date': Date.toString(),
                              'fee': Fee,
                              'complain':Complain,
                              'email':email,
                              'patientId':PatientId,
                              'slotId':SlotUuid,
                              'patientFirstName':patientFirstName,
                              'patientLastName': patientLastName,
                              'profileImage':patientProfileImage,
                              'appointmentLink':appointmentLink,
                              // Include any other details you need
                            }
                        );

                  }),
                  paymentButton(
                    context,
                    'Pay with EasyPaisa',
                    Colors.green,
                    Icons.payment,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('EasyPaisa is not yet supported')));
                    },
                  ),
                  paymentButton(
                    context,
                    'Pay with JazzCash',
                    Colors.green,
                    Icons.payment,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('JazzCash is not yet Supported')));
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentButton(BuildContext context, String text, Color color,
      IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize:
              const Size(double.infinity, 50), // full width, height: 50
        ),
      ),
    );
  }
}
