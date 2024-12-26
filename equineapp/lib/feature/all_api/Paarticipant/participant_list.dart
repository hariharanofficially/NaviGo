import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../common/widgets/custom_app_bar_widget.dart';

class Participant {
  final int id;
  final String name;

  Participant({required this.id, required this.name});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ParticipantListPage extends StatefulWidget {
  @override
  _ParticipantListPageState createState() => _ParticipantListPageState();
}

class _ParticipantListPageState extends State<ParticipantListPage> {
  late List<Participant> _participants = [];

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  Future<void> _fetchParticipants() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/participant";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['participants'];
        setState(() {
          _participants = data.map((json) => Participant.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load participants');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _participants.isNotEmpty
          ? ListView.builder(
        itemCount: _participants.length,
        itemBuilder: (context, index) {
          final participant = _participants[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(participant.name),
              onTap: () {
                // Handle tap on participant card
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
