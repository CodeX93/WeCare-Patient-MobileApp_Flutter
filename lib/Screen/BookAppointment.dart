import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wecare_patient_mobile/Util/constant.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({Key? key}) : super(key: key);

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  String selectedDepartment = '';
  String selectedDoctor = '';
  DateTime selectedDate = DateTime.now();
  TextEditingController complaintController = TextEditingController();
  List<dynamic> departments = [];
  List<dynamic> doctors = [];

  Future<void> _fetchDepartments() async {
    try {
      final response = await http.get(Uri.parse('http://${Constant.IP}:4010/api/Department/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          departments = responseData;
        });
      } else {
        throw Exception('Failed to fetch departments');
      }
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> _fetchDoctors(String department) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.18.18:5006/api/user/getAll'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final filteredDoctors = responseData.where((doctor) => doctor['doctorData']['category'] == department).toList();
        setState(() {
          doctors = filteredDoctors;
        });
      } else {
        throw Exception('Failed to fetch doctors');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Appointment Now'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  hint: Text('Select Department'),
                  value: selectedDepartment,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDepartment = newValue!;
                      selectedDoctor = '';
                      _fetchDoctors(selectedDepartment);
                    });
                  },
                  items: departments.map<DropdownMenuItem<String>>((dynamic department) {
                    return DropdownMenuItem<String>(
                      value: department['name'],
                      child: Text(department['name']),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  hint: Text('Select Doctor'),
                  value: selectedDoctor,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDoctor = newValue!;
                    });
                  },
                  items: doctors.map<DropdownMenuItem<String>>((dynamic doctor) {
                    final doctorData = doctor['doctorData'];
                    return DropdownMenuItem<String>(
                      value: doctorData['uniqueIdentifier'],
                      child: Text('${doctorData['firstName']} ${doctorData['lastName']}'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: complaintController,
                  decoration: InputDecoration(
                    hintText: 'Enter complaint',
                    labelText: 'Complaint',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Add functionality here to book the appointment
                  },
                  child: Text('Book Appointment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}