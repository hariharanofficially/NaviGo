import 'dart:convert';

import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/sharedtenant_model.dart';
import '../../models/tenant_model.dart';
import '../../models/usertenant_model.dart';
import '../../service/service.dart';
import 'tenant_repo.dart';

class TenantRepoImpl implements TenantRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> postTenant({required Map data}) async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.postTenant())}';
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
  Future<UserTenantModel> getTenantbyid({required String id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getTenantbyid(id: id))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<TenantModel> tenants = (data['alltenant']?['subscriptionTenant'] as List)
            .map((tenants) => TenantModel.fromJson(tenants))
            .toList();
        final List<SharedTenantModel> sharedTenants = (data['alltenant']?['sharedTenant'] as List)
            .map((tenants) => SharedTenantModel.fromJson(tenants))
            .toList();
        UserTenantModel resp = new UserTenantModel(sharedTenants: sharedTenants, subscriptionTenants:tenants );
        return resp;
      }
      return new UserTenantModel(sharedTenants: [], subscriptionTenants:[] );
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching tenants");
    }
  }
}
