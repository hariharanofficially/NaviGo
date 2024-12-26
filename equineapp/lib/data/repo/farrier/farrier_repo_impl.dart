import 'dart:convert';

import 'package:EquineApp/data/models/api_response.dart';
import 'package:EquineApp/data/models/farrier_model.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../service/service.dart';
import 'farrier_repo.dart';

class FarrierRepoImpl implements FarrierRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addfarrier({
    required String horseId,
    required String shoeDatetime,
    required String foreShoeType,
    required String foreShoeSpecification,
    required String foreShoeComplement,
    required String hindShoeType,
    required String hindShoeSpecification,
    required String hindShoeComplement,
    required String surfaceType,
  }) async {
    // TODO: implement addfarrier
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      String shoeDatetimeForServer = shoeDatetime.split(".")[0];

      Map<String, dynamic> data = {
        "horseFarrier": {
          "horse": {"id": horseId},
          "foreShoeType": {"id": foreShoeType},
          "foreShoeSpecification": {"id": foreShoeSpecification},
          "foreShoeComplement": {"id": foreShoeComplement},
          "hindShoeType": {"id": hindShoeType},
          "hindShoeSpecification": {"id": hindShoeSpecification},
          "hindShoeComplement": {"id": hindShoeComplement},
          "surfaceType": {"id": surfaceType},
          "tenantid": tenantId,
          "shoeDatetime": shoeDatetimeForServer
        }
      };

      // Send the HTTP POST request
      final String url = '${ApiPath.getUrlPath(ApiPath.addfarrier())}';
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());

      // Handle response
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        logger.d(responseData.toString());

        // Extract the stable ID from the response
        int FarrierId = responseData['horseFarrier']['id'];

        // Save the stable ID to cache or any storage service
        cacheService.setString(name: 'FarrierId', value: FarrierId.toString());
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }
  @override
  Future<ApiResponse> updatefarrier({
    required int id,
    required String horseId,
    required String shoeDatetime,
    required String foreShoeType,
    required String foreShoeSpecification,
    required String foreShoeComplement,
    required String hindShoeType,
    required String hindShoeSpecification,
    required String hindShoeComplement,
    required String surfaceType,
  }) async {
    // TODO: implement addfarrier
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      String shoeDatetimeForServer = shoeDatetime.split(".")[0];

      Map<String, dynamic> data = {
        "horseFarrier": {
          "id":id,
          "horse": {"id": horseId},
          "foreShoeType": {"id": foreShoeType},
          "foreShoeSpecification": {"id": foreShoeSpecification},
          "foreShoeComplement": {"id": foreShoeComplement},
          "hindShoeType": {"id": hindShoeType},
          "hindShoeSpecification": {"id": hindShoeSpecification},
          "hindShoeComplement": {"id": hindShoeComplement},
          "surfaceType": {"id": surfaceType},
          "tenantid": tenantId,
          "shoeDatetime": shoeDatetimeForServer
        }
      };

      // Send the HTTP POST request
      final String url = '${ApiPath.getUrlPath(ApiPath.updatefarrier())}';
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());

      // Handle response
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        logger.d(responseData.toString());

        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }
  @override
  Future<List<FarrierModel>> getAllFarrier() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      // Ensure tenantId is not null before proceeding
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }
      var horsesId = await cacheService.getString(name: 'horsesId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllfarrier(tenantId: tenantId, horseid: horsesId))}';

      final response = await httpApiService.getCall(url);
      logger.d("farrier start :${response.body.toString()}");
      if (response.statusCode == 200) {
        logger.d("farrier enter :${response.body.toString()}");
        var data = jsonDecode(response.body.toString());
        final List<FarrierModel> farrier = (data['horseFarriers'] as List)
            .map((e) => FarrierModel.fromJson(e))
            .toList();
        logger.d("farrier end :${response.body.toString()}");
        return farrier;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching horseTraining");
    }
  }

  @override
  Future<FarrierModel> getAllFarrierById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllfarrierbyId(id: id))}';

      // Make the API call
      final response = await httpApiService.getCall(url);
      // Log the response body for debugging
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = jsonDecode(response.body.toString());

        // Assuming the API response structure returns a single horse object
        final farrier = FarrierModel.fromJson(data['horseFarrier']);
        // Extract the stable ID from the response
        int FarrierId = responseData['horseFarrier']['id'];
        logger.d("Farrier ID: $FarrierId");

        // Save the stable ID to cache or any storage service
        cacheService.setString(
            name: 'horseFarrierId', value: FarrierId.toString());
        // Return the TreatmentModel instance
        return farrier;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch horse details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching Treatment details");
    }
  }

  @override
  Future<void> deletefarrier({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deletefarrier(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete rider");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting rider");
    }
  }
}
