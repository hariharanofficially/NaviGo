import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final String labelText; // Add labelText as a parameter
  final TextEditingController controller;
  final bool validate;
  CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validate = false,
    required this.labelText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle:
                TextStyle(fontFamily: 'Karla', color: Color(0xFF8B48DF)),
            contentPadding: EdgeInsets.all(5),
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          validator: (value) {
            if (widget.validate == true) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
            }

            // Return null if the entered password is valid
            return null;
          },
          //onChanged: (value) => _password = value,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
