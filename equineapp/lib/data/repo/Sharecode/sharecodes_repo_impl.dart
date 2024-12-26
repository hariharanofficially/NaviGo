import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/getmodel.dart';
import '../../service/service.dart';
import 'sharecodes_repo.dart';
import 'dart:convert';

class SharecodesRepoImpl implements SharecodesRepo {
  Logger logger = Logger();

  @override
  Future<ApiResponse> postsharecodes({required String roleId}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      String token = await cacheService.getString(name: 'jwt');

      Map<String, dynamic> data = {
        "sharecode": {
          "tenant": { "id": tenantId
          },
          "role": {
            "id": roleId
          }
        }
      };

      logger.d('JWT Token: $token');
      final String url = ApiPath.getUrlPath(ApiPath.postshare());
      logger.d('Posting to URL: $url with data: $data');

      final response = await httpApiService.postCall(url, data);
      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body.toString()}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final qrCode = responseData['sharecode']['qrcode'];
        final sharecode = responseData['sharecode']['shareCode'];
        cacheService.setString(name: 'qrCode', value: qrCode);
        cacheService.setString(name: 'sharecode', value: sharecode);
        return ApiResponse(
          statusCode: response.statusCode,
          message: response.body.toString(),
          // message: responseData['message'],
          // data: qrCode, // Assuming ApiResponse has a field `data` for QR code
        );
      } else {
        logger.w('Unexpected status code: ${response.statusCode}');
        return ApiResponse(
          statusCode: response.statusCode,
          message: response.body.toString(),
        );
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      throw RepoException("Error while fetching share codes: ${e.toString()}");
    }
  }

  @override
  Future<ApiResponse> validateshare({required String codename}) async {
    try {
      var userId = await cacheService.getString(name: 'userId');
      String token = await cacheService.getString(name: 'jwt');

      Map<String, dynamic> data = {
        "code": codename,
        "user": {"id": userId}
      };

      logger.d('JWT Token: $token');
      final String url = ApiPath.getUrlPath(ApiPath.validateshare());
      logger.d('Posting to URL: $url with data: $data');

      final response = await httpApiService.postCall(url, data);
      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body.toString()}');

      if (response.statusCode == 200) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: response.body.toString(),
        );
      } else {
        logger.w('Unexpected status code: ${response.statusCode}');
        return ApiResponse(
          statusCode: response.statusCode,
          message: response.body.toString(),
        );
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      throw RepoException("Error while fetching share codes: ${e.toString()}");
    }
  }
  @override
  Future<List<RoleModel>> getroles() async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getroles())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<RoleModel> roles = (data['roles'] as List)
            .map((roles) => RoleModel.fromJson(roles))
            .toList();
        return roles;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching roles");
    }
  }
}
