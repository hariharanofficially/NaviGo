class TrackerDevices {
  final int userDeviceId;
  final String trackerDeviceId;
  final String deviceMacId;
  final String heartRateCensorId;
  final String gpsSignalStrength;
  TrackerDevices({
    required this.userDeviceId,
    required this.trackerDeviceId,
    required this.deviceMacId,
    required this.heartRateCensorId,
    required this.gpsSignalStrength,
  });
  factory TrackerDevices.fromJson(Map<String, dynamic> json) {
    return TrackerDevices(
        userDeviceId: json['id'],
        trackerDeviceId: json['trackerDeviceId'],
        deviceMacId: json['deviceMacId'],
        heartRateCensorId: json['heartRateCensorId'],
        gpsSignalStrength: json['gpsSignalStrength']);
  }
}
