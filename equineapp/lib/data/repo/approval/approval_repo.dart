import 'package:EquineApp/data/models/api_response.dart';

import '../../models/approvalRequest_model.dart';
import '../../models/tenant_model.dart';

abstract class ApprovalRepo {
  Future<ApiResponse> postApprovalStatus({required Map data});
  Future<List<ApprovalRequest>> getApprovalsByTenant({required String id}) ;
  Future<List<ApprovalRequest>> getRequestsByUser({required String id}) ;
}
