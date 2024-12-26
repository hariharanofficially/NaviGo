import 'package:flutter/material.dart';

class CustomTextFormFields extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator; // Allow for nullable return type
  final double width;
  final double height;
  const CustomTextFormFields({
    Key? key,
    required this.controller,
    required this.validator,
    required this.width,
    required this.height,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Width in px
      height: height, // Height in px
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5), // Custom border-radius
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            // fontSize: 15.0, // Adjust this as needed
            fontFamily: 'Karla',
            // fontWeight: FontWeight.w100,
            color: Color(0xFF8B48DF), // Label text color
          ),
          fillColor: Color(0xFFD9D9D9), // Background color
          filled: true, // Enable filling with the background color
          contentPadding: EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // Set radius for all
            borderSide: BorderSide.none, // No default border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), // Custom border radius
              bottomLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: Color(0xFFD9D9D9), // Outline color
              width: 2.0, // Border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), // Custom border radius
              bottomLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            borderSide: BorderSide(
              color: Color(0xFFD9D9D9), // Border color when focused
              width: 2.0,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
