import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class TrackerFeedData {
  Logger logger = new Logger();

  final int id;
  final DateTime dateTime;
  final String distance;
  final String speed;
  final String heartRate;
  final LatLng latlng;

  TrackerFeedData({
    required this.id,
    required this.dateTime,
    required this.distance,
    required this.speed,
    required this.heartRate,
    required this.latlng});

  factory TrackerFeedData.fromJson(Map<String, dynamic> json) {
    double lat = double.parse(json['latitude'] ?? '0');
    double long = double.parse(json['longitude'] ?? '0');
    return TrackerFeedData(
      id: json['id'].toInt(),
      dateTime : DateTime.parse(json['dateTime']),
      distance : (json['distance'] ?? 0)
          .toStringAsFixed(0),
      speed: (json['speed'] ?? 0).toStringAsFixed(0),
      heartRate: (json['heartRate'] ?? 0).toStringAsFixed(0),
      latlng: LatLng(lat, long)
    );

  }
}