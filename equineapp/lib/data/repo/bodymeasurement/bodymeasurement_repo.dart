import 'package:EquineApp/data/models/body_model.dart';

import '../../models/api_response.dart';

abstract class BodyMeasurementRepo {
  Future<ApiResponse> AddBodyMeasurement({
    required String dateOfBirth,
    required String weight,
    required int horseId,
  });
  Future<ApiResponse> updateBodyMeasurement(
      {required String dateOfBirth,
      required String weight,
      required int horseId,
      required int id});
  Future<List<BodyModel>> getAllBodyMeasurement();
  Future<BodyModel> getAllBodyMeasurementById({required int id});
  Future<void> deletebodymeasurement({required int id});
}
