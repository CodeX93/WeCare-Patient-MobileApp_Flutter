import 'package:flutter/material.dart';

class CustomScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;

  const CustomScreenAppBar({
    Key? key,
    required this.title,
    this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(48, 120, 103, 100), // Your background color
      elevation: 0, // Removes the shadow
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white), // Your back arrow color
        onPressed: onBackTap ?? () {
          Navigator.of(context).pop(); // Default back button action
        },
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // Your title color
          // Add other TextStyle properties as needed
        ),
      ),

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height
}
