import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/horse_model.dart';
import '../../service/service.dart';
import 'horse_repo.dart';

class HorseRepoImpl implements HorseRepo {
  Logger logger = new Logger();

  @override
  Future<List<HorseModel>> getAllHorses({required String tenantId}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      var planId = await cacheService.getString(name: 'planId');
      // Ensure tenantId is not null before proceeding
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }

      // Construct the URL without unnecessary string interpolation
      final String url = ApiPath.getUrlPath(ApiPath.getAllHorses(id: tenantId));

      // Make the API call
      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<HorseModel> horses = (data['horses'] as List)
            .map((event) => HorseModel.fromJson(event))
            .toList();

        return horses;
      }

      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching horses");
    }
  }

  @override
  Future<HorseModel> getHorseById({required int id}) async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getHorseById(id: id))}';

      // Make the API call
      final response = await httpApiService.getCall(url);

      // Log the response body for debugging
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      int horsesId = responseData['horse']['id'];
      cacheService.setString(name: 'horsesId', value: horsesId.toString());
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = jsonDecode(response.body.toString());

        // Assuming the API response structure returns a single horse object
        final horse = HorseModel.fromJson(data['horse']);

        // Return the HorseModel instance
        return horse;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch horse details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Log and throw a more descriptive error
      logger.e(e.toString());
      throw RepoException("Error while fetching horse details");
    }
  }

  @override
  Future<ApiResponse> updatehorse(
      {required String name,
      required String currentName,
      required String originalName,
      required String dateOfBirth,
      required String microchipNo,
      required int id,
      required String remarks,
      required String breedId,
      required String divisionId,
      required String active,
      required String stableId}) async {
    try {
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat = DateFormat('yyyy-MM-dd');

      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("performing update horse in impl : tenant id : " + tenantId);
      String convertDateToServerFormat(String date) {
        try {
          final DateTime parsedDate = _inputDateFormat.parse(date);
          return _serverDateFormat.format(parsedDate);
        } catch (e) {
          // Handle parsing error
          return '';
        }
      }

      // Convert date of birth to server format
      String dateOfBirthForServer = convertDateToServerFormat(dateOfBirth);
      Map data = {
        "horse": {
          "id": id,
          "name": name,
          "currentName": currentName,
          "originalName": originalName,
          "tenantid": "" + tenantId,
          "breed": {"id": "" + breedId},
          "breeder": {"id": "1"},
          "countryOfResidence": {"id": "1"},
          "countryOfBirth": {"id": "1"},
          "dateOfBirth": dateOfBirthForServer,
          "gender": {"id": "1"},
          "color": {"id": "1"},
          "microchipNo": microchipNo,
          "division": {"id": "" + divisionId},
          "stable": {"id": "" + stableId},
          "fei": {
            "active": false,
            "passport": "UAE875432",
            "passportIssueDate": "2022-09-09",
            "expiryDate": "2022-09-09",
            "registration": "",
            "registrationDate": "2022-09-09",
            "lastInfluenzaDate": null,
            "qualification": null
          },
          "remarks": remarks,
          "active": active
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateHorse())}';
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
  Future<void> deleteHorsesById({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteHorsesById(id: id));
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

  @override
  Future<ApiResponse> addHorses(
      {required String name,
      required String currentName,
      required String originalName,
      required String dateOfBirth,
      required String microchipNo,
      required String remarks,
      required String breedId,
      required String divisionId,
      required String active,
      required String stableId}) async {
    try {
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat = DateFormat('yyyy-MM-dd');
      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("performing add horse in impl : tenant id : " + tenantId);
      String convertDateToServerFormat(String date) {
        try {
          final DateTime parsedDate = _inputDateFormat.parse(date);
          return _serverDateFormat.format(parsedDate);
        } catch (e) {
          // Handle parsing error
          return '';
        }
      }

      // Convert date of birth to server format
      String dateOfBirthForServer = convertDateToServerFormat(dateOfBirth);
      Map data = {
        "horse": {
          "name": name,
          "currentName": currentName,
          "originalName": originalName,
          "tenantid": "" + tenantId,
          "breed": {"id": "" + breedId},
          "breeder": {"id": "1"},
          "countryOfResidence": {"id": "1"},
          "countryOfBirth": {"id": "1"},
          "dateOfBirth": dateOfBirthForServer,
          "gender": {"id": "1"},
          "color": {"id": "1"},
          "microchipNo": microchipNo,
          "division": {"id": "" + divisionId},
          "stable": {"id": "" + stableId},
          "fei": {
            "active": false,
            "passport": "UAE875432",
            "passportIssueDate": "2022-09-09",
            "expiryDate": "2022-09-09",
            "registration": "",
            "registrationDate": "2022-09-09",
            "lastInfluenzaDate": null,
            "qualification": null
          },
          "remarks": remarks,
          "active": active
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addHorses())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());

      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());

      // Extract the stable ID from the response
      int horseId = responseData['horse']['id'];

      // Save the stable ID to cache or any storage service
      cacheService.setString(name: 'horseId', value: horseId.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }
}
