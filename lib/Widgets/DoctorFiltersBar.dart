import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wecare_patient_mobile/Util/constant.dart';

import '../Util/Filter.dart';

class FilterBar extends StatefulWidget {
  final ValueChanged<Filter> onFilterChanged;

  const FilterBar({
    Key? key,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List<String> specialties = [];
  String? selectedSpecialty;


  @override
  void initState() {
    super.initState();
    fetchSpecialties();
  }

  Future<void> fetchSpecialties() async {
    try {
      final response = await http
          .get(Uri.parse('http://${Constant.IP}:4010/api/Department/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          specialties = data
              .map<String>((department) => department['name'] as String)
              .toList();
        });
      } else {
        throw Exception('Failed to load specialties');
      }
    } catch (error) {
      print('Error fetching specialties: $error');
    }
  }

  void notifyParent() {
    widget.onFilterChanged(Filter(
      specialization: selectedSpecialty ?? '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButtonHideUnderline(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(152, 240, 219, 1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: DropdownButton<String>(
              value: selectedSpecialty,
              hint: Text('Speciality'),
              isDense: true,
              items: specialties.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSpecialty = newValue;
                  notifyParent();
                });
              },
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownButton<T>({
    required List<String> items,
    String? value,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(152, 240, 219, 1),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isDense: true,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
