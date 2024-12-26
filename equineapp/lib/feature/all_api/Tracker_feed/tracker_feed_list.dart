import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_app_bar_widget.dart';

class TrackerFeed {
  final int id; // Update with relevant fields from tracker-feed
  final String name; // Update with relevant fields from tracker-feed

  TrackerFeed({required this.id, required this.name});

  factory TrackerFeed.fromJson(Map<String, dynamic> json) {
    return TrackerFeed(
      id: json['id'],
      name: json['name'],
    );
  }
}

class TrackerFeedListPage extends StatefulWidget {
  @override
  _TrackerFeedListPageState createState() => _TrackerFeedListPageState();
}

class _TrackerFeedListPageState extends State<TrackerFeedListPage> {
  late List<TrackerFeed> _trackerFeeds = [];

  @override
  void initState() {
    super.initState();
    _fetchTrackerFeeds();
  }

  Future<void> _fetchTrackerFeeds() async {
    final String token = "E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C";
    final String apiUrl = "https://mindari.ae:7449/tracker/mindari-tracker/tracker-feed";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['trackerFeeds'];
        setState(() {
          _trackerFeeds = data.map((json) => TrackerFeed.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load tracker feeds');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      body: _trackerFeeds.isNotEmpty
          ? ListView.builder(
        itemCount: _trackerFeeds.length,
        itemBuilder: (context, index) {
          final trackerFeed = _trackerFeeds[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(trackerFeed.name), // Update with relevant field
              onTap: () {
                // Handle tap on tracker feed
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
