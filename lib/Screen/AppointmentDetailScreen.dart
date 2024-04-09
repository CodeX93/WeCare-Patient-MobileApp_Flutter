import 'package:daily_flutter/daily_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

import 'CallingScreen.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String DoctorImage;
  final String DoctorName;
  final String DoctorDeparment;
  final String AppointmentDate;
  final String AppointmentTime;
  final String CallingId;
  final int fee;

  const AppointmentDetailScreen({
    Key? key,
    required this.DoctorImage,
    required this.CallingId,
    required this.DoctorName,
    required this.fee,
    required this.DoctorDeparment,
    required this.AppointmentDate,
    required this.AppointmentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the date and time
    // final String formattedDate =
    //     DateFormat('MMM dd, yyyy').format(AppointmentDate);
    // final String formattedTime = DateFormat('hh:mm a').format(AppointmentTime);

    return Scaffold(
      appBar: const CustomScreenAppBar(
        title: 'Appointment Details',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool check = CallingId=="";
          print("moving to calling Screen");
          final client = await CallClient.create();
          if (check) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallingScreen(
                  client: client,
                  callingId: CallingId,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Yours appointment is not Online')),
            );
          }
        },
        child: Icon(Icons.dialer_sip_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/doctor-avatar.png'),
            ),
            const SizedBox(height: 16),
            Text(
              DoctorName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Department of $DoctorDeparment',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Fee $fee',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading:
                  Icon(Icons.date_range, color: Theme.of(context).primaryColor),
              title: const Text('Date'),
              subtitle: Text(AppointmentDate.toString()),
            ),
            ListTile(
              leading: Icon(Icons.access_time,
                  color: Theme.of(context).primaryColor),
              title: const Text('Time'),
              subtitle: Text(AppointmentTime),
            ),
            const Spacer(),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: Colors.white,
            //     backgroundColor: Colors.red, // Text Color (Foreground color)
            //   ),
            //   onPressed: () {
            //     // TODO: Implement cancellation
            //   },
            //   child: const Text('CANCEL APPOINTMENT'),
            // ),
          ],
        ),
      ),
    );
  }
}
