import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class EventState {
  final int id;
  final String name;

  EventState({required this.id, required this.name});

  factory EventState.fromJson(Map<String, dynamic> json) {
    return EventState(
      id: json['id'],
      name: json['name'],
    );
  }
}

class EventStateListPage extends StatefulWidget {
  @override
  _EventStateListPageState createState() => _EventStateListPageState();
}

class _EventStateListPageState extends State<EventStateListPage> {
  late List<EventState> _eventStates = [];

  @override
  void initState() {
    super.initState();
    _fetchEventStates();
  }

  Future<void> _fetchEventStates() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/event-state";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['eventStates'];
        setState(() {
          _eventStates = data.map((json) => EventState.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load event states');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _eventStates.isNotEmpty
          ? ListView.builder(
        itemCount: _eventStates.length,
        itemBuilder: (context, index) {
          final eventState = _eventStates[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(eventState.name),
              onTap: () {
                // Handle tap on event state card
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
