import 'dart:convert';

import 'package:EquineApp/data/models/api_response.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/bloodtest_result.dart';
import '../../service/service.dart';
import 'bloodtest_repo.dart';

class bloodtestrepoimpl implements bloodtestrepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addbloodtest({
    required String horseId,
    required String dateOfBirth,
    required String BloodtestElementId,
    required String BloodtestTypeId,
    required String result,
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat =
          DateFormat('yyyy-MM-ddTHH:mm:ss'); // ISO 8601 with time.

      logger.d("Performing add blood test: tenant id: $tenantId");

      // Convert dateOfBirth to server format with current time
      String convertDateToServerFormat(String dateOfBirth) {
        try {
          final DateTime parsedDate = _inputDateFormat.parse(dateOfBirth);
          final DateTime now = DateTime.now();

          final DateTime dateWithCurrentTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            now.hour,
            now.minute,
            now.second,
          );

          return _serverDateFormat.format(dateWithCurrentTime);
        } catch (e) {
          logger.e("Date parsing error: $e");
          return '';
        }
      }

      String dateOfRecord = convertDateToServerFormat(dateOfBirth);

      Map data = {
        "horseBloodTest": {
          "horse": {"id": horseId},
          "bloodTestType": {"id": BloodtestTypeId},
          "bloodTestElements": [
            {
              "id": BloodtestElementId,
              "resultValue": result,
            }
          ],
          "tenantid": tenantId,
          "testDatetime": dateOfRecord,
          // "resultValue": result,
          "remarks": ""
        }
      };

      final String url = '${ApiPath.getUrlPath(ApiPath.addBloodtest())}';
      final response = await httpApiService.postCall(url, data);
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
  Future<ApiResponse> updatebloodtest({
    required int id,
    required String horseId,
    required String dateOfBirth,
    required String BloodtestElementId,
    required String BloodtestTypeId,
    required String result,
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat =
          DateFormat('yyyy-MM-ddTHH:mm:ss'); // ISO 8601 with time.

      logger.d("Performing add blood test: tenant id: $tenantId");

      // Convert dateOfBirth to server format with current time
      String convertDateToServerFormat(String dateOfBirth) {
        try {
          final DateTime parsedDate = _inputDateFormat.parse(dateOfBirth);
          final DateTime now = DateTime.now();

          final DateTime dateWithCurrentTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            now.hour,
            now.minute,
            now.second,
          );

          return _serverDateFormat.format(dateWithCurrentTime);
        } catch (e) {
          logger.e("Date parsing error: $e");
          return '';
        }
      }

      String dateOfRecord = convertDateToServerFormat(dateOfBirth);

      Map data = {
        "horseBloodTest": {
          "id": id,
          "horse": {"id": horseId},
          "bloodTestType": {"id": BloodtestTypeId},
          "bloodTestElements": [
            {
              "id": BloodtestElementId,
              "resultValue": result,
            }
          ],
          "tenantid": tenantId,
          "testDatetime": dateOfRecord,
          // "resultValue": result,
          "remarks": ""
        }
      };

      final String url = '${ApiPath.getUrlPath(ApiPath.updateBloodtest())}';
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
  Future<ApiResponse> getBloodTestResults({
    required String horseId,
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getBloodTestResults(tenantId: tenantId, horseId: horseId))}';
      final response = await httpApiService.getCall(url);
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
  Future<BloodTestResult> getBloodTestResultsbyId({
    required int id,
  }) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllBloodTestResultsbyId(id: id))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = jsonDecode(response.body.toString());

        // Assuming the API response structure returns a single horse object
        final horseBody = BloodTestResult.fromJson(data['bloodTest']);

        return horseBody;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch horse details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<ApiResponse> getBloodTestHorseTenantResult(
      {required String horseId, required String testDate}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getBloodTestHorseTenantResult(tenantId: tenantId, horseId: horseId, testDate: testDate))}';
      final response = await httpApiService.getCall(url);
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
  Future<void> deleteBloodTestById({required String id}) async {
    try {
      final String url =
          ApiPath.getUrlPath(ApiPath.deleteBloodTestById(id: id));
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
