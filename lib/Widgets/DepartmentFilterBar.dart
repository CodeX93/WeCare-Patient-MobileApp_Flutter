import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Util/FilterDepartment.dart';

class DepartmentFilterBar extends StatefulWidget {
  final ValueChanged<FilterDepartment> onFilterChanged;
  final List<String> departments; // Add this line to accept an array of department names

  const DepartmentFilterBar({
    Key? key,
    required this.onFilterChanged,
    required this.departments, // Add this line to accept an array of department names
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<DepartmentFilterBar> {
  String? selectedDepartmentName;

  // Function to update parent widget
  void notifyParent() {
    widget.onFilterChanged(FilterDepartment(
      departmentName: selectedDepartmentName,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDropdownButton(
          value: selectedDepartmentName,
          items: widget.departments, // Pass the array of department names here
          hint: 'Department',
          onChanged: (String? newValue) {
            setState(() {
              selectedDepartmentName = newValue;
              notifyParent();
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdownButton({
    required List<String> items,
    String? value,
    required String hint,
    required void Function(String?) onChanged,
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
          items: items.map<DropdownMenuItem<String>>((value) {
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
