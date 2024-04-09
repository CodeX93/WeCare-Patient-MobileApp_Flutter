import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Util/constant.dart';

typedef SlotSelectionCallback = void Function(String slot, String uuid, int fee,String hospitalName,String meetLink); // Add fee parameter
typedef DateSelectionCallback = void Function(DateTime date);
typedef PriceSelectionCallback = void Function(int price);

class AvailableSlotsSection extends StatefulWidget {
  final String doctorId;
  final SlotSelectionCallback onSlotSelected;
  final DateSelectionCallback onDateSelected;
  final PriceSelectionCallback onPriceSelected;

  const AvailableSlotsSection({
    Key? key,

    required this.doctorId,
    required this.onSlotSelected,
    required this.onDateSelected,
    required this.onPriceSelected,
  }) : super(key: key);

  @override
  _AvailableSlotsSectionState createState() => _AvailableSlotsSectionState();
}

class _AvailableSlotsSectionState extends State<AvailableSlotsSection> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> availableSlots = []; // Change to List<Map<String, dynamic>>
  String? selectedSlot;
  String? selectedSlotUuid; // Add selectedSlotUuid
  int fee = 0; // Add fee
  String? selectedHospital;
  String? meetLink;

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots();
  }

  void fetchAvailableSlots() async {
    try {

      final response = await http.get(
        Uri.parse('http://${Constant.IP}:5001/api/slots/getDoctorSlots/${widget.doctorId}'),
      );

      if (response.statusCode == 200) {

        print("Slots body ${response.body}");
        final List<dynamic> slotsData = jsonDecode(response.body) as List<dynamic>;
        final List<Map<String, dynamic>> detailedSlots = (slotsData.first['availabilitySlots'] as List<dynamic>)
            .expand<Map<String, dynamic>>((slot) => (slot['detailedSlots'] as List<dynamic>).cast<Map<String, dynamic>>())
            .toList();

        // Filter slots where availability is "Available"
        final List<Map<String, dynamic>> availableSlotsToday = detailedSlots
            .where((slot) => slot['availability'] == 'Available')
            .toList();
        print('slots\'s $availableSlotsToday');
        setState(() {
          availableSlots = availableSlotsToday; // Update availableSlots
          if (availableSlots.isNotEmpty) {
            fee = availableSlots.first['price'] as int; // Update fee
            widget.onPriceSelected(fee);
          }
        });
      } else {
        throw Exception('Failed to fetch available slots');
      }
    } catch (e) {
      print('Error fetching available slots: $e');
    }
  }



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchAvailableSlots();
        widget.onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Text(
            DateFormat('MMM d').format(selectedDate),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          ListTile(
            title: const Text(
              "Available Slots",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: availableSlots.map((slot) => ChoiceChip(
              label: Text(slot['startTime'] as String), // Update label
              selected: selectedSlot == slot['startTime'], // Update selected condition
              onSelected: (bool selected) {
                setState(() {
                  selectedSlot = selected ? slot['startTime']+"-"+slot['endTime'] as String : null; // Update selectedSlot
                  selectedSlotUuid = selected ? slot['uuid'] as String : null; // Set selectedSlotUuid
                  selectedHospital = selected ? slot['hospital'] as String : null; // Set selectedHospital
                  meetLink=selected ? slot['appointmentLink'] as String :null;
                  print('name\'s $selectedHospital');

                  widget.onSlotSelected(selectedSlot!, selectedSlotUuid!, fee, selectedHospital!,meetLink!); // Pass selectedSlotUuid, fee, and selectedHospital
                });
              },

            )).toList(),
          ),
        ],
      ),
    );
  }
}
