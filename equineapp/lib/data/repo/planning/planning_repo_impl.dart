import 'dart:convert';

import 'package:EquineApp/data/models/api_response.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/planning_model.dart';
import '../../service/service.dart';
import 'planning_repo.dart';

class PlanningRepoImpl implements PlanningRepo {
  Logger logger = new Logger();
  @override

  Future<ApiResponse> addplanning(
    // String checkupDate,
     {
    required String horseId,
    required String planStartDate,
    required String planEndDate,
    required String bodyweight,
    required String walk,
    required String trot,
    required String canter,
    required String gallop,
    required String foreShoeTypeId,
    required String foreShoeSpecificationId,
    required String foreShoeComplementId,
    required String hindShoeTypeId,
    required String hindShoeSpecificationId,
    required String hindShoeComplementId,

    required List<Map<String, dynamic>>
        treatments, // Accepting list of treatments
    required List<Map<String, dynamic>>
        nutritions, // Accepting list of nutritions
    required List<Map<String, dynamic>>
        bloodTests, // Accepting list of blood tests
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
      final DateFormat _serverDateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');

      String convertDateToServerFormat(String date) {
        try {
          final DateTime parsedDate = _inputDateFormat.parse(date);
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


      String startDateForServer = convertDateToServerFormat(planStartDate);
      String endDateForServer = convertDateToServerFormat(planEndDate);
      // String checkupDateForServer = convertDateToServerFormat(checkupDate);

      Map data = {
        "horseProfilePlan": {
          "horse": {"id": horseId},
          "planStartDate": startDateForServer,
          "planEndDate": endDateForServer,
          "bodyWeight": double.tryParse(bodyweight) ?? 0.0,
          "trainingWalk": walk,
          "trainingTrot": trot,
          "trainingCanter": canter,
          "trainingGallop": gallop,
          "foreShoeType": {"id": foreShoeTypeId},
          "foreShoeSpecification": {"id": foreShoeSpecificationId},
          "foreShoeComplement": {"id": foreShoeComplementId},
          "hindShoeType": {"id": hindShoeTypeId},
          "hindShoeSpecification": {"id": hindShoeSpecificationId},
          "hindShoeComplement": {"id": hindShoeComplementId},
          "tenantid": tenantId,
          "isBodyTraget": true,
          "isTrainingTraget": true,
          "isFarrierTraget": true,
          "treatments": treatments.map((treatment) {
            return {
              "treatmentType": {"id": treatment["treatmentTypeId"]},
              "checkupDate": convertDateToServerFormat(
                  treatment["checkupDate"] ?? "2023-09-30T13:45:30"),
              "isTarget": true,
              "tenantid": tenantId
            };
          }).toList(),
          "nutritions": nutritions.map((nutrition) {
            return {
              "foodType": {"id": nutrition["foodTypeId"]},
              "servingDatetime":
                  nutrition["servingDatetime"] ?? "2023-09-30T13:45:30",
              "servingValue": nutrition["servingValue"],
              "isTarget": true,
              "tenantid": tenantId
            };
          }).toList(),
          "bloodTests": bloodTests.map((bloodTest) {
            return {
              "bloodTestElement": {"id": bloodTest["bloodTestElementId"]},
              "resultValue": bloodTest["resultValue"],
              "testDatetime":
                  bloodTest["testDatetime"] ?? "2023-09-30T13:45:30",
              "isTarget": true,
              "tenantid": tenantId
            };
          }).toList()
        }
      };

      final String url = '${ApiPath.getUrlPath(ApiPath.addplanning())}';
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
  Future<List<PlanningModel>> getAllPlanning({required String horseId}) async {
    try {
      // Retrieve tenant ID
      var tenantId = await cacheService.getString(name: 'tenantId');
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }

      // Construct the API URL
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllplanning(tenantId: tenantId, horseId: horseId))}';
      logger.d("=== url : $url");

      // Make the GET request
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        // Parse the response
        var data = jsonDecode(response.body.toString());
        final List<PlanningModel> planningList = (data['plans'] as List)
            .map((plan) => PlanningModel.fromJson(plan))
            .toList();
        return planningList;
      }

      // Return an empty list if the status code is not 200
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching planning data");
    }
  }
}
