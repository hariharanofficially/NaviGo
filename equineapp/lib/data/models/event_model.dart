class EventModel {
  final int id;
  final String name;
  final String shortname;
  final String startdate;
  final String countryiso;
  final String locationname;
  final String category;
  final String groupName;
  final String? endDate;
  final int? eventGroup;
  final int? eventType;
  final int? eventcountry;
  final String? rideStartTime;
  final String? rideDate;
  final String raceType;
  final String raceTimeoftheDay;
  final String cityName;
  final String source;
  final String vendorName;

  EventModel({
    this.rideDate,
    required this.id,
    required this.name,
    required this.shortname,
    required this.startdate,
    required this.countryiso,
    required this.locationname,
    required this.category,
    required this.groupName,
    this.endDate,
    this.eventGroup,
    this.eventType,
    this.eventcountry,
    this.rideStartTime,
    required this.raceType,
    required this.raceTimeoftheDay,
    required this.cityName,
    required this.source,
    required this.vendorName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'].toInt(),
      name: json['name'] ?? "",
      shortname: json['shortName'] ?? "",
      startdate: json['startDate'] ?? "",
      countryiso: json['country']?['iso'] ?? "IND",
      locationname: json['locationName'] ?? "",
      category: json['category'] ?? "race",
      groupName: json['groupName'] ?? "morning",
      endDate: json['endDate'] ?? "",
      eventGroup: json['eventGroup']?['id'] != null
          ? int.tryParse(json['eventGroup']['id'].toString())
          : null,
      eventType: json['eventType']?['id'] != null
          ? int.tryParse(json['eventType']['id'].toString())
          : null,
      eventcountry: json['country']?['id'] != null
          ? int.tryParse(json['country']['id'].toString())
          : null,
      // eventGroup: json['eventGroup']?['id'] ?? "",
      // eventType: json['eventType']?['id'] ?? "",
      rideStartTime: json['rideStartTime'] ?? "",
      rideDate: json['rideDate'] ?? "",
      raceType: json['raceType'] ?? "race",
      raceTimeoftheDay: json['raceTimeoftheDay'] ?? "morning",
      cityName: json['city'] ?? "chennai",
      source: json['source'] ?? "source",
      vendorName: json['vendorName'] ?? "jack",
    );
  }
}
