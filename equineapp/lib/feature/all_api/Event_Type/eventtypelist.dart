import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class EventType {
  final int id;
  final String name;

  EventType({required this.id, required this.name});

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['id'],
      name: json['name'],
    );
  }
}

class EventTypeListPage extends StatefulWidget {
  @override
  _EventTypeListPageState createState() => _EventTypeListPageState();
}

class _EventTypeListPageState extends State<EventTypeListPage> {
  late List<EventType> _eventTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchEventTypes();
  }

  Future<void> _fetchEventTypes() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/event-type";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['eventTypes'];
        setState(() {
          _eventTypes = data.map((json) => EventType.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load event types');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _eventTypes.isNotEmpty
          ? ListView.builder(
        itemCount: _eventTypes.length,
        itemBuilder: (context, index) {
          final eventType = _eventTypes[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(eventType.name),
              onTap: () {
                // Handle tap on event type card
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
