import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/Appointment.dart';
import '../Screen/AppointmentDetailScreen.dart';
import '../Util/constant.dart';
import '../Widgets/CustomScreenAppBar.dart';

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> fetchAppointments(String patientId) async {
    final url =
    Uri.parse('http://${Constant.IP}:3067/appointment/allpappointment');
    final Map<String, String> body = {'patientId': patientId};

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: <String, String>{'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> appointmentData = data['appointments'];

        // Update appointments list with received data
        setState(() {
          appointments = appointmentData
              .map((appointment) => Appointment.fromJson(appointment))
              .toList();
        });
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch appointments: $e');
      // Handle the error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomScreenAppBar(
        title: 'My Appointments',
      ),
      body: appointments.isEmpty
          ? Center(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[Image.asset(
              'assets/images/no-appointment.png', // Change this to your image path
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
                const Text("You do not have any appointments")
                ]),
          )
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      AssetImage('assets/images/doctor-avatar.png'),
                    ),
                    title: Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${appointment.department}\n${appointment.date}\n${appointment.slot}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: appointment.type == "Online"
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.dialer_sip, color: Colors.teal),
                          onPressed: () {
                            // TODO: Implement video call action
                          },
                        ),
                      ],
                    )
                        : Icon(Icons.arrow_forward),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailScreen(
                            DoctorImage: appointment.profileImage,
                            DoctorName: appointment.doctorName,
                            fee: appointment.fee,
                            DoctorDeparment: appointment.department,
                            AppointmentDate: appointment.date,
                            AppointmentTime: appointment.slot,
                            CallingId: appointment.meetingLink,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
