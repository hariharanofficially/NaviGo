class RegisteredDevice {
  final int deviceId;
  final String deviceName;
  final String macId;
  final String hrCensorId;
  final bool saved;
  bool paired;
  bool online;
  final int frequency;

  RegisteredDevice({
    required this.deviceId,
    required this.deviceName,
    required this.macId,
    required this.hrCensorId,
    required this.saved,
    required this.paired,
    required this.online,
    required this.frequency
  });

  factory RegisteredDevice.initObject() {
    return RegisteredDevice(
        deviceId : 0,
        deviceName: "",
        macId: "",
        hrCensorId: "",
        saved: false,
        paired: false,
        online: false,
        frequency: 2);
  }
  factory RegisteredDevice.fromJson(Map<String, dynamic> json) {
    return RegisteredDevice(
      deviceId: json['id'],
      deviceName: json['trackerDeviceId'],
      macId: json['deviceMacId'],
      hrCensorId: json['heartRateCensorId'],
      saved: true,
      paired: false,
      online: false,
      frequency: json['frequancy']
    );
  }
}
