import 'package:EquineApp/data/models/api_response.dart';

import '../../models/getmodel.dart';

abstract class SharecodesRepo {
  Future<ApiResponse> postsharecodes({required String roleId});
  Future<ApiResponse> validateshare({required String codename});
  Future<List<RoleModel>> getroles();
}
