import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String? imagePath; // Change to nullable

  final VoidCallback onTap;
  final double rating;

  const DoctorCard({
    Key? key, // Add Key parameter
    required this.doctorName,
    required this.specialization,
    this.imagePath, // Make imagePath nullable
    this.rating = 5.0, // Default rating value
    required this.onTap,
  }) : super(key: key); // Call super constructor with key

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              backgroundImage: imagePath != null
                  ? NetworkImage(imagePath!)
                  : Image.asset('assets/images/welcome1.png').image, // Convert AssetImage to ImageProvider
            ),

            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    specialization,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      // Star rating, could be a separate widget
                      ...List.generate(
                        5,
                            (index) => Icon(
                          Icons.star,
                          color: index < rating ? Colors.amber : Colors.grey,
                        ),
                      ),
                      // const SizedBox(width: 10),
                      // Experience
                      // Text(
                      //   '$experience Years',
                      //   style: const TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
