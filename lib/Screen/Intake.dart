import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineIntakeScreen extends StatefulWidget {
  const MedicineIntakeScreen({super.key});

  @override
  _MedicineIntakeScreenState createState() => _MedicineIntakeScreenState();
}

class _MedicineIntakeScreenState extends State<MedicineIntakeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(48, 120, 103, 100),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Medicine Intake',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          labelColor: Colors.white,
          // Sets the color of the text for the selected tab
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'MORNING'),
            Tab(text: 'AFTERNOON'),
            Tab(text: 'NIGHT'),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              formatDate(DateTime.now()),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MedicineList(phase: 'morning'),
                MedicineList(phase: 'afternoon'),
                MedicineList(phase: 'night'),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(content: Text('Your Intake has been noted',),),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('UPDATE TO DOCTOR',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineList extends StatefulWidget {
  final String phase;

  const MedicineList({Key? key, required this.phase}) : super(key: key);

  @override
  _MedicineListState createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  List<Map<String, dynamic>> medicines = [
    {
      'name': 'ASPIRIN',
      'dosage': 'Take 250mg',
      'morning': false,
      'afternoon': true,
      'night': true,
      'taken': false, // Initial value for taken flag
    },
    {
      'name': 'ASPIRIN',
      'dosage': 'Take 250mg',
      'morning': true,
      'afternoon': true,
      'night': true,
      'taken': false, // Initial value for taken flag
    },
    {
      'name': 'ASPIRIN',
      'dosage': 'Take 250mg',
      'morning': true,
      'afternoon': true,
      'night': true,
      'taken': true, // Initial value for taken flag
    },
    {
      'name': 'ASPIRIN32',
      'dosage': 'Take 250mg',
      'morning': true,
      'afternoon': false,
      'night': false,
      'taken': false, // Initial value for taken flag
    },

    // ... Add more medicines as needed
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the medicines list for those that should be displayed in the current phase
    List<Map<String, dynamic>> filteredMedicines =
        medicines.where((medicine) => medicine[widget.phase] == true).toList();

    return ListView.builder(
      itemCount: filteredMedicines.length,
      itemBuilder: (context, index) {
        var medicine = filteredMedicines[index];
        bool isTaken = medicine['taken'];

        return CheckboxListTile(
          title: Text(medicine['name']),
          subtitle: Text(medicine['dosage']),
          value: isTaken,
          onChanged: (bool? value) {
            setState(() {
              // Update the medicine's taken status
              filteredMedicines[index]['taken'] = value!;
              // Here, you would also update your backend or database
            });
          },
        );
      },
    );
  }
}
