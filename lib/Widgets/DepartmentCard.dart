import 'package:flutter/material.dart';

class DepartmentCard extends StatelessWidget {
  final String departmentName;
  final String imagePath;


  const DepartmentCard({super.key, 
    required this.departmentName,
    required this.imagePath,

  });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imagePath),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departmentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}
