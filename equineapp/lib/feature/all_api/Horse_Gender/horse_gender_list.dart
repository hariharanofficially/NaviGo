import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class HorseGender {
  final int id;
  final String name;

  HorseGender({required this.id, required this.name});

  factory HorseGender.fromJson(Map<String, dynamic> json) {
    return HorseGender(
      id: json['id'],
      name: json['name'],
    );
  }
}

class HorseGenderListPage extends StatefulWidget {
  @override
  _HorseGenderListPageState createState() => _HorseGenderListPageState();
}

class _HorseGenderListPageState extends State<HorseGenderListPage> {
  late List<HorseGender> _horseGenders = [];

  @override
  void initState() {
    super.initState();
    _fetchHorseGenders();
  }

  Future<void> _fetchHorseGenders() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/horse-gender";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['genders'];
        setState(() {
          _horseGenders = data.map((json) => HorseGender.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load horse genders');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _horseGenders.isNotEmpty
          ? ListView.builder(
        itemCount: _horseGenders.length,
        itemBuilder: (context, index) {
          final horseGender = _horseGenders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(horseGender.name),
              onTap: () {
                // Handle tap on horse gender card
              },
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
