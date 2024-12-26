class SharedTenantModel {
  final int id;
  final String subEnddate;
  final String subStartdate;
  final String subStatus;
  final String status;
  final String horseCount;
  final String stableCount;
  final String eventCount;
  final String tenantName;

  SharedTenantModel({
    required this.id,
    required this.subEnddate,
    required this.subStartdate,
    required this.subStatus,
    required this.status,
    required this.horseCount,
    required this.stableCount,
    required this.eventCount,
    required this.tenantName
  });

  factory SharedTenantModel.fromJson(Map<String, dynamic> json) {
    return SharedTenantModel(
      id: json['id'],
      subEnddate: json['subEnddate'] ?? '',
      subStartdate: json['subStartdate'] ?? '',
      subStatus: json['subStatus'] ?? '',
      status: json['status'] ?? '',
      horseCount: json['horsecount'] ?? '0',
      stableCount: json['stablecount'] ?? '0',
      eventCount: json['eventcount'] ?? '0',
      tenantName: json['tenantName'] ?? '',
    );
  }
}
