import 'package:EquineApp/data/models/sharedtenant_model.dart';
import 'package:EquineApp/data/models/tenant_model.dart';

class UserTenantModel {
  final List<TenantModel> subscriptionTenants;
  final List<SharedTenantModel> sharedTenants;

  UserTenantModel({
    required this.subscriptionTenants,
    required this.sharedTenants
  });
}
