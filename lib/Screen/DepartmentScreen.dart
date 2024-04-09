import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

class DepartmentScreen extends StatelessWidget {
  final String name;
  final int staffCount;
  final String phone;
  final String head;
  final String email;
  final String description;
  final String hospitalName;
 final String imageURL;

  const DepartmentScreen({
    Key? key,
    required this.name,
    required this.imageURL,
    required this.staffCount,
    required this.phone,
    required this.head,
    required this.email,
    required this.description,
    required this.hospitalName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final coverImageHeight = screenHeight * 0.2;
    final profileImageRadius = screenHeight * 0.1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomScreenAppBar(title: name),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to appointment screen
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.person_search, color: Colors.white),
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
                      backgroundImage: NetworkImage(imageURL),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: profileImageRadius + 20),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Head: $head',
              style:  TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text(
                'Hospital: $hospitalName',
                style:  TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Phone: $phone',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Staff Count: $staffCount',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
