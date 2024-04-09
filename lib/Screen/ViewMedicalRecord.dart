import 'package:flutter/material.dart';

class ViewMedicalRecordScreen extends StatelessWidget {
  final Map<String, dynamic> recordData;

  const ViewMedicalRecordScreen({Key? key, required this.recordData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if prescriptions data is available
    bool hasPrescriptions = recordData.containsKey('medicines') && (recordData['medicines'] as List).isNotEmpty;
    // Check if fileUrl for an image is available
    bool hasImage = recordData['fileUrl'] != null && recordData['fileUrl'].isNotEmpty;
print(recordData['fileUrl']);
    return Scaffold(
      appBar: AppBar(
        title: Text(recordData['recordTitle'] ?? 'Medical Record'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${recordData['date']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Comments: ${recordData['comments'] ?? 'None'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              if (hasPrescriptions) ...[
                Text('Prescriptions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...recordData['medicines'].map((medicine) {
                  return Card(
                    child: ListTile(
                      title: Text(medicine['medicineName']),
                      subtitle: Text('Dosage: ${medicine['dosage']}\nDuration: ${medicine['duration']}\nComplaint: ${medicine['complaint']}'),
                    ),
                  );
                }).toList(),
              ],

              // Display image if available
              if (hasImage)
                Image.network(recordData['fileUrl'], fit: BoxFit.cover),

              // Display a message if no prescription details or image is available
              if (!hasPrescriptions && !hasImage)
                Text('No prescription details or image available.', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
