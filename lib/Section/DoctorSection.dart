import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wecare_patient_mobile/Screen/AllDoctor.dart';
import '../Models/Doctor.dart';
import '../Screen/DoctorScreen.dart';
import '../Util/constant.dart';

class DoctorSection extends StatefulWidget {
  DoctorSection({Key? key}) : super(key: key);

  @override
  _DoctorSectionState createState() => _DoctorSectionState();
}

class _DoctorSectionState extends State<DoctorSection> {
  List<Doctor> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    final url = Uri.parse('http://${Constant.IP}:5006/api/user/getAll');


    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          doctors = data.map((item) => Doctor.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load doctor data');
      }
    } catch (error) {
      print('Error fetching doctors: $error');
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
                'All Doctors',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllDoctor()),
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
          height: 200, // Height of the cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorScreen(
                        doctorName: doctors[index].firstName+" "+doctors[index].lastName,
                        specialization: doctors[index].category,

                        imagePath: doctors[index].profilePic,

                        fee: 100, // You might want to replace this with the actual fee
                        doctorAbout: doctors[index].doctorAbout,
                        DoctoruniqueIdentifier: doctors[index].uniqueIdentifier,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: index == doctors.length - 1 ? 16.0 : 0,
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
                                doctors[index].profilePic,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              doctors[index].firstName+" "+doctors[index].lastName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            doctors[index].category,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
