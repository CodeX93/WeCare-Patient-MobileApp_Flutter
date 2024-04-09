import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/Department.dart';
import '../Util/constant.dart';
import '../Widgets/DepartmentFilterBar.dart';
import '../Widgets/CustomScreenAppBar.dart';
import '../Widgets/CustomSearchBar.dart';
import '../Widgets/DepartmentCard.dart';
import '../Util/FilterDepartment.dart';
import 'DepartmentScreen.dart';

class AllDepartment extends StatefulWidget {
  const AllDepartment({Key? key}) : super(key: key);

  @override
  _AllDepartmentState createState() => _AllDepartmentState();
}

class _AllDepartmentState extends State<AllDepartment> {
  List<Department> departments = [];
  List<String> departmentsName=[];
  // List<Department> filteredDepartments = [];
  FilterDepartment filter = FilterDepartment();

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {
      final response = await http.get(Uri.parse('http://${Constant.IP}:4010/api/Department/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          departments = data.map((departmentData) => Department.fromJson(departmentData)).toList();
departmentsName=data.map((departmentData) => Department.fromJson(departmentData).name).toList();
        });
      } else {
        throw Exception('Failed to fetch department data');
      }
    } catch (e) {
      print('Error fetching department data: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomScreenAppBar(title: 'All Departments'),
      body: Column(
        children: [
       SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push( // Use pushReplacement to replace the login screen
                      context,
                      MaterialPageRoute(builder: (context) =>  DepartmentScreen(imageURL:departments[index].coverImageURL,name: departments[index].name, staffCount: departments[index].staffCount, phone: departments[index].phone, head: departments[index].head, email: departments[index].email, description: departments[index].description, hospitalName: departments[index].hospitalName)),
                    );
                  },
                  child: DepartmentCard(
                    departmentName: departments[index].name,
                    imagePath: departments[index].coverImageURL,

                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
