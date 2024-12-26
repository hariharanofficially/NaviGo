import 'package:EquineApp/data/models/api_response.dart';

import '../../models/tenant_model.dart';
import '../../models/usertenant_model.dart';

abstract class TenantRepo {
  Future<ApiResponse> postTenant({required Map data});
  Future<UserTenantModel> getTenantbyid({required String id}) ;
}
