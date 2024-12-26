import 'dart:convert';

import 'package:EquineApp/data/models/api_response.dart';
import 'package:EquineApp/data/models/body_model.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../service/service.dart';
import 'bodymeasurement_repo.dart';

class BodyMeasurementRepoImpl implements BodyMeasurementRepo {
  Logger logger = new Logger();
  @override
  Future<ApiResponse> AddBodyMeasurement(
      {required String dateOfBirth, // This will represent the date portion.
      required String weight,
      required int
          horseId // Assuming weight is provided as a string; you can convert it to double if needed.
      }) async {
    try {
      // Date format conversion
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat =
          DateFormat('yyyy-MM-ddTHH:mm:ss'); // ISO 8601 with time.

      // Retrieve tenantId
      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("Performing add body measurement in impl: tenant id: $tenantId");

      // Convert the provided date of birth to the server format with time.
      String convertDateToServerFormat(String date) {
        try {
          final DateTime parsedDate = _inputDateFormat.parse(date);
          final DateTime now = DateTime.now();
          // Include time information here, you can set the time as needed.
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
          // Handle parsing error
          logger.e("Date parsing error: $e");
          return '';
        }
      }

      // Convert date of birth to server format
      String dateOfBirthForServer = convertDateToServerFormat(dateOfBirth);

      // Create the data map with proper structure and data types
      Map<String, dynamic> data = {
        "horseBody": {
          "horse": {"id": horseId}, // Adjust the horse ID as needed
          "weight": double.tryParse(weight) ??
              0.0, // Converting the weight to a double
          "measuredDatetime": dateOfBirthForServer,
          "height": 0, // Adjust height if needed
          "tenantid": tenantId // Assuming tenantId is a valid string
        }
      };

      // Send the HTTP POST request
      final String url = '${ApiPath.getUrlPath(ApiPath.addbodymeasurement())}';
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());

      // Handle response
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }

  @override
  Future<ApiResponse> updateBodyMeasurement(
      {required String dateOfBirth, // This will represent the date portion.
      required String weight,
      required int horseId,
      required int
          id // Assuming weight is provided as a string; you can convert it to double if needed.
      }) async {
    try {
      // Date format conversion
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat =
          DateFormat('yyyy-MM-ddTHH:mm:ss'); // ISO 8601 with time.

      // Retrieve tenantId
      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("Performing add body measurement in impl: tenant id: $tenantId");

      // Convert the provided date of birth to the server format with time.
      String convertDateToServerFormat(String date) {
        try {
          final DateTime parsedDate = _inputDateFormat.parse(date);
          final DateTime now = DateTime.now();
          // Include time information here, you can set the time as needed.
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
          // Handle parsing error
          logger.e("Date parsing error: $e");
          return '';
        }
      }

      // Convert date of birth to server format
      String dateOfBirthForServer = convertDateToServerFormat(dateOfBirth);

      // Create the data map with proper structure and data types
      Map<String, dynamic> data = {
        "horseBody": {
          "id": id,
          "horse": {"id": horseId}, // Adjust the horse ID as needed
          "weight": double.tryParse(weight) ??
              0.0, // Converting the weight to a double
          "measuredDatetime": dateOfBirthForServer,
          "height": 0, // Adjust height if needed
          "tenantid": tenantId // Assuming tenantId is a valid string
        }
      };

      // Send the HTTP POST request
      final String url =
          '${ApiPath.getUrlPath(ApiPath.updatebodymeasurement())}';
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());

      // Handle response
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }

  @override
  Future<List<BodyModel>> getAllBodyMeasurement() async {
    try {
      var horsesId = await cacheService.getString(name: 'horsesId');

      var tenantId = await cacheService.getString(name: 'tenantId');
      // Ensure tenantId is not null before proceeding
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllbodymeasurement(tenantId: tenantId, horsesid: horsesId))}';

      final response = await httpApiService.getCall(url);

      logger.d("horseBodies start :${response.body.toString()}");
      if (response.statusCode == 200) {
        logger.d("horseBodies enter :${response.body.toString()}");
        var data = jsonDecode(response.body.toString());
        final List<BodyModel> bodies = (data['horseBodies'] as List)
            .map((e) => BodyModel.fromJson(e))
            .toList();
        logger.d("events end :${response.body.toString()}");
        return bodies;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<BodyModel> getAllBodyMeasurementById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllbodymeasurementbyId(id: id))}';

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
        final horseBody = BodyModel.fromJson(data['horseBody']);

        return horseBody;
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
  Future<void> deletebodymeasurement({required int id}) async {
    try {
      final String url =
          ApiPath.getUrlPath(ApiPath.deletebodymeasurement(id: id));
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
