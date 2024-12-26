import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../app/route/routes/route_path.dart';
import '../../../../app/route/routes/router.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _groupFlagController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _rideStartTimeController = TextEditingController();
  final _rideDateController = TextEditingController();
  final _sourceController = TextEditingController();
  final _vendorNameController = TextEditingController();
  final _vendorLogoController = TextEditingController();
  final _vendorRideIdController = TextEditingController();

  Future<void> _addEvent() async {
    final String name = _nameController.text.trim();
    final String startDate = _startDateController.text.trim();
    final String endDate = _endDateController.text.trim();
    final bool groupFlag = _groupFlagController.text.trim() == 'true';
    final String shortName = _shortNameController.text.trim();
    final String title = _titleController.text.trim();
    final String groupName = _groupNameController.text.trim();
    final String category = _categoryController.text.trim();
    final String locationName = _locationNameController.text.trim();
    final String city = _cityController.text.trim();
    final String rideStartTime = _rideStartTimeController.text.trim();
    final String rideDate = _rideDateController.text.trim();
    final String source = _sourceController.text.trim();
    final String vendorName = _vendorNameController.text.trim();
    final String vendorLogo = _vendorLogoController.text.trim();
    final String vendorRideId = _vendorRideIdController.text.trim();

    if (name.isEmpty || startDate.isEmpty || endDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final url = Uri.parse('https://mindari.ae:7449/tracker/mindari-tracker/event');
    final token = 'E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "event": {
            "name": name,
            "startDate": startDate,
            "endDate": endDate,
            "eventType": {"id": 1}, // Assuming eventType ID needs to be provided
            "groupFlag": groupFlag,
            "shortName": shortName,
            "title": title,
            "groupName": groupName,
            "category": category,
            "locationName": locationName,
            "city": city,
            "rideStartTime": rideStartTime,
            "rideDate": rideDate,
            "source": source,
            "vendorName": vendorName,
            "vendorLogo": vendorLogo,
            "vendorRideId": vendorRideId
          }
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add event: ${response.body}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
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
                  hintText: 'Enter the event name',
                ),
                _buildTextFormField(
                  controller: _startDateController,
                  labelText: 'Start Date',
                  hintText: 'Enter the start date (YYYY-MM-DD)',
                ),
                _buildTextFormField(
                  controller: _endDateController,
                  labelText: 'End Date',
                  hintText: 'Enter the end date (YYYY-MM-DD)',
                ),
                _buildTextFormField(
                  controller: _groupFlagController,
                  labelText: 'Group Flag',
                  hintText: 'Enter true/false for group flag',
                ),
                _buildTextFormField(
                  controller: _shortNameController,
                  labelText: 'Short Name',
                  hintText: 'Enter the short name',
                ),
                _buildTextFormField(
                  controller: _titleController,
                  labelText: 'Title',
                  hintText: 'Enter the title',
                ),
                _buildTextFormField(
                  controller: _groupNameController,
                  labelText: 'Group Name',
                  hintText: 'Enter the group name',
                ),
                _buildTextFormField(
                  controller: _categoryController,
                  labelText: 'Category',
                  hintText: 'Enter the category',
                ),
                _buildTextFormField(
                  controller: _locationNameController,
                  labelText: 'Location Name',
                  hintText: 'Enter the location name',
                ),
                _buildTextFormField(
                  controller: _cityController,
                  labelText: 'City',
                  hintText: 'Enter the city',
                ),
                _buildTextFormField(
                  controller: _rideStartTimeController,
                  labelText: 'Ride Start Time',
                  hintText: 'Enter the ride start time (HH:mm:ss)',
                ),
                _buildTextFormField(
                  controller: _rideDateController,
                  labelText: 'Ride Date',
                  hintText: 'Enter the ride date (YYYY-MM-DD)',
                ),
                _buildTextFormField(
                  controller: _sourceController,
                  labelText: 'Source',
                  hintText: 'Enter the source',
                ),
                _buildTextFormField(
                  controller: _vendorNameController,
                  labelText: 'Vendor Name',
                  hintText: 'Enter the vendor name',
                ),
                _buildTextFormField(
                  controller: _vendorLogoController,
                  labelText: 'Vendor Logo',
                  hintText: 'Enter the vendor logo',
                ),
                _buildTextFormField(
                  controller: _vendorRideIdController,
                  labelText: 'Vendor Ride ID',
                  hintText: 'Enter the vendor ride ID',
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
              onPressed: _addEvent,
              child: Text('ADD EVENT'),
            ),
            ElevatedButton(
              onPressed: () {
                router.go(RoutePath.eventlist);
              },
              child: Text('VIEW EVENTS'),
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
