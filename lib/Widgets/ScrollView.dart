import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Screen/AllDepartment.dart';

import '../Screen/AllDoctor.dart';

class ScrollableCategoryRow extends StatelessWidget {
  final String heading;
  final Color color;
  final String Screen;
  final List<Widget> children;

  const ScrollableCategoryRow({super.key, 
    required this.heading,
    required this.children, required this.color, required this.Screen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: color,)),


        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if(Screen=="Department") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AllDepartment()), // Push the LoginScreen onto the stack
                        );
                      }
                      else if(Screen=="Doctor"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AllDoctor()), //  // Push the LoginScreen onto the stack

                        );
                      }
                    },
                    child: const Text('See all >'),
                  ),
                ],
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 120, // Adjust the height to fit your content
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: children.map((child) => child).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
