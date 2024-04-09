import 'package:flutter/material.dart';
import 'package:health/health.dart';


class MyVitalSigns extends StatefulWidget {
  @override
  _HealthDataFetchState createState() => _HealthDataFetchState();
}

class _HealthDataFetchState extends State<MyVitalSigns> {
  final HealthFactory health = HealthFactory();
  List<HealthDataPoint> _healthDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Define the types of health data to access
    List<HealthDataType> types = [
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.BLOOD_OXYGEN,
    ];

    // Define the date range for fetching data
    DateTime startDate = DateTime.now().subtract(Duration(days: 30));
    DateTime endDate = DateTime.now();

    // Request access to the health data
    bool accessWasGranted = await health.requestAuthorization(types);

    if (accessWasGranted) {
      try {
        // Fetch health data for each type
        for (HealthDataType type in types) {
          List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(startDate, endDate, types);
          _healthDataList.addAll(healthData);
        }

        // Filter out duplicate data points
        _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

        // Update UI
        setState(() {});
      } catch (exception) {
        print('Error fetching health data: $exception');
      }
    } else {
      print('Authorization not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Health Data Example'),
        ),
        body: ListView.builder(
          itemCount: _healthDataList.length,
          itemBuilder: (_, index) {
            HealthDataPoint dataPoint = _healthDataList[index];
            return ListTile(
              title: Text('${dataPoint.typeString}: ${dataPoint.value}'),
              subtitle: Text('Date: ${dataPoint.dateFrom}'),
            );
          },
        ),
      ),
    );
  }
}


