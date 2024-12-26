import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app/route/routes/route_path.dart';
import '../../../app/route/routes/router.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/navigation_widget.dart';

class ParticipantForm extends StatefulWidget {
  @override
  _ParticipantFormState createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  final _formKey = GlobalKey<FormState>();
  final _trackerDeviceIdController = TextEditingController();
  final _deviceMacIdController = TextEditingController();
  final _heartRateCensorIdController = TextEditingController();
  final _gpsSignalStrengthController = TextEditingController();
  final _censorVoltageController = TextEditingController();
  final _deviceVoltageController = TextEditingController();
  final _timeZoneController = TextEditingController();
  final _dayLightSavingMinutesController = TextEditingController();

  Future<void> _submitForm() async {
    final url = 'https://mindari.ae:7449/tracker/mindari-tracker/tracker-device';
    final token = 'E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C';

    final trackerDeviceData = {
      "trackerDevice": {
        "userDeviceId": 1,
        "trackerDeviceId": _trackerDeviceIdController.text,
        "deviceMacId": _deviceMacIdController.text,
        "heartRateCensorId": _heartRateCensorIdController.text,
        "gpsSignalStrength": _gpsSignalStrengthController.text,
        "censorVoltage": _censorVoltageController.text,
        "deviceVoltage": _deviceVoltageController.text,
        "timeZone": _timeZoneController.text,
        "dayLightSavingMinutes": _dayLightSavingMinutesController.text,
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(trackerDeviceData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tracker device data saved successfully')),
      );
      // Clear form fields after successful submission
      _formKey.currentState?.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save tracker device data')),
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
                  controller: _deviceMacIdController,
                  labelText: 'Device Mac ID',
                  hintText: 'Enter the device Mac ID',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _heartRateCensorIdController,
                  labelText: 'Heart Rate Sensor ID',
                  hintText: 'Enter the heart rate sensor ID',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _gpsSignalStrengthController,
                  labelText: 'GPS Signal Strength',
                  hintText: 'Enter the GPS signal strength',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _censorVoltageController,
                  labelText: 'Censor Voltage',
                  hintText: 'Enter the sensor voltage',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _deviceVoltageController,
                  labelText: 'Device Voltage',
                  hintText: 'Enter the device voltage',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _timeZoneController,
                  labelText: 'Time Zone',
                  hintText: 'Enter the time zone',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _dayLightSavingMinutesController,
                  labelText: 'Daylight Saving Minutes',
                  hintText: 'Enter the daylight saving minutes',
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
              child: Text('ADD PARTICIPANT'),
            ),
            ElevatedButton(
              onPressed: () {
                router.go(RoutePath.participantlist);
              },
              child: Text('VIEW PARTICIPANTS'),
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
