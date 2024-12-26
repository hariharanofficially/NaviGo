final String c_id = 'id';
final String c_trackerdeviceid = 'trackerDeviceId';
final String c_eventid = 'eventId';
final String c_participantid = 'participantId';
final String c_time = 'dateTime';
final String c_speed = 'speed';
final String c_hr = 'heartRate';
final String c_distance = 'distance';
final String c_latitude = 'latitude';
final String c_longitude = 'longitude';

class Transaction {
  int id;
  String trackerdeviceid;
  String eventId;
  String participantid;
  String time;
  String speed;
  String hr;
  String latitude;
  String logitude;
  String distance;

  Transaction({
    required this.id,
    required this.trackerdeviceid,
    required this.eventId,
    required this.participantid,
    required this.time,
    required this.speed,
    required this.hr,
    required this.latitude,
    required this.logitude,
    required this.distance,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      c_id : id,
      c_trackerdeviceid: trackerdeviceid,
      c_eventid: eventId,
      c_participantid: participantid,
      c_time: time,
      c_speed: speed,
      c_hr: hr,
      c_distance: latitude,
      c_latitude: logitude,
      c_longitude: distance
    };
  }

  factory Transaction.fromMap(Map<dynamic, dynamic> data) {
    return Transaction(
      id: data[c_id],
      trackerdeviceid: data[c_trackerdeviceid],
      eventId: data[c_eventid],
      participantid: data[c_participantid],
      time: data[c_time],
      speed: data[c_speed],
      hr: data[c_hr],
      distance: data[c_distance],
      latitude: data[c_latitude],
      logitude: data[c_longitude]
    );
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return '''Transaction{id: $id, trackerdeviceid: $trackerdeviceid, 
        eventid: $eventId, 
        participantid: $participantid, time: $time, 
        speed: $speed, hr: $hr, latitude: $latitude, logitude: $logitude, 
        distance: $distance}''';
  }
}