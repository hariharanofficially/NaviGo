class Event_Model {
  final int id;
  final String name;
  final String startdate;
  final String enddate;
  final int tenantid;
  final String eventgroup;
  final String state;
  final String country;
  final String division;
  final String eventType;
  final String groupflag;
  final String shortname;
  final String title;
  final String groupName;
  final String category;
  final String locationname;
  final String city;
  final String rideStartTime;
  final String rideDate;
  final String source;
  final String vendorName;
  final String vendorLogo;
  final String vendorRideId;
  final String phases;
  final String timeZone;

  Event_Model({
    required this.id,
    required this.category,
    required this.city,
    required this.country,
    required this.division,
    required this.enddate,
    required this.eventType,
    required this.eventgroup,
    required this.groupName,
    required this.groupflag,
    required this.locationname,
    required this.name,
    required this.phases,
    required this.rideDate,
    required this.rideStartTime,
    required this.shortname,
    required this.source,
    required this.startdate,
    required this.state,
    required this.tenantid,
    required this.timeZone,
    required this.title,
    required this.vendorLogo,
    required this.vendorName,
    required this.vendorRideId,
  });

  factory Event_Model.fromJson(Map<String, dynamic> json) {
    return Event_Model(
      id: json['id'],
      tenantid: json['tenantid'],
      name: json['name'],
      startdate: json['startDate'] ?? "",
      enddate: json['endDate'] ?? "",
      eventgroup: json['eventGroup']?['name'] ?? "",
      state: json['state']?['name'] ?? "",
      country: json['country']?['name'] ?? "",

      division: json['division']?['name'] ?? "",
      eventType: json['eventType']?['name'] ?? "",
      groupflag: json['groupFlag']?? "",
      shortname: json['shortName']?? "",
      title: json['title'] ?? "",
      groupName: json['groupName'] ?? "",
      category: json['category'] ?? "",
      locationname: json['locationName'] ?? "",
      city: json['city'] ?? "",
      rideStartTime: json['rideStartTime'] ?? "",
      rideDate: json['rideDate'] ?? "",
      source: json['source'] ?? "",
      vendorName: json['vendorName'] ?? "",
      vendorLogo: json['vendorLogo'] ?? "",
      vendorRideId: json['vendorRideId'] ?? "",
      phases: json['phases']?['gateNumber']?['distance']?['loopColor'] ?? "",
      timeZone: json['timeZone'] ?? "",
    );
  }
}
