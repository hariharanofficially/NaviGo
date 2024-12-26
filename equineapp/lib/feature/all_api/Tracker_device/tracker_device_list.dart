import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class Breed {
  final int id;
  final String name;

  Breed({required this.id, required this.name});

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'],
      name: json['name'],
    );
  }
}

class TrackerDeviceListPage extends StatefulWidget {
  @override
  _TrackerDeviceListPageState createState() => _TrackerDeviceListPageState();
}

class _TrackerDeviceListPageState extends State<TrackerDeviceListPage> {
  late List<Breed> _breeds = [];

  @override
  void initState() {
    super.initState();
    _fetchBreeds();
  }

  Future<void> _fetchBreeds() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/tracker-device";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['trackerDevices'];
        setState(() {
          _breeds = data.map((json) => Breed.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load tracker devices');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _breeds.isNotEmpty
          ? ListView.builder(
        itemCount: _breeds.length,
        itemBuilder: (context, index) {
          final breed = _breeds[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(breed.name),
              onTap: () {
                // Handle tap on breed card
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
