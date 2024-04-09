import 'package:flutter/material.dart';

class ScrollViewCard extends StatelessWidget {
  final String cardName;
  final String cardImagePath;
  final VoidCallback onTap;

  const ScrollViewCard({super.key, 
    required this.cardName,
    required this.cardImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1/1,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6,right: 6),
                child: Image.asset(
                  cardImagePath, // This should match the name of the variable passed into the constructor
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Center(
              child: Text(
                cardName, // This should match the name of the variable passed into the constructor
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
