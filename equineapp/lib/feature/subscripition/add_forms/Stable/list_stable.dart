import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/navigation_widget.dart';

class Stable {
  final int id;
  final String name;

  Stable({required this.id, required this.name});

  factory Stable.fromJson(Map<String, dynamic> json) {
    return Stable(
      id: json['id'],
      name: json['name'],
    );
  }
}

class StableListPage extends StatefulWidget {
  @override
  _StableListPageState createState() => _StableListPageState();
}

class _StableListPageState extends State<StableListPage> {
  late List<Stable> _stables = [];

  @override
  void initState() {
    super.initState();
    _fetchStables();
  }

  Future<void> _fetchStables() async {
    final String token =
        "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl =
        "https://mindari.ae:7449/tracker/mindari-tracker/stable";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['stables'];
        setState(() {
          _stables = data.map((json) => Stable.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load stables');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NavigitionWidget(),
      appBar: CustomAppBarWidget(),
      body: _stables.isNotEmpty
          ? ListView.builder(
        itemCount: _stables.length,
        itemBuilder: (context, index) {
          final stable = _stables[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(stable.name),
              onTap: () {
                // Handle tap on stable card
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