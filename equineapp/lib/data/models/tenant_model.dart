class TenantModel {
  final int id;
  final String plan;
  final String planName;
  final String paymentModel;
  final int user;
  final String subEnddate;
  final String subStartdate;
  final String subStatus;
  final String status;
  final String tenantName;

  TenantModel({
    required this.id,
    required this.planName,
    required this.plan,
    required this.paymentModel,
    required this.user,
    required this.subEnddate,
    required this.subStartdate,
    required this.subStatus,
    required this.status,
    required this.tenantName,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'],
      plan: json['plan']?['name'] ?? '',
      paymentModel: json['paymentModel']?['name'] ?? '',
      planName: json['plan']?['name'] ?? '',
      user: 0,
      subEnddate: json['subEnddate'] ?? '',
      subStartdate: json['subStartdate'] ?? '',
      subStatus: json['subStatus'] ?? '',
      status: json['status'] ?? '',
      tenantName: json['tenantName'] ?? '',
    );
  }
}
