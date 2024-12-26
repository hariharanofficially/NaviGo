class Participant {
  final int id;
  final String startNumber;
  final String event;
  final String rider;
  final String horse;
  final String owner;
  final String stable;
  final String trackerDevice;
  final int? horseId;
  final int? riderId;
  final int? stableId;

  Participant({
    required this.id,
    required this.startNumber,
    required this.event,
    required this.rider,
    required this.horse,
    required this.owner,
    required this.stable,
    required this.trackerDevice,
    this.horseId,
    this.riderId,
    this.stableId,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      startNumber: json['startNumber'],
      event: json['event']['name'] ?? "",
      rider: json['rider']['name'] ?? "",
      horse: json['horse']['name'] ?? "",
      owner: json['owner']['name'] ?? "",
      stable: json['stable']['name'] ?? "",
      trackerDevice: json['trackerDevice']['id'].toString() ?? "",
      id: json['id'],
      stableId: json['stable']['id'] ?? "",
      riderId: json['rider']['id'] ?? "",
      horseId: json['horse']['id'] ?? "",
    );
  }
}
