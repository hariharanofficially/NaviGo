import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../utils/constants/api_path.dart';
import '../../models/training_model.dart';
import '../training/training_repo.dart';
import '../../models/api_response.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../service/service.dart';

class TrainingRepoImpl implements TrainingRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addTraining(
      {required String trainingDatetime,
      required String duration,
      required String horseId,
      required String stableId,
      required String riderId,
      required String trainingId,
      required String surfaceId,
      required String distance,
      required String walk,
      required String trot,
      required String canter,
      required String gallop}) async {
    try {
      // Date format conversion
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat =
          DateFormat('yyyy-MM-ddTHH:mm:ss'); // ISO 8601 with time.
      final DateFormat _inputtime = DateFormat('HH:mm');
      final DateFormat _server_inputtime =
          DateFormat('PTH:mm'); // ISO 8601 with time.
      // Retrieve tenantId
      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("Performing add body measurement in impl: tenant id: $tenantId");

      // Convert the provided date of birth to the server format with time.
      String convertDateToServerFormat(String date) {
        try {
          logger.d("date obtained for date : " + date);
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

      String convertTimeToServerFormat(String date) {
        try {
          logger.d("date obtained : " + date);
          final DateTime parsedDate = _inputtime.parse(date);

          // Include time information here, you can set the time as needed.
          final DateTime dateWithCurrentTime = DateTime(
            parsedDate.day,
            parsedDate.hour,
            parsedDate.minute,
          );
          return _server_inputtime.format(dateWithCurrentTime);
        } catch (e) {
          // Handle parsing error
          logger.e("Date parsing error: $e");
          return '';
        }
      }

      // Convert date of birth to server format
      String trainingDatetimeForServer = trainingDatetime.split(".")[0];
      //convertDateToServerFormat(trainingDatetime);
      String trainingtimeForServer =
          "PT" + duration.split(":")[0] + "Hrs" + duration.split(":")[1] + "Mins";
      // convertTimeToServerFormat(duration);
      // Create the data map with proper structure and data types
      Map<String, dynamic> data = {
        "horseTraining": {
          "horse": {"id": horseId},
          "stables": {"id": stableId},
          "rider": {"id": riderId},
          "trainingTypes": {"id": trainingId},
          "surfaceType": {"id": surfaceId},
          "tenantid": tenantId,
          "duration": trainingtimeForServer,
          "trainingDatetime": trainingDatetimeForServer,
          "distance": distance,
          "walk": walk,
          "trot": trot,
          "canter": canter,
          "gallop": gallop
        }
      };

      // Send the HTTP POST request
      final String url = '${ApiPath.getUrlPath(ApiPath.addtraining())}';
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());

      // Handle response
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }

  @override
  Future<ApiResponse> updateTraining(
      {required int id,
      required String trainingDatetime,
      required String duration,
      required String horseId,
      required String stableId,
      required String riderId,
      required String trainingId,
      required String surfaceId,
      required String distance,
      required String walk,
      required String trot,
      required String canter,
      required String gallop}) async {
    try {
      // Date format conversion
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat =
          DateFormat('yyyy-MM-ddTHH:mm:ss'); // ISO 8601 with time.
      final DateFormat _inputtime = DateFormat('HH:mm');
      final DateFormat _server_inputtime =
          DateFormat('PTH:mm'); // ISO 8601 with time.
      // Retrieve tenantId
      var tenantId = await cacheService.getString(name: 'tenantId');
      logger.d("Performing add body measurement in impl: tenant id: $tenantId");

      // Convert the provided date of birth to the server format with time.
      String convertDateToServerFormat(String date) {
        try {
          logger.d("date obtained for date : " + date);
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

      String convertTimeToServerFormat(String date) {
        try {
          logger.d("date obtained : " + date);
          final DateTime parsedDate = _inputtime.parse(date);

          // Include time information here, you can set the time as needed.
          final DateTime dateWithCurrentTime = DateTime(
            parsedDate.day,
            parsedDate.hour,
            parsedDate.minute,
          );
          return _server_inputtime.format(dateWithCurrentTime);
        } catch (e) {
          // Handle parsing error
          logger.e("Date parsing error: $e");
          return '';
        }
      }

      // Convert date of birth to server format
      String trainingDatetimeForServer = trainingDatetime.split(".")[0];
      //convertDateToServerFormat(trainingDatetime);
      String trainingtimeForServer =
          "PT" + duration.split(":")[0] + "Hrs" + duration.split(":")[1] + "Mins";
      // convertTimeToServerFormat(duration);
      // Create the data map with proper structure and data types
      Map<String, dynamic> data = {
        "horseTraining": {
          "id": id,
          "horse": {"id": horseId},
          "stables": {"id": stableId},
          "rider": {"id": riderId},
          "trainingTypes": {"id": trainingId},
          "surfaceType": {"id": surfaceId},
          "tenantid": tenantId,
          "duration": trainingtimeForServer,
          "trainingDatetime": trainingDatetimeForServer,
          "distance": distance,
          "walk": walk,
          "trot": trot,
          "canter": canter,
          "gallop": gallop
        }
      };

      // Send the HTTP POST request
      final String url = '${ApiPath.getUrlPath(ApiPath.updatetraining())}';
      logger.d(json.encode(data)); // Log the request body

      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());

      // Handle response
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding body measurement");
    }
  }

  @override
  Future<List<TrainingModel>> getAllTraining() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      // Ensure tenantId is not null before proceeding
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }
      var horsesId = await cacheService.getString(name: 'horsesId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlltraining(tenantId: tenantId, horseid: horsesId))}';

      final response = await httpApiService.getCall(url);

      logger.d("horseTraining start :${response.body.toString()}");
      if (response.statusCode == 200) {
        logger.d("horseTraining enter :${response.body.toString()}");
        var data = jsonDecode(response.body.toString());
        final List<TrainingModel> training = (data['horseTrainings'] as List)
            .map((e) => TrainingModel.fromJson(e))
            .toList();
        logger.d("horseTraining end :${response.body.toString()}");
        return training;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching horseTraining");
    }
  }

  @override
  Future<TrainingModel> getAllTrainingById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlltrainingbyId(id: id))}';

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
        final horseTraining = TrainingModel.fromJson(data['horseTraining']);

        return horseTraining;
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
  Future<void> deletetraining({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deletetraining(id: id));
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
