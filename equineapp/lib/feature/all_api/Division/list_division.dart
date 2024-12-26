import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';


class Division {
  final int id;
  final String name;

  Division({required this.id, required this.name});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DivisionListPage extends StatefulWidget {
  @override
  _DivisionListPageState createState() => _DivisionListPageState();
}

class _DivisionListPageState extends State<DivisionListPage> {
  late List<Division> _divisions = [];

  @override
  void initState() {
    super.initState();
    _fetchDivisions();
  }

  Future<void> _fetchDivisions() async {
    final String token =
        "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl =
        "https://mindari.ae:7449/tracker/mindari-tracker/division";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['divisions'];
        setState(() {
          _divisions = data.map((json) => Division.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load divisions');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(),
      body: _divisions.isNotEmpty
          ? ListView.builder(
        itemCount: _divisions.length,
        itemBuilder: (context, index) {
          final division = _divisions[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(division.name),
              onTap: () {
                // Handle tap on division card
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
