import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class HorseColor {
  final int id;
  final String name;

  HorseColor({required this.id, required this.name});

  factory HorseColor.fromJson(Map<String, dynamic> json) {
    return HorseColor(
      id: json['id'],
      name: json['name'],
    );
  }
}

class HorseColorListPage extends StatefulWidget {
  @override
  _HorseColorListPageState createState() => _HorseColorListPageState();
}

class _HorseColorListPageState extends State<HorseColorListPage> {
  late List<HorseColor> _horseColors = [];

  @override
  void initState() {
    super.initState();
    _fetchHorseColors();
  }

  Future<void> _fetchHorseColors() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/horse-color";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody.containsKey('horseColors')) { // Check if the key is available
          List<dynamic> data = responseBody['horseColors'];
          setState(() {
            _horseColors = data.map((json) => HorseColor.fromJson(json)).toList();
          });
        } else {
          throw Exception('Failed to load horse colors: Key "horseColors" not found');
        }
      } else {
        throw Exception('Failed to load horse colors. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _horseColors.isNotEmpty
          ? ListView.builder(
        itemCount: _horseColors.length,
        itemBuilder: (context, index) {
          final horseColor = _horseColors[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(horseColor.name),
              onTap: () {
                // Handle tap on horse color card
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
