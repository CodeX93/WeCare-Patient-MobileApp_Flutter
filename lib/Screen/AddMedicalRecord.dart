import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../Util/constant.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  final String initialRecordType;

  const AddMedicalRecordScreen({Key? key, required this.initialRecordType}) : super(key: key);

  @override
  _AddMedicalRecordScreenState createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _recordType;
  DateTime _selectedDate = DateTime.now();
  File? _selectedFile;
  bool _isFileUploadingEnabled = true; // This is the switch state
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  List<PrescriptionMedicine> _prescriptions = [PrescriptionMedicine()];

  @override
  void initState() {
    super.initState();
    _recordType = widget.initialRecordType;
  }

  Future<void> _selectFile() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  void _addPrescriptionField() {
    setState(() {
      _prescriptions.add(PrescriptionMedicine());
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  void _uploadAndSaveRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    String apiUrl;

    if (_isFileUploadingEnabled) {
      // If file uploading is enabled, determine the API URL based on the presence of a file
      if (_selectedFile == null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a file')));
        return;
      } else {
        apiUrl = 'http://${Constant.IP}:4001/medicalrecord/medical-record/without-prescription';
      }
    } else {
      apiUrl = 'http://${Constant.IP}:4001/medicalrecord/medical-record/with-prescription';
    }

    try {
      // Construct the request body
      final recordData = {
        'comments': _commentsController.text.trim(),
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'isVisibleToDoctor': true,
        'patientId': FirebaseAuth.instance.currentUser?.uid,
        'recordTitle': _titleController.text.trim(),
        'recordType': _recordType,
        'prescription': _prescriptions.map((prescription) => prescription.toJson()).toList(),
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(recordData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Record saved successfully
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record saved successfully')));
        Navigator.pop(context);
      } else {
        // Error saving record
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saving Failed')));
      }
    } catch (e) {
      // Handle any error that occurs during the request
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save record')));
    }

    setState(() => _isLoading = false);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Medical Record')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Record Type'),
                value: _recordType ?? widget.initialRecordType,
                onChanged: (String? newValue) {
                  setState(() {
                    _recordType = newValue;
                    _selectedFile = null; // Reset file selection when changing record type
                    _isFileUploadingEnabled = newValue != 'Prescriptions'; // Automatically disable file uploading for prescriptions
                  });
                },
                items: ['Prescriptions', 'Lab Tests', 'Blood Tests', 'Surgical Records']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (_recordType == 'Prescriptions')
                SwitchListTile(
                  title: Text('File Uploading Enabled'),
                  value: _isFileUploadingEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isFileUploadingEnabled = value;
                    });
                  },
                ),
              if (!_isFileUploadingEnabled)
                ..._prescriptions.map((prescription) => PrescriptionForm(prescription: prescription, onDelete: () => setState(() => _prescriptions.remove(prescription)))),
              if (!_isFileUploadingEnabled)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _addPrescriptionField,
                    child: Text('Add Another Medicine'),
                  ),
                ),
              if (_isFileUploadingEnabled)
                ElevatedButton(
                  onPressed: _selectFile,
                  child: Text('Select File'),
                ),
              if (_selectedFile != null && _isFileUploadingEnabled)
                Text('Selected file: ${path.basename(_selectedFile!.path)}'),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(),
                child: Text('Select Date'),
              ),
              TextFormField(
                controller: _commentsController,
                decoration: InputDecoration(labelText: 'Comments (Optional)'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadAndSaveRecord,
                child: Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrescriptionMedicine {
  String medicineName;
  String complaint;
  String duration;
  String dosage;

  PrescriptionMedicine({
    this.medicineName = '',
    this.complaint = '',
    this.duration = '',
    this.dosage = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'complaint': complaint,
      'duration': duration,
      'dosage': dosage,
    };
  }
}

class PrescriptionForm extends StatelessWidget {
  final PrescriptionMedicine prescription;
  final VoidCallback onDelete;

  const PrescriptionForm({Key? key, required this.prescription, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: prescription.medicineName,
          decoration: InputDecoration(labelText: 'Medicine Name'),
          onChanged: (value) => prescription.medicineName = value,
          validator: (value) => value!.isEmpty ? 'Please enter a medicine name' : null,
        ),
        TextFormField(
          initialValue: prescription.complaint,
          decoration: InputDecoration(labelText: 'Complaint'),
          onChanged: (value) => prescription.complaint = value,
          validator: (value) => value!.isEmpty ? 'Please enter a complaint' : null,
        ),
        TextFormField(
          initialValue: prescription.duration,
          decoration: InputDecoration(labelText: 'Duration'),
          onChanged: (value) => prescription.duration = value,
          validator: (value) => value!.isEmpty ? 'Please enter a duration' : null,
        ),
        TextFormField(
          initialValue: prescription.dosage,
          decoration: InputDecoration(labelText: 'Dosage'),
          onChanged: (value) => prescription.dosage = value,
          validator: (value) => value!.isEmpty ? 'Please enter a dosage' : null,
        ),
        IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
      ],
    );
  }
}
