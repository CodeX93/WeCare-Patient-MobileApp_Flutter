import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsCard extends StatelessWidget {
  final String doctorName;
  final String doctorDepartment;
  final String slot;
  final String fee;
  final String complain;
  final DateTime? date; // Change to DateTime?
  final String doctorId;
  final String SlotUuid;
  final VoidCallback onBook;
  final String patientName;
  final String HospitalName;
  final String patientProfileImage;

  const BookingDetailsCard({
    Key? key,
    required this.HospitalName,
    required this.doctorName,
    required this.doctorDepartment,
    required this.complain,
    required this.patientProfileImage,
    this.date, // Change to nullable DateTime
    required this.slot,
    required this.fee,
    required this.patientName,
    required this.onBook,
    required this.doctorId,
    required this.SlotUuid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
              'Doctor name: $doctorName',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Doctor department: $doctorDepartment',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Date:${DateFormat('MMM dd, yyyy').format(date!)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Slot: $slot',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Complain: $complain',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Fees: $fee',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'DoctorId: $doctorId',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'SLotId: $SlotUuid',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'patientName: $patientName',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'profile: $patientProfileImage',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal, // Text Color (Foreground color)
                ),
                child: const Text('BOOK APPOINTMENT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
