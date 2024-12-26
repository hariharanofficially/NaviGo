import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/navigation_widget.dart';



class HorseListPage extends StatefulWidget {
  @override
  _HorseListPageState createState() => _HorseListPageState();
}

class Horse {
  final int id;
  final String name;
  final String currentName;
  final String originalName;
  final String breed;
  final String breeder;
  final String countryOfResidence;
  final String countryOfBirth;
  final String dateOfBirth;
  final String gender;
  final String color;
  final String microchipNo;
  final String division;
  final String stable;
  final String remarks;
  final bool active;
  final String createdAt;
  final String updatedAt;

  Horse({
    required this.id,
    required this.name,
    required this.currentName,
    required this.originalName,
    required this.breed,
    required this.breeder,
    required this.countryOfResidence,
    required this.countryOfBirth,
    required this.dateOfBirth,
    required this.gender,
    required this.color,
    required this.microchipNo,
    required this.division,
    required this.stable,
    required this.remarks,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['id'],
      name: json['name'],
      currentName: json['currentName'],
      originalName: json['originalName'],
      breed: json['breed']['name'],
      breeder: json['breeder']['name'],
      countryOfResidence: json['countryOfResidence']['name'],
      countryOfBirth: json['countryOfBirth']['name'],
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender']['name'],
      color: json['color']['name'],
      microchipNo: json['microchipNo'] ?? '',
      division: json['division']['name'],
      stable: json['stable']['name'],
      remarks: json['remarks'],
      active: json['active'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class _HorseListPageState extends State<HorseListPage> {
  late List<Horse> _horses = []; // Initialize _horses with an empty list

  @override
  void initState() {
    super.initState();
    _fetchHorses();
  }

  Future<void> _fetchHorses() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/horse?pageNo=0&pageSize=1000";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['horses'];
      setState(() {
        _horses = data.map((json) => Horse.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load horses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NavigitionWidget(),
      appBar: CustomAppBarWidget(),
      body: _horses.isNotEmpty
          ? ListView.builder(
        itemCount: _horses.length,
        itemBuilder: (context, index) {
          final horse = _horses[index];
          return Card(
            color: Color(0xFF8B48DF),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${horse.name}',style: TextStyle(color: Colors.white),),
                  SizedBox(height: 8.0),
                  Text('Breed: ${horse.breed}',style: TextStyle(color: Colors.white)),
                  SizedBox(height: 8.0),
                  Text('Country of Residence: ${horse.countryOfResidence}',style: TextStyle(color: Colors.white)),
                  // Add more Text widgets for other properties
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