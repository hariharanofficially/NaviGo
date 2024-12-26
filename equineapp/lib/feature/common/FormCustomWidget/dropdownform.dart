import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String hint;
  final String? selectedValue;
  final List<dynamic> items;
  final ValueChanged<String?> onChanged;
  final String labelText; // Add labelText as a parameter
  final FormFieldValidator<String>? validator;
  const CustomDropdownButtonFormField({
    Key? key,
    required this.hint,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator, // Add validator here
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hint,
            labelStyle:
                TextStyle(fontFamily: 'Karla', color: Color(0xFF8B48DF)),
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
