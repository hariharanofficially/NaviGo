import 'dart:convert';

import 'package:EquineApp/data/models/bloodtest_element.dart';
import 'package:EquineApp/data/models/shoeSpecification.dart';
import 'package:EquineApp/data/models/shoeType_model.dart';
import 'package:EquineApp/data/models/shoecomplement.dart';
import 'package:EquineApp/data/models/treatment_type.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/FoodUom_model.dart';
import '../../models/api_response.dart';
import '../../models/bloodtest_type.dart';
import '../../models/surfaceType.dart';
import '../../models/trainingType.dart';
import '../../models/foodType_model.dart';
import '../../service/service.dart';
import 'masterapi_repo.dart';

class MasterApiRepoImpl implements MasterApiRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addSurfaceType({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "surfaceType": {
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addSurfaceType())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateSurfaceType(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "surfaceType": {
          "id": id,
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateSurfaceType())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<List<SurfaceType>> getAllSurfaceTypes() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllSurfaceType(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<SurfaceType> surface = (data['surfaceTypes'] as List)
            .map((e) => SurfaceType.fromJson(e))
            .toList();

        return surface;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching surfacetype");
    }
  }

  @override
  Future<void> deleteSurfaceTypes({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteSurfaceType(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<ApiResponse> addTrainingType({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "trainingType": {"name": name, "tenantid": tenantId}
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addTrainingType())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding training type");
    }
  }

  @override
  Future<ApiResponse> updateTrainingType(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "trainingType": {"id": id, "name": name, "tenantid": tenantId}
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateTrainingType())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding training type");
    }
  }

  @override
  Future<List<TrainingType>> getAllTrainingTypes() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllTrainingType(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<TrainingType> training = (data['trainingTypes'] as List)
            .map((e) => TrainingType.fromJson(e))
            .toList();

        return training;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching trainingtype");
    }
  }

  @override
  Future<void> deleteTrainingTypes({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteTrainingType(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<ApiResponse> addBloodTestType({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "bloodTestType": {
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addBloodTestType())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateBloodTestType(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "bloodTestType": {
          "id": id,
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateBloodTestType())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<List<BloodTestType>> getAllBloodTestTypes() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllBloodTestType(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<BloodTestType> bloodtest = (data['bloodTestTypes'] as List)
            .map((e) => BloodTestType.fromJson(e))
            .toList();

        return bloodtest;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching trainingtype");
    }
  }

  @override
  Future<void> deleteBloodTestTypes({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteBloodTestType(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<ApiResponse> addTreatmentType({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "treatmentType": {
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addTreatmentType())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateTreatmentType(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "treatmentType": {
          "id": id,
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateTreatmentType())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<List<TreatmentType>> getAllTreatmentType() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllTreatmentType(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        // Check if 'treatmentType' exists and is not null
        if (data['treatmentTypes'] != null && data['treatmentTypes'] is List) {
          final List<TreatmentType> treatment = (data['treatmentTypes'] as List)
              .map((e) => TreatmentType.fromJson(e))
              .toList();

          return treatment;
        } else {
          // Log or handle the case when 'treatmentType' is null or not a list
          logger.e("treatmentType is null or not a list");
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching treatment types");
    }
  }

  @override
  Future<void> deleteTreatmentType({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteTreatmentType(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<ApiResponse> addFoodType(
      {required String name, required String descripition}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "foodType": {
          "foodName": name,
          "description": descripition,
          "active": true,
          "tenantid": tenantId,
          "category": "GRAINS"
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addFoodType())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateFoodType(
      {required int id,
      required String name,
      required String descripition}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "foodType": {
          "id": id,
          "foodName": name,
          "description": descripition,
          "active": true,
          "tenantid": tenantId,
          "category": "GRAINS"
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateFoodType())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<List<FoodType>> getAllFoodType() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllFoodType(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<FoodType> foodtype = (data['foodTypes'] as List)
            .map((e) => FoodType.fromJson(e))
            .toList();

        return foodtype;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching trainingtype");
    }
  }

  @override
  Future<void> deleteFoodType({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteFoodType(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<ApiResponse> addFoodUomType({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "feedUnitMeasurement": {
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addFoodUomType())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateFoodUomType(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "feedUnitMeasurement": {
          "id": id,
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateFoodUomType())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<List<FoodUomType>> getAllFoodUom() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllFoodUomType(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<FoodUomType> uom = (data['feedUnitMeasurements'] as List)
            .map((e) => FoodUomType.fromJson(e))
            .toList();

        return uom;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching trainingtype");
    }
  }

  @override
  Future<void> deleteFoodUom({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteFoodUomType(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<ApiResponse> addshoeComplement({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "shoeComplement": {
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addshoeComplement())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateshoeComplement(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "shoeComplement": {
          "id": id,
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url =
          '${ApiPath.getUrlPath(ApiPath.updateshoeComplement())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> addshoeSpecification({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "shoeSpecification": {
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url =
          '${ApiPath.getUrlPath(ApiPath.addshoeSpecification())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateshoeSpecification(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "shoeSpecification": {
          "id": id,
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url =
          '${ApiPath.getUrlPath(ApiPath.updateshoeSpecification())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> addshoeType({required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "shoeType": {
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.addshoeType())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<ApiResponse> updateshoeType(
      {required int id, required String name}) async {
    var tenantId = await cacheService.getString(name: 'tenantId');
    try {
      Map data = {
        "shoeType": {
          "id": id,
          "name": name,
          "code": name,
          "active": true,
          "tenantid": tenantId
        }
      };
      logger.d(json.encode(data));
      final String url = '${ApiPath.getUrlPath(ApiPath.updateshoeType())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While adding surface type");
    }
  }

  @override
  Future<List<shoeComplement>> getAllshoeComplement() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllshoeComplement(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<shoeComplement> shoecomp = (data['shoeComplements'] as List)
            .map((e) => shoeComplement.fromJson(e))
            .toList();

        return shoecomp;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching trainingtype");
    }
  }

  @override
  Future<List<shoeSpecification>> getAllshoeSpecification() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllshoeSpecification(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<shoeSpecification> shoespecf =
            (data['shoeSpecifications'] as List)
                .map((e) => shoeSpecification.fromJson(e))
                .toList();

        return shoespecf;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching trainingtype");
    }
  }

  @override
  Future<List<shoeType>> getAllshoeType() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllshoeType(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<shoeType> bloodtest = (data['shoeTypes'] as List)
            .map((e) => shoeType.fromJson(e))
            .toList();

        return bloodtest;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching trainingtype");
    }
  }

  @override
  Future<void> deleteshoeComplement({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteshoeComplement(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<void> deleteshoeSpecification({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteshoeSpecification(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<void> deleteshoeType({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteshoeType(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<List<BloodTestElement>> getAllBloodTestElement() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllBloodTestElement(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<BloodTestElement> bloodtestelement =
            (data['bloodTestElements'] as List)
                .map((e) => BloodTestElement.fromJson(e))
                .toList();

        return bloodtestelement;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching bloodtestelement");
    }
  }
}
