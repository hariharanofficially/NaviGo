import 'dart:convert';

import 'package:EquineApp/data/models/api_response.dart';
import 'package:EquineApp/data/models/treatment_model.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../service/service.dart';
import 'treatment_repo.dart';

class TreatmentRepoImpl implements TreatmentRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addtreatment({
    required String horseId,
    required String notes,
    required String treatmentDatetime,
    required String nextCheckupDatetime,
    required String treatmenttypeid,
  }) async {
    try {
      logger.d("Starting addtreatment request...");

      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("Performing add body measurement in impl: tenant id: $tenantId");
      // Convert date of birth to server format
      String treatmentDatetimeForServer = treatmentDatetime.split(".")[0];
      // Convert date of birth to server format
      String nextCheckupDatetimeForServer = nextCheckupDatetime.split(".")[0];
      Map<String, dynamic> data = {
        "horseTreatement": {
          "horse": {"id": horseId},
          "treatmentType": {"id": treatmenttypeid},
          "tenantid": tenantId,
          "notes": notes,
          "treatmentDatetime": treatmentDatetimeForServer,
          "nextCheckupDatetime": nextCheckupDatetimeForServer
        }
      };
      logger.d("Request data: ${json.encode(data)}");

      // Send the HTTP POST request
      final String url = '${ApiPath.getUrlPath(ApiPath.addtreatment())}';
      logger.d("Request URL: $url");
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.postCall(url, data);
      logger.d("HTTP response status: ${response.statusCode}");
      logger.d("HTTP response body: ${response.body}");
      // Handle response
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        logger.d("Parsed response data: $responseData");

        // Extract the stable ID from the response
        int TreatmentId = responseData['horseTreatment']['id'];
        logger.d("Treatment ID: $TreatmentId");

        // Save the stable ID to cache or any storage service
        cacheService.setString(
            name: 'TreatmentsId', value: TreatmentId.toString());
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }

  @override
  Future<ApiResponse> updatetreatment({
    required int id,
    required String horseId,
    required String notes,
    required String treatmentDatetime,
    required String nextCheckupDatetime,
    required String treatmenttypeid,
  }) async {
    try {
      logger.d("Starting addtreatment request...");

      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("Performing add body measurement in impl: tenant id: $tenantId");
      // Convert date of birth to server format
      String treatmentDatetimeForServer = treatmentDatetime.split(".")[0];
      // Convert date of birth to server format
      String nextCheckupDatetimeForServer = nextCheckupDatetime.split(".")[0];
      Map<String, dynamic> data = {
        "horseTreatement": {
          "id": id,
          "horse": {"id": horseId},
          "treatmentType": {"id": treatmenttypeid},
          "tenantid": tenantId,
          "notes": notes,
          "treatmentDatetime": treatmentDatetimeForServer,
          "nextCheckupDatetime": nextCheckupDatetimeForServer
        }
      };
      logger.d("Request data: ${json.encode(data)}");

      // Send the HTTP POST request
      final String url = '${ApiPath.getUrlPath(ApiPath.updatetreatment())}';
      logger.d("Request URL: $url");
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.putCall(url, data);
      logger.d("HTTP response status: ${response.statusCode}");
      logger.d("HTTP response body: ${response.body}");
      // Handle response
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        logger.d("Parsed response data: $responseData");

        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }

  @override
  Future<List<TreatmentModel>> getAllTreament() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      // Ensure tenantId is not null before proceeding
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }
      var horsesId = await cacheService.getString(name: 'horsesId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlltreament(tenantId: tenantId, horseid: horsesId))}';

      final response = await httpApiService.getCall(url);
      logger.d("Treatment start :${response.body.toString()}");
      if (response.statusCode == 200) {
        logger.d("Treatment enter :${response.body.toString()}");
        var data = jsonDecode(response.body.toString());
        final List<TreatmentModel> treatment = (data['horseTreatments'] as List)
            .map((e) => TreatmentModel.fromJson(e))
            .toList();
        logger.d("Treatment end :${response.body.toString()}");
        return treatment;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching horseTraining");
    }
  }

  @override
  Future<TreatmentModel> getAllTreamentById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlltreamentbyId(id: id))}';

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
        final treatment = TreatmentModel.fromJson(data['horseTreatment']);
        // Extract the stable ID from the response
        int TreatmentId = responseData['horseTreatment']['id'];
        logger.d("Treatment ID: $TreatmentId");

        // Save the stable ID to cache or any storage service
        cacheService.setString(
            name: 'horseTreatmentId', value: TreatmentId.toString());
        // Return the TreatmentModel instance
        return treatment;
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
  Future<void> deletetreatment({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deletetreatment(id: id));
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
