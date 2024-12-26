import 'dart:convert';

import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/approvalRequest_model.dart';
import '../../models/tenant_model.dart';
import '../../service/service.dart';
import 'approval_repo.dart';

class ApprovalRepoImpl implements ApprovalRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> postApprovalStatus({required Map data}) async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.postApprovalStatus())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<List<ApprovalRequest>> getApprovalsByTenant({required String id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getApprovalsByTenant(id: id))}';
      logger.d(url);
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<ApprovalRequest> approvals = (data['approvals'] as List)
            .map((approval) => ApprovalRequest.fromJson(approval))
            .toList();
        return approvals;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching tenants");
    }
  }

  @override
  Future<List<ApprovalRequest>> getRequestsByUser({required String id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getRequestsByUser(id: id))}';
      logger.d(url);
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<ApprovalRequest> approvals = (data['approvals'] as List)
            .map((approval) => ApprovalRequest.fromJson(approval))
            .toList();
        return approvals;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching tenants");
    }
  }
}
