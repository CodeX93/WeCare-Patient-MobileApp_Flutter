import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../Models/Doctor.dart';
import '../Util/Filter.dart';
import '../Util/constant.dart';
import '../Widgets/CustomScreenAppBar.dart';
import '../Widgets/DoctorCard.dart';
import '../Widgets/DoctorFiltersBar.dart';
import 'DoctorScreen.dart';

class AllDoctor extends StatefulWidget {
  const AllDoctor({Key? key}) : super(key: key);

  @override
  State<AllDoctor> createState() => _AllDoctorState();
}

class _AllDoctorState extends State<AllDoctor> {
  List<Doctor> originalDoctors = [];
  List<Doctor> filteredDoctors = [];
  Filter currentFilter = Filter();

  @override
  void initState() {
    super.initState();
    // Fetch doctor data from the API
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    var logger = Logger();
    final url = Uri.parse('http://${Constant.IP}:5006/api/user/getAll');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          originalDoctors = data.map((item) => Doctor.fromJson(item)).toList();
          filteredDoctors = List.of(originalDoctors); // Initialize filteredDoctors with originalDoctors
        });
      } else {
        throw Exception('Failed to load doctor data');
      }
    } catch (error) {
      print('Error fetching doctors: $error');
    }
  }

  void applyFilters(Filter filter) {
    setState(() {
      filteredDoctors = originalDoctors.where((doctor) => filter.applyFilters(doctor)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomScreenAppBar(
        title: 'All Doctors',
      ),
      body: Column(
        children: [
          FilterBar(
            onFilterChanged: (Filter filter) {
              setState(() {
                currentFilter = filter;
                applyFilters(currentFilter);
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(
                  doctorName:
                  '${filteredDoctors[index].firstName} ${filteredDoctors[index].lastName}',
                  specialization: filteredDoctors[index].category,
                  imagePath: filteredDoctors[index].profilePic,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorScreen(
                          doctorName:
                          '${filteredDoctors[index].firstName} ${filteredDoctors[index].lastName}',
                          specialization: filteredDoctors[index].category,
                          imagePath: filteredDoctors[index].profilePic,
                          fee: 100,
                          doctorAbout: filteredDoctors[index].doctorAbout,
                          DoctoruniqueIdentifier: filteredDoctors[index].uniqueIdentifier,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
