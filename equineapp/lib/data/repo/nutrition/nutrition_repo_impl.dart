import 'dart:convert';

import 'package:EquineApp/data/models/api_response.dart';
import 'package:EquineApp/data/models/nutrition_model.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../service/service.dart';
import 'nutrition_repo.dart';

class NutritionRepoImpl implements NutritionRepo {
  Logger logger = new Logger();
  @override
  Future<ApiResponse> addNutrition(
      {required String nutritionDatetime,
      required String horseId,
      required String foodType,
      required String feeduom,
      required String servingValue}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      String nutritionDatetimeForServer = nutritionDatetime.split(".")[0];
      Map<String, dynamic> data = {
        "horseNutrition": {
          "horse": {"id": horseId},
          "foodType": {"id": foodType},
          "servingDatetime": nutritionDatetimeForServer,
          "servingValue": servingValue,
          "feeduom": {"id": feeduom},
          "tenantid": tenantId
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.addnutrition())}';
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());

      // Handle response
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        logger.d(responseData.toString());

        // Extract the stable ID from the response
        int NutritionId = responseData['horseNutrition']['id'];

        // Save the stable ID to cache or any storage service
        cacheService.setString(
            name: 'NutritionId', value: NutritionId.toString());
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding nutrition");
    }
  }

  @override
  Future<ApiResponse> updateNutrition(
      {required int id,
      required String nutritionDatetime,
      required String horseId,
      required String foodType,
      required String feeduom,
      required String servingValue}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      String nutritionDatetimeForServer = nutritionDatetime.split(".")[0];
      Map<String, dynamic> data = {
        "horseNutrition": {
          "id": id,
          "horse": {"id": horseId},
          "foodType": {"id": foodType},
          "servingDatetime": nutritionDatetimeForServer,
          "servingValue": servingValue,
          "feeduom": {"id": feeduom},
          "tenantid": tenantId
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.updatenutrition())}';
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
      throw RepoException("Error while adding nutrition");
    }
  }

  @override
  Future<List<NutritionModel>> getAllNutrition() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }
      var horsesId = await cacheService.getString(name: 'horsesId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllnutrition(tenantId: tenantId, horseid: horsesId))}';
      final response = await httpApiService.getCall(url);

      logger.d("Nutrition start: ${response.body.toString()}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<NutritionModel> nutrition = (data['horseNutritions'] as List)
            .map((e) => NutritionModel.fromJson(e))
            .toList();
        logger.d("Nutrition end: ${response.body.toString()}");
        return nutrition;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching nutrition data");
    }
  }

  @override
  Future<NutritionModel> getAllNutritionById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllnutritionbyId(id: id))}';

      // Make the API call
      final response = await httpApiService.getCall(url);
      // Log the response body for debugging
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      int horseNutritionId = responseData['horseNutrition']['id'];
      cacheService.setString(
          name: 'horseNutritionId', value: horseNutritionId.toString());
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = jsonDecode(response.body.toString());

        // Assuming the API response structure returns a single horse object
        final nutrition = NutritionModel.fromJson(data['horseNutrition']);
        // Extract the stable ID from the response
        int NutritionId = responseData['horseNutrition']['id'];
        logger.d("Nutrition ID: $NutritionId");

        // Save the stable ID to cache or any storage service
        cacheService.setString(
            name: 'horseNutritionId', value: NutritionId.toString());

        // Return the TreatmentModel instance
        return nutrition;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch nutrition details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching nutrition details");
    }
  }

  @override
  Future<void> deletenutrition({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deletenutrition(id: id));
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
