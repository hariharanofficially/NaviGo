import 'dart:convert';

import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/stable_model.dart';
import '../../service/service.dart';
import 'stable_repo.dart';

class StableRepoImpl implements StableRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addStable(
      {required String tenantId, required String stablename}) async {
    try {
      Map data = {};
      var stable = {};
      stable["name"] = stablename;
      stable["tenantid"] = tenantId;
      data["stable"] = stable;

      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addStable())}';
      logger.d(url);
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        // Parse the API response
        var responseData = jsonDecode(response.body.toString());
        logger.d(responseData.toString());

        // Extract the stable ID from the response
        int stableId = responseData['stable']['id'];

        // Save the stable ID to cache or any storage service
        cacheService.setString(name: 'STABLEID', value: stableId.toString());
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<ApiResponse> updateStable(
      {required int stableId,
      required String tenantId,
      required String stablename}) async {
    try {
      Map data = {
        "stable": {"id": stableId, "name": stablename, "tenantid": tenantId}
      };

      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateStable())}';
      logger.d(url);
      final response = await httpApiService.putCall(url, data);
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
  Future<List<StableModel>> getAllStable(String tenantId) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllStable(tenantId))}';
      logger.d("===" + url);
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<StableModel> stables = (data['stables'] as List)
            .map((stable) => StableModel.fromJson(stable))
            .toList();
        return stables;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<StableModel> getAllStableById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllStableById(id: id))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      int stableId = responseData['stable']['id'];
      cacheService.setString(name: 'stableId', value: stableId.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final stables = StableModel.fromJson(data['stable']);
        return stables;
      } else {
        throw RepoException(
            "Failed to fetch rider details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<void> deleteStableById({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteStableById(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());

      if (response.statusCode != 200) {
        throw RepoException("Failed to delete horse");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting horse");
    }
  }
}
