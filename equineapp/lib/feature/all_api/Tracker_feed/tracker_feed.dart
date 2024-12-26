import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../app/route/routes/route_path.dart';
import '../../../app/route/routes/router.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/navigation_widget.dart';

class TrackerFeedForm extends StatefulWidget {
  @override
  _TrackerFeedFormState createState() => _TrackerFeedFormState();
}

class _TrackerFeedFormState extends State<TrackerFeedForm> {
  final _formKey = GlobalKey<FormState>();
  final _trackerDeviceIdController = TextEditingController();
  final _eventIdController = TextEditingController();
  final _participantIdController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _speedController = TextEditingController();
  final _distanceController = TextEditingController();

  Future<void> _submitForm() async {
    final url = 'https://mindari.ae:7449/tracker/mindari-tracker/tracker-feed';
    final token = 'E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C';

    final trackerFeedData = {
      "trackerFeed": {
        "trackerDeviceId": int.parse(_trackerDeviceIdController.text),
        "eventId": int.parse(_eventIdController.text),
        "participantId": int.parse(_participantIdController.text),
        "dateTime": _dateTimeController.text,
        "latitude": _latitudeController.text,
        "longitude": _longitudeController.text,
        "heartRate": int.parse(_heartRateController.text),
        "speed": double.parse(_speedController.text),
        "distance": double.parse(_distanceController.text),
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(trackerFeedData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tracker feed data saved successfully')),
      );
      // Clear form fields after successful submission
      _formKey.currentState?.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save tracker feed data')),
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
                  controller: _trackerDeviceIdController,
                  labelText: 'Tracker Device ID',
                  hintText: 'Enter the tracker device ID',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _eventIdController,
                  labelText: 'Event ID',
                  hintText: 'Enter the event ID',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _participantIdController,
                  labelText: 'Participant ID',
                  hintText: 'Enter the participant ID',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _dateTimeController,
                  labelText: 'Date Time',
                  hintText: 'Enter the date and time',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _latitudeController,
                  labelText: 'Latitude',
                  hintText: 'Enter the latitude',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _longitudeController,
                  labelText: 'Longitude',
                  hintText: 'Enter the longitude',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _heartRateController,
                  labelText: 'Heart Rate',
                  hintText: 'Enter the heart rate',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _speedController,
                  labelText: 'Speed',
                  hintText: 'Enter the speed',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _distanceController,
                  labelText: 'Distance',
                  hintText: 'Enter the distance',
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                }
              },
              child: Text('ADD TRACKER FEED'),
            ),
            ElevatedButton(
              onPressed: () {
                router.go(RoutePath.trackerfeetlist);
              },
              child: Text('VIEW TRACKER FEEDS'),
            ),
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
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
