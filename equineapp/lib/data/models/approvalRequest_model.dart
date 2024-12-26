import 'package:logger/logger.dart';

class ApprovalRequest {
  Logger logger = new Logger();
  final String id;
  final String shareCode;
  final String role;
  final String requestedFirstName;
  final String requestedLastName;
  final String requestedEmail;
  final DateTime requestedOn;
  final String approvalStatus;
  final String approvedBy;
  final DateTime approvedOn;

  ApprovalRequest({
    required this.id,
    required this.shareCode,
    required this.role,
    required this.requestedFirstName,
    required this.requestedLastName,
    required this.requestedEmail,
    required this.requestedOn,
    required this.approvalStatus,
    required this.approvedBy,
    required this.approvedOn
  });

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) {
    //logger.d(json['id']);
    return ApprovalRequest(
      id: json['id'].toString(),
        shareCode: json['userSharecode']?['shareCode'] ?? '',
        role: json['userSharecode']?['role']?['name'] ?? '',
      requestedFirstName: json['requestBy']?['firstName'] ?? '',
      requestedLastName: json['requestBy']?['lastName'] ?? '',
      requestedEmail: json['requestBy']?['email'] ?? '',
      requestedOn: DateTime.now(),
      approvalStatus: json['approvalStatus'] ?? 'pending' ,
      approvedBy: json['approvalBy']?['firstName'] ?? '',
      approvedOn: DateTime.now()
    );
  }
}
