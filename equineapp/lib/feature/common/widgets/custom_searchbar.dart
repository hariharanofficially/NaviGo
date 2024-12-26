import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final double width;
  final double height;
  const CustomSearchBar({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      // width: 320,
      // height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the search bar
        borderRadius: BorderRadius.circular(25), // Circular borders
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
               
                border: InputBorder.none, // No border around the text field
              ),
              onChanged: (value) {
                // Handle search input changes here
              },
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.search, // Search icon inside the search bar
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
