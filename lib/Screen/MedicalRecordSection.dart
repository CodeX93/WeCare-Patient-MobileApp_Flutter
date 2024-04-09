import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:wecare_patient_mobile/Screen/AddMedicalRecord.dart';
import 'package:wecare_patient_mobile/Util/constant.dart';
import 'package:wecare_patient_mobile/Widgets/CustomScreenAppBar.dart';

import 'ViewMedicalRecord.dart';

class MedicalRecordSection extends StatefulWidget {
  final String recordType;

  const MedicalRecordSection({Key? key, required this.recordType})
      : super(key: key);

  @override
  State<MedicalRecordSection> createState() => _MedicalRecordSectionState();
}

class _MedicalRecordSectionState extends State<MedicalRecordSection> {
  bool _updatingVisibility = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    try {
      // Get the current user's UUID
      String? userUUID = FirebaseAuth.instance.currentUser?.uid;

      if (userUUID != null) {
        // Prepare the request body
        var requestBody = {
          'patientId': userUUID,
        };

        // Make the POST request
        final response = await http.post(
          Uri.parse('http://${Constant.IP}:4001/medicalrecord/medical-record/'),
          body: json.encode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          // Parse the response body
          var data = json.decode(response.body);

          // Extract medical records from the response
          List<Map<String, dynamic>> medicalRecords =
              List<Map<String, dynamic>>.from(data['medicalRecords']);

          // Update the UI with the fetched medical records
          setState(() {
            records = medicalRecords;
          });
        } else {
          // Handle unsuccessful request
          print('Failed to fetch records: ${response.reasonPhrase}');
          // Optionally clear the records list or handle the UI accordingly
          setState(() {
            records = [];
          });
        }
      } else {
        // Handle the case where there is no logged-in user
        print('No user logged in');
        // Optionally clear the records list or handle the UI accordingly
        setState(() {
          records = [];
        });
      }
    } catch (error) {
      // Handle errors
      print('Error fetching records: $error');
      // Optionally clear the records list or handle the UI accordingly
      setState(() {
        records = [];
      });
    }
  }

  Future<String?> pickFile() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  Future<void> uploadFileAndPostRecord(
      String filePath, Map<String, dynamic> recordDetails) async {
    try {
      String fileName = Path.basename(filePath);
      var fileRef = _storage.ref('medicalRecords/$fileName');
      await fileRef.putFile(File(filePath));
      String fileUrl = await fileRef.getDownloadURL();
      var finalRecordDetails = {
        ...recordDetails,
        'fileUrl': fileUrl,
        'recordType': widget.recordType,
      };
      await _firestore.collection('medicalRecords').add(finalRecordDetails);
      print('Record added successfully');
      fetchRecords(); // Refresh records after adding
    } catch (e) {
      print('Error uploading file and posting record: $e');
    }
  }

  bool _isRecordVisible(String value) {
    // Define the value that indicates true
    final trueValue = 'true';
    // Check if the value is equal to the true value
    return value == trueValue;
  }

  String _toggleVisibility(String value) {
    // Define the value that indicates true
    final trueValue = 'true';
    // Toggle the value
    return value == trueValue ? 'false' : 'true';
  }

  void _addRecord() async {
    // Navigate directly to AddMedicalRecordScreen when the floating action button is pressed
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicalRecordScreen(
          initialRecordType: widget.recordType,

        ),
      ),

    );

    // Check if a result (new record details) was returned from AddMedicalRecordScreen
    if (result != null) {
      // If a file path is part of the result, handle file upload and record posting
      if (result.containsKey('filePath')) {
        String filePath = result['filePath'];
        await uploadFileAndPostRecord(filePath, result);
      } else {
        // If no file needs to be uploaded, directly post the record details (useful for manual prescriptions)
        await _firestore.collection('medicalRecords').add(result);
        print('Record added successfully');
        setState(() {
          fetchRecords(); // Refresh records after adding
        });

      }
    }
  }

  Future<void> _updateVisibility(String id) async {
    setState(() {
      _updatingVisibility = true; // Set the flag to true to show progress indicator
    });

    try {
      // API endpoint URL
      final url = Uri.parse('http://${Constant.IP}:4001/medicalrecord/updateVisiblity');

      // Request body containing the id
      final requestBody = jsonEncode({'id': id});

      // Make the POST request
      final response = await http.post(
        url,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Request successful
        print('Visibility updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Visibility is updated successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green, // Green color for success
          ),
        );
        setState(() {
          _updatingVisibility = false;
          fetchRecords();
        });
      } else {
        // Request failed
        print('Failed to update visibility: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error changing the Visibility',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, // Red color for error
          ),
        );
        setState(() {
          _updatingVisibility = false;
        });
      }
    } catch (error) {
      // Handle errors
      print('Error updating visibility: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating visibility',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red, // Red color for error
        ),
      );
      setState(() {
        _updatingVisibility = false;
      });
    }
  }


  Future<void> deleteMedicalRecordById(String id) async {
    try {
      // API endpoint URL
      final url = Uri.parse('http://${Constant.IP}:4001/medicalrecord/delete');

      // Request body containing the id
      final requestBody = jsonEncode({'id': id});

      // Make the POST request
      final response = await http.post(
        url,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Request successful
        print('Medical record deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Record deleted successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green, // Green color for success
          ),
        );
        setState(() {
          fetchRecords();
        });
      } else {
        // Request failed
        print('Failed to delete medical record: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.reasonPhrase.toString(),
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, // Green color for success
          ),
        );
      }
    } catch (error) {
      // Handle errors
      print('Error deleting medical record: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter records based on recordType
    List<Map<String, dynamic>> filteredRecords = records
        .where((record) => record['recordType'] == widget.recordType)
        .toList();

    return Scaffold(
      appBar: CustomScreenAppBar(
        title: widget.recordType,
      ),
      body: Stack(

        children: [
          if (filteredRecords
              .isNotEmpty) // Render only if there are filtered records
            ListView.builder(
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                var record = filteredRecords[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.document_scanner),
                    title: Text(record['recordTitle'] ?? 'No Title'),
                    subtitle: Text(record['date'] ?? 'No Date'),
                    onTap: () {
                      // Navigate to ViewMedicalRecordScreen with the selected record's data
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewMedicalRecordScreen(recordData: record),
                      ));
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(record['isVisibleToDoctor']
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () async {
                            _updateVisibility(record['id']);
                            // Refresh records after updating visibility
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            deleteMedicalRecordById(record['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          if (filteredRecords
              .isEmpty) // Render only if there are no filtered records
            Center(
              child: Column(
                children: [
                 Image.asset('assets/images/welcome1.png'),
                  Text(
                    'You do not have records,',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\nAdd Today',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          if (_updatingVisibility)
            Center(
              child: CircularProgressIndicator(), // Show progress indicator
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecord,
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
