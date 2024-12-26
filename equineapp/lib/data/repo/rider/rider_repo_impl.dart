import 'dart:convert';

import 'package:EquineApp/data/models/rider_model.dart';
import 'package:EquineApp/data/repo/rider/rider_repo.dart';
import 'package:EquineApp/data/service/service.dart';
import 'package:EquineApp/utils/constants/api_path.dart';
import 'package:EquineApp/utils/exceptions/exceptions.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/api_response.dart';

class RiderRepoImpl implements RiderRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addRider(
      {required String name,
      required String fatherName,
      required String dateOfBirth,
      required String bloodGroup,
      required String remarks,
      required String riderWeight,
      required String mobile,
      required String email,
      required String divisionname,
      required String stablename,
      required String active,
      required String nationality}) async {
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
        "rider": {
          "tenantid": tenantId,
          "name": name,
          "fatherName": fatherName,
          "nationality": {"id": nationality},
          "dateOfBirth": dateOfBirthForServer,
          "gender": "Male",
          "bloodGroup": bloodGroup,
          "addresses": [
            {
              "addressline1": "P.O. Box: 5675",
              "poBox": "5678",
              "city": "Dubai",
              "country": "Unknown",
              "telephone": "04-2215551",
              "fax": "04-2214999",
              "addressType": "OFFICE"
            }
          ],
          "mobile": mobile,
          "email": email,
          "division": {"id": divisionname},
          "stable": {"id": stablename},
          "fei": {
            "active": false,
            "no": "342342342234",
            "expiryDate": "2025-09-09",
            "registration": "",
            "registrationDate": "2022-09-09"
          },
          "remarks": remarks,
          "active": active,
          "riderWeight": riderWeight,
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.addRider())}';
      logger.d(json.encode(data));
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      // Parse the API response
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());

      // Extract the stable ID from the response
      int riderID = responseData['rider']['id'];

      // Save the stable ID to cache or any storage service
      cacheService.setString(name: 'RIDERID', value: riderID.toString());
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
  Future<List<RiderModel>> getAllRider() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      var planId = await cacheService.getString(name: 'planId');
      // Ensure tenantId is not null before proceeding
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllRider(id: tenantId))}';
      logger.d("=== url : " + url);
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<RiderModel> riders = (data['riders'] as List)
            .map((rider) => RiderModel.fromJson(rider))
            .toList();
        return riders;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<RiderModel> getAllRiderById({required int id}) async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getRiderById(id: id))}';
      // Make the API call
      final response = await httpApiService.getCall(url);
      // Log the response body for debugging
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      int horsesId = responseData['rider']['id'];
      cacheService.setString(name: 'riderId', value: horsesId.toString());
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = jsonDecode(response.body.toString());
        final riders = RiderModel.fromJson(data['rider']);
        return riders;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch rider details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<void> deleteRiderById({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteRiderById(id: id));
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

  @override
  Future<ApiResponse> updateRider({
    required int id,
    required String name,
    required String fatherName,
    required String nationality,
    required String dateOfBirth,
    required String bloodGroup,
    required String remarks,
    required String riderWeight,
    required String mobile,
    required String email,
    required String divisionname,
    required String stablename,
    required String active,
  }) async {
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
        "rider": {
          "id": id,
          "tenantid": tenantId,
          "name": name,
          "fatherName": fatherName,
          "nationality": {"id": nationality},
          "dateOfBirth": dateOfBirthForServer,
          "gender": "Male",
          "bloodGroup": bloodGroup,
          "addresses": [
            {
              "addressline1": "P.O. Box: 5675",
              "poBox": "5678",
              "city": "Dubai",
              "country": "Unknown",
              "telephone": "04-2215551",
              "fax": "04-2214999",
              "addressType": "OFFICE"
            }
          ],
          "mobile": mobile,
          "email": email,
          "division": {"id": divisionname},
          "stable": {"id": stablename},
          "fei": {
            "active": false,
            "no": "342342342234",
            "expiryDate": "2025-09-09",
            "registration": "",
            "registrationDate": "2022-09-09"
          },
          "remarks": remarks,
          "active": active,
          "riderWeight": riderWeight,
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateRider())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }
}
