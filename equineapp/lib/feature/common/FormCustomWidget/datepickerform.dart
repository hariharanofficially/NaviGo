import 'package:flutter/material.dart';

class CustomDatePickerFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final Function(BuildContext) onDateTap;

  const CustomDatePickerFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.onDateTap,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: controller,
          readOnly: true, // Makes the TextFormField read-only
          onTap: () {
            onDateTap(context); // Triggers the date selection function
            FocusScope.of(context)
                .requestFocus(FocusNode()); // Removes keyboard focus
          },
          validator: validator,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            labelStyle:
                TextStyle(fontFamily: 'Karla', color: Color(0xFF8B48DF)),
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(color: Colors.black),
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.black45,
              ),
              onPressed: () {
                onDateTap(
                    context); // Triggers the date selection when icon is clicked
                FocusScope.of(context).requestFocus(FocusNode());
              },
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
