import 'package:EquineApp/data/models/horse_model.dart';

import '../../models/api_response.dart';
import '../../models/roles.dart';

abstract class RolesRepo {
  Future<RolesModel> getRolesByUserAndTenant();
}
