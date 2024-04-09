import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../Functions/Firebase/PatientService.dart';
import '../Section/AppointmentDetails.dart';
import '../Section/AvailablitySection.dart';
import '../Widgets/CustomScreenAppBar.dart';
import 'Checkout.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String doctorUniqueIdentifier;
  final String doctorDepartment;

  const AppointmentScreen({
    Key? key,
    required this.doctorName,
    required this.doctorUniqueIdentifier,
    required this.doctorDepartment,
  }) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedSlot = '';
  String selectedSlotUuid = ''; // Add selectedSlotUuid
  DateTime selectedDate = DateTime.now();
  TextEditingController complaintController = TextEditingController();
  String patientFirstName = '';
  String patientLastName = '';
  String patientProfileImage = '';
  String hospitalName='';
  int price = 0;
  String meetingLink='';


  void _onSlotSelected(String slot, String uuid, int fee,String hospital,String meetLink) {
    setState(() {
      selectedSlot = slot;
      selectedSlotUuid = uuid; // Update selectedSlotUuid
      price = fee; // Update price
      hospitalName=hospital;
      meetingLink=meetLink;
    });
  }

  void _onPriceSelected(int value) {
    setState(() {
      price = value;
    });
  }
  Future<void> _fetchPatientData(String uid) async {
    final patientData = await PatientService.fetchPatientData(uid);
    setState(() {
      patientFirstName = patientData['firstName'] ?? '';
      patientLastName = patientData['lastName'] ?? '';
      patientProfileImage = patientData['profileImage'] ?? '';
    });
    print(patientData);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPatientData(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomScreenAppBar(
        title: 'Make Appointment Now',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                AvailableSlotsSection(
                  doctorId: widget.doctorUniqueIdentifier,
                  onSlotSelected: _onSlotSelected,
                  onPriceSelected: _onPriceSelected,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: complaintController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      labelText: 'Complain',
                      hintText: 'What\'s the issue?',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: BookingDetailsCard(
                    doctorName: widget.doctorName,
                    doctorDepartment: widget.doctorDepartment,
                    slot: selectedSlot,
                    fee: price.toString(),
                    complain: complaintController.text,
                    date: selectedDate,
                    SlotUuid: selectedSlotUuid,
                    HospitalName:hospitalName,
                    patientName: patientFirstName+" "+ patientLastName,
                    patientProfileImage: patientProfileImage,
                    doctorId: widget.doctorUniqueIdentifier,
                    onBook: () {
                      if (selectedSlot.isNotEmpty) {
                        if (selectedDate != DateTime.now()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Checkout(
                                HospitalName:hospitalName,
                                DoctorId: widget.doctorUniqueIdentifier,
                                Department: widget.doctorDepartment,
                                Slot: selectedSlot,
                                SlotUuid: selectedSlotUuid, // Pass selectedSlotUuid
                                Date: selectedDate,
                                Fee: price.toDouble(),
                                Complain: complaintController.text,
                                PatientId: FirebaseAuth.instance.currentUser!.uid,
                                DoctorName: widget.doctorName,
                                patientFirstName: patientFirstName,
                                patientLastName: patientLastName,
                                patientProfileImage: patientProfileImage,
                                appointmentLink: meetingLink,
                                email: FirebaseAuth.instance.currentUser?.email ?? "",

                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a date.'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a slot.'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
