import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../app/route/routes/route_path.dart';
import '../../../app/route/routes/router.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/navigation_widget.dart';
class DivisionForm extends StatefulWidget {
  const DivisionForm({super.key});

  @override
  State<DivisionForm> createState() => _DivisionFormState();
}

class _DivisionFormState extends State<DivisionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  Future<void> _addDivision() async {
    final String name = _nameController.text.trim(); // Trim any leading or trailing whitespaces

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a name for the Division'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop execution if name is empty
    }

    final url = Uri.parse('https://mindari.ae:7449/tracker/mindari-tracker/division');
    final token = 'E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: '{"division": { "name": "$name"}}',
      );

      if (response.statusCode == 200) {
        // Successfully added stable, show Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Division added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Error occurred while adding stable, show error message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add division: ${response.body}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NavigitionWidget(),
      appBar: CustomAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter the division name',
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF210063),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _addDivision,
              child: Text('ADD DIVISION'),
            ),
            ElevatedButton(
              onPressed: () {
                router.go(RoutePath.divisionlist);
              },
              child: Text('VIEW DIVISION'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return Card(
      elevation: 2,
      color: Color(0xFFF3F3F3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            filled: true,
            fillColor: Color(0xFFF3F3F3),
            contentPadding: EdgeInsets.fromLTRB(11, 9, 11, 9),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter the $labelText';
            }
            return null;
          },
        ),
      ),
    );
  }
}

