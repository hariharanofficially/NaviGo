import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../app/route/routes/route_path.dart';
import '../../../../app/route/routes/router.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/navigation_widget.dart';

class RiderForm extends StatefulWidget {
  @override
  _RiderFormState createState() => _RiderFormState();
}

class _RiderFormState extends State<RiderForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _divisionController = TextEditingController();
  final _stableController = TextEditingController();
  final _feiNoController = TextEditingController();
  final _feiExpiryDateController = TextEditingController();
  final _remarksController = TextEditingController();
  final _riderWeightController = TextEditingController();

  List<dynamic> _horseDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchHorseData();
  }

  Future<void> _fetchHorseData() async {
    String url = 'https://mindari.ae:7449/tracker/mindari-tracker/horse?pageNo=0&pageSize=10000';
    String token = 'E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C';

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData != null && responseData['content'] != null) {
          setState(() {
            _horseDataList = responseData['content'];
          });
        } else {
          print('Response data is null or content is null');
        }
      } else {
        print('Failed to fetch horse data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching horse data: $e');
    }
  }

  Future<void> _submitForm() async {
    final url = 'https://mindari.ae:7449/tracker/mindari-tracker/rider';
    final token = 'E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C';

    final riderData = {
      "rider": {
        "name": _nameController.text,
        "fatherName": _fatherNameController.text,
        "nationality": {"id": 1, "name": "Republic of India", "shortName": "India", "code": "97", "iso": "IND"},
        "dateOfBirth": _dateOfBirthController.text,
        "gender": _genderController.text,
        "bloodGroup": _bloodGroupController.text,
        "addresses": [
          {
            "addressline1": _address1Controller.text,
            "poBox": "125226",
            "city": "Dubai",
            "country": "Unknown",
            "telephone": "04-2215551",
            "fax": "04-2214999",
            "addressType": "HOME"
          },
          {
            "addressline1": _address2Controller.text,
            "poBox": "125226",
            "city": "Dubai",
            "country": "Unknown",
            "telephone": "04-2215551",
            "fax": "04-2214999",
            "addressType": "OFFICE"
          }
        ],
        "mobile": _mobileController.text,
        "email": _emailController.text,
        "division": {"id": 1, "name": _divisionController.text},
        "stable": {"id": 1, "name": _stableController.text},
        "fei": {
          "active": false,
          "no": _feiNoController.text,
          "expiryDate": _feiExpiryDateController.text,
          "registration": "",
          "registrationDate": "2022-09-09"
        },
        "remarks": _remarksController.text,
        "active": true,
        "riderWeight": int.parse(_riderWeightController.text)
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(riderData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rider data saved successfully')),
      );
      _fetchHorseData(); // Refresh horse data after successful submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save rider data')),
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
                  hintText: 'Enter the rider name',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _fatherNameController,
                  labelText: 'Father Name',
                  hintText: 'Enter the rider\'s father name',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _dateOfBirthController,
                  labelText: 'Date of Birth',
                  hintText: 'Enter the rider\'s date of birth',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _genderController,
                  labelText: 'Gender',
                  hintText: 'Enter the rider\'s gender',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _bloodGroupController,
                  labelText: 'Blood Group',
                  hintText: 'Enter the rider\'s blood group',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _address1Controller,
                  labelText: 'Address 1',
                  hintText: 'Enter the rider\'s address',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _address2Controller,
                  labelText: 'Address 2',
                  hintText: 'Enter the rider\'s address',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _mobileController,
                  labelText: 'Mobile',
                  hintText: 'Enter the rider\'s mobile number',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter the rider\'s email',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _divisionController,
                  labelText: 'Division',
                  hintText: 'Enter the rider\'s division',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _stableController,
                  labelText: 'Stable',
                  hintText: 'Enter the rider\'s stable',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _feiNoController,
                  labelText: 'FEI No',
                  hintText: 'Enter the rider\'s FEI number',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _feiExpiryDateController,
                  labelText: 'FEI Expiry Date',
                  hintText: 'Enter the rider\'s FEI expiry date',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _remarksController,
                  labelText: 'Remarks',
                  hintText: 'Enter any remarks',
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _riderWeightController,
                  labelText: 'Rider Weight',
                  hintText: 'Enter the rider\'s weight',
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
              child: Text('ADD RIDER'),
            ),
            ElevatedButton(
              onPressed: () {
                router.go(RoutePath.riderlist);
              },
              child: Text('VIEW RIDER'),
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
