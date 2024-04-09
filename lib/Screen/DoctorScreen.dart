import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Screen/AppointmentScreen.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

class DoctorScreen extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String imagePath;
final String DoctoruniqueIdentifier;
  final double fee;
  final String doctorAbout;

  const DoctorScreen({super.key,
    required this.doctorName,
    required this.DoctoruniqueIdentifier,
    required this.specialization,
    required this.imagePath,

    required this.fee,
    required this.doctorAbout,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final coverImageHeight = screenHeight * 0.2; // Adjust the height as needed
    final profileImageRadius =
        screenHeight * 0.1; // Adjust the radius as needed

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomScreenAppBar(title: doctorName),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(DoctoruniqueIdentifier);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentScreen(
                doctorName: doctorName,
                doctorDepartment: specialization,

                doctorUniqueIdentifier: DoctoruniqueIdentifier,
              ),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: coverImageHeight,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/green_cover.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: coverImageHeight - profileImageRadius,
                  child: CircleAvatar(
                    radius: profileImageRadius,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: profileImageRadius - 5,
                      backgroundImage: NetworkImage(imagePath),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: profileImageRadius + 20),
            // Space for the profile image
            Text(doctorName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(specialization,
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),




            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("About Doctor",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                textAlign: TextAlign.justify,
                doctorAbout,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            // Other widgets go here
          ],
        ),
      ),
    );
  }
}

class StarDisplay extends StatelessWidget {
  final int value;

  const StarDisplay({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < value ? Icons.star : Icons.star_border,
          color: index < value ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }
}
