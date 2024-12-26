import 'package:logger/logger.dart';

import '../../utils/mixins/convert_date_format.dart';

class ParticipantModel {
  Logger logger = new Logger();

  final int id;
  final String startNumber;
  final int riderId;
  final String rideDate;
  final String riderName;
  final int eventId;
  final String eventName;
  final String eventStartDate;
  final int horseId;
  final String horseName;
  final String horseCountryOfBirth;
  final String trackerDeviceId;
  final String hrSensorId;
  final String hrRate;
  final String avgHrRate;
  final String speed;
  final String avgSpeed;
  final String distance;
  final String arrivalTime;
  final String departureTime;
  final String duration;

  ParticipantModel(
      {required this.id,
      required this.startNumber,
      required this.riderId,
      required this.rideDate,
      required this.riderName,
      required this.eventId,
      required this.eventName,
      required this.eventStartDate,
      required this.horseId,
      required this.horseName,
      required this.horseCountryOfBirth,
      required this.trackerDeviceId,
      required this.hrSensorId,
      required this.hrRate,
      required this.avgHrRate,
      required this.speed,
      required this.avgSpeed,
      required this.distance,
      required this.arrivalTime,
      required this.departureTime,
      required this.duration});

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    int startTimeEpoch = DateTime.now().millisecondsSinceEpoch;
    int endTimeEpoch = DateTime.now().millisecondsSinceEpoch;

    String departureTime = json['participantSummary']?['departureTime'] ?? '';
    if (departureTime.isNotEmpty) {
      //departureTime != null &&
      //var d = DateFormat('HH:mm:ss').parse(departureTime);
      startTimeEpoch = getTimeInMillis(departureTime);
    }
    String arrivalTime = json['participantSummary']?['arrivalTime'] ?? '';
    if (arrivalTime.isNotEmpty) {
      // arrivalTime != null &&
      //var d = DateFormat('HH:mm:ss').parse(arrivalTime);
      endTimeEpoch = getTimeInMillis(arrivalTime);
    }
    DateTime startTime = DateTime.fromMillisecondsSinceEpoch(startTimeEpoch);
    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(endTimeEpoch);
    //String
    Duration diff = endTime.difference(startTime);
    String duration =
        "${diff.inHours}:${diff.inMinutes.remainder(60)}:${(diff.inSeconds.remainder(60))}";

    return ParticipantModel(
       id: json['id'].toInt(),
       startNumber: json['startNumber'],
       //rideDate: formatDate(json['event']?['rideDate'] ?? formatDateFromMillis(startTimeEpoch)),
        rideDate: '',
       riderId: json['rider']?['id'] ?? 0,
       riderName: json['rider']?['name'] ?? '',
       eventId: json['event']?['id'].toInt(),
        eventName: json['event']?['name'] ?? '',
       eventStartDate: formatDate(json['event']?['startDate'] ?? ''),
       horseId: json['horse']?['id'] ?? 0,
       horseName: json['horse']?['name'] ?? '',
       horseCountryOfBirth: json['horse']?['countryOfBirth']?['name'] ?? '',
       trackerDeviceId: json['trackerDevice']?['trackerDeviceId'],
       hrSensorId: json['trackerDevice']?['heartRateCensorId'],
        hrRate:
            (json['participantSummary']?['heartRate'] ?? 0).toStringAsFixed(0),
        avgHrRate: (json['participantSummary']?['avgHeartRate'] ?? 0)
            .toStringAsFixed(0),
        speed: (json['participantSummary']?['speed'] ?? 0).toStringAsFixed(0),
        avgSpeed:
            (json['participantSummary']?['avgSpeed'] ?? 0).toStringAsFixed(0),
        distance: (json['participantSummary']?['totalDistance'] ?? 0)
            .toStringAsFixed(0),

      //id: 0,
      //  startNumber: '',
      //rideDate: '',
      //     riderId:  0,
      //   riderName:  '',
      //     eventId: 0,
      //   eventName: '',
      //     eventStartDate: '',
      //     horseId: 0,
      //   horseName: '',
      //   horseCountryOfBirth: '',
      //   trackerDeviceId: '',
      //   hrSensorId: '',
      //   hrRate: '',
      //   avgHrRate: '',
      //   speed: '',
      //   avgSpeed:'',
      //   distance: '',
      //   arrivalTime: '',
      //   departureTime: '',
      //   duration: ''

        arrivalTime: arrivalTime,
        departureTime: departureTime,
        duration: duration
    );
  }
}
