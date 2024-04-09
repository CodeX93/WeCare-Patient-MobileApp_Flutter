import "package:flutter/material.dart";
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Add padding for better UI
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(206, 239, 231, 100.0), // Use a color that exists
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black54,
          ),
          hintText: 'Search Doctor, Department etc.',
          hintStyle: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}