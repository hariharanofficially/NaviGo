import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class EventGroup {
  final int id;
  final String name;

  EventGroup({required this.id, required this.name});

  factory EventGroup.fromJson(Map<String, dynamic> json) {
    return EventGroup(
      id: json['id'],
      name: json['name'],
    );
  }
}

class EventGroupListPage extends StatefulWidget {
  @override
  _EventGroupListPageState createState() => _EventGroupListPageState();
}

class _EventGroupListPageState extends State<EventGroupListPage> {
  late List<EventGroup> _eventGroups = [];

  @override
  void initState() {
    super.initState();
    _fetchEventGroups();
  }

  Future<void> _fetchEventGroups() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/event-group";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['eventGroups'];
        setState(() {
          _eventGroups = data.map((json) => EventGroup.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load event groups');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _eventGroups.isNotEmpty
          ? ListView.builder(
        itemCount: _eventGroups.length,
        itemBuilder: (context, index) {
          final eventGroup = _eventGroups[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(eventGroup.name),
              onTap: () {
                // Handle tap on event group card
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
