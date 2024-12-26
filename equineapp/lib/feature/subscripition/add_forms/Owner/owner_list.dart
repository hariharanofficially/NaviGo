import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/widgets/custom_app_bar_widget.dart';

class Owner {
  final int id;
  final String name;

  Owner({required this.id, required this.name});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
    );
  }
}

class OwnerListPage extends StatefulWidget {
  @override
  _OwnerListPageState createState() => _OwnerListPageState();
}

class _OwnerListPageState extends State<OwnerListPage> {
  late List<Owner> _owners = [];

  @override
  void initState() {
    super.initState();
    _fetchOwners();
  }

  Future<void> _fetchOwners() async {
    final String token =
        "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl =
        "https://mindari.ae:7449/tracker/mindari-tracker/owner";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['owners'];
        setState(() {
          _owners = data.map((json) => Owner.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load owners');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _owners.isNotEmpty
          ? ListView.builder(
        itemCount: _owners.length,
        itemBuilder: (context, index) {
          final owner = _owners[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(owner.name),
              onTap: () {
                // Handle tap on owner card
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
