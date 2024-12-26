import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/horse_model.dart';
import '../../models/roles.dart';
import '../../service/service.dart';
import 'roles_repo.dart';
import '../horse/horse_repo.dart';

class RolesRepoImpl implements RolesRepo {
  Logger logger = new Logger();

  @override
  Future<RolesModel> getRolesByUserAndTenant() async {
    try {
      String userId = await cacheService.getString(name: 'userId');
      String tenantId = await cacheService.getString(name: 'tenantId');
      final String url = '${ApiPath.getUrlPath(ApiPath.getRolesByUserAndTenant(userId: userId, tenantId: tenantId))}';

      logger.d("==== " + url);
      // Make the API call
      final response = await httpApiService.getCall(url);
      logger.d("after get call ====== ");
      // Log the response body for debugging
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = jsonDecode(response.body.toString());

        // Assuming the API response structure returns a single horse object
        final roles = RolesModel.fromJson(data['roles']);

        // Return the HorseModel instance
        return roles;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch roles details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Log and throw a more descriptive error
      logger.e(e.toString());
      throw RepoException("Error while fetching horse details");
    }
  }

}
