import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class Breeder {
  final int id;
  final String name;

  Breeder({required this.id, required this.name});

  factory Breeder.fromJson(Map<String, dynamic> json) {
    return Breeder(
      id: json['id'],
      name: json['name'],
    );
  }
}

class BreederListPage extends StatefulWidget {
  @override
  _BreederListPageState createState() => _BreederListPageState();
}

class _BreederListPageState extends State<BreederListPage> {
  late List<Breeder> _breeders = [];

  @override
  void initState() {
    super.initState();
    _fetchBreeders();
  }

  Future<void> _fetchBreeders() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/breeder";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['breeders'];
        setState(() {
          _breeders = data.map((json) => Breeder.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load breeders');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _breeders.isNotEmpty
          ? ListView.builder(
        itemCount: _breeders.length,
        itemBuilder: (context, index) {
          final breeder = _breeders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(breeder.name),
              onTap: () {
                // Handle tap on breeder card
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
