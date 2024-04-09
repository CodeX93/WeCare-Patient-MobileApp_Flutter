// MedicalRecordScreen.dart
import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';
import 'package:wecare_patient_mobile/Widgets/ProfileCard.dart';

import 'MedicalRecordSection.dart'; // Ensure this import is correct

class MedicalRecordScreen extends StatelessWidget {
  const MedicalRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomScreenAppBar(title: 'Medical Records'),
      body: Column(
        children: <Widget>[

          // ... Your ProfileCard and other widgets
          MedicalRecordSectionTile(
            title: 'Prescriptions',
            icon: Icons.description,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MedicalRecordSection(recordType: 'Prescriptions'),
                ),
              );
            },
          ),
          MedicalRecordSectionTile(
            title: 'Lab Tests',
            icon: Icons.biotech,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MedicalRecordSection(recordType: 'Lab Tests'),
                ),
              );
            },
          ),
          MedicalRecordSectionTile(
            title: 'Surgical Records',
            icon: Icons.healing,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MedicalRecordSection(recordType: 'Surgical Records'),
                ),
              );
            },
          ),
          // ... Repeat for other sections
        ],
      ),
      // ... Your floating action button
    );
  }
}

class MedicalRecordSectionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MedicalRecordSectionTile(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon,
            color: Theme.of(context)
                .colorScheme
                .secondary), // Color can be adjusted
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
