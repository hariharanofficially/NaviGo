import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/navigation_widget.dart';

class RiderListPage extends StatefulWidget {
  @override
  _RiderListPageState createState() => _RiderListPageState();
}

class Rider {
  final int id;
  final String name;
  final String fatherName;
  final String nationality;
  final String dateOfBirth;
  final String gender;
  final String bloodGroup;
  final String address1;
  final String address2;
  final String mobile;
  final String email;
  final String division;
  final String stable;
  final String feiNo;
  final String feiExpiryDate;
  final String remarks;
  final bool active;
  final String createdAt;
  final String updatedAt;

  Rider({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.nationality,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.address1,
    required this.address2,
    required this.mobile,
    required this.email,
    required this.division,
    required this.stable,
    required this.feiNo,
    required this.feiExpiryDate,
    required this.remarks,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['id'],
      name: json['name'],
      fatherName: json['fatherName'],
      nationality: json['nationality'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      address1: json['addresses'][0]['addressline1'],
      address2: json['addresses'][1]['addressline1'],
      mobile: json['mobile'],
      email: json['email'],
      division: json['division'],
      stable: json['stable'],
      feiNo: json['fei']['no'],
      feiExpiryDate: json['fei']['expiryDate'],
      remarks: json['remarks'],
      active: json['active'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class _RiderListPageState extends State<RiderListPage> {
  late List<Rider> _riders = []; // Initialize _riders with an empty list

  @override
  void initState() {
    super.initState();
    _fetchRiders();
  }

  Future<void> _fetchRiders() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/rider?pageNo=0&pageSize=1000";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['riders'];
      setState(() {
        _riders = data.map((json) => Rider.fromJson(json)).toList();
        print(_riders);
      });
    } else {
      throw Exception('Failed to load riders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NavigitionWidget(),
      appBar: CustomAppBarWidget(),
      body: _riders.isNotEmpty
          ? ListView.builder(
        itemCount: _riders.length,
        itemBuilder: (context, index) {
          final rider = _riders[index];
          return Card(
            color: Color(0xFF8B48DF),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${rider.name}', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 8.0),
                  Text('Father Name: ${rider.fatherName}', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 8.0),

                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
