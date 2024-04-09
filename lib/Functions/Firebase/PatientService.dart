import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Util/constant.dart';

class PatientService {
  static Future<Map<String, dynamic>> fetchPatientData(String uid) async {
    try {
      final Uri url = Uri.parse('http://${Constant.IP}:4008/patient/get');
      final response = await http.post(
        url,
        body: jsonEncode({'uid': uid}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch patient data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patient data: $e');
      return {};
    }
  }
}
