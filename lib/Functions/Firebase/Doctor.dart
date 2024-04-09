import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Models/Doctor.dart';

Future<List<Doctor>> getAllDoctors() async {
  final url = Uri.parse('http://192.168.18.18:5005/api/user/getAll');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {

      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Doctor>((item) => Doctor.fromJson(item['doctorData'])).toList();
    } else {
      throw Exception('Failed to load doctor data');
    }
  } catch (error) {
    print('Error fetching all doctors: $error');
    throw error;
  }
}
