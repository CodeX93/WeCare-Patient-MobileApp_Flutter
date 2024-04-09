import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wecare_patient_mobile/Screen/DepartmentScreen.dart';
import 'dart:convert';
import '../Models/Department.dart';
import '../Screen/AllDepartment.dart';
import '../Util/constant.dart';

class DepartmentSection extends StatefulWidget {
  DepartmentSection({Key? key}) : super(key: key);

  @override
  _DepartmentSectionState createState() => _DepartmentSectionState();
}

class _DepartmentSectionState extends State<DepartmentSection> {
  List<Department> departments = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {

      final response = await http.get(Uri.parse('http://${Constant.IP}:4010/api/Department/'));
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          departments = data.map((departmentData) => Department.fromJson(departmentData)).toList();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Departments',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllDepartment(),
                    ),
                  );
                },
                child: Text(
                  'See more >',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: departments.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push( // Use pushReplacement to replace the login screen
                    context,
                    MaterialPageRoute(builder: (context) =>  DepartmentScreen(imageURL:departments[index].coverImageURL,name: departments[index].name, staffCount: departments[index].staffCount, phone: departments[index].phone, head: departments[index].head, email: departments[index].email, description: departments[index].description, hospitalName: departments[index].hospitalName)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: index == departments.length - 1 ? 16.0 : 0,
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                departments[index].coverImageURL,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              departments[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
