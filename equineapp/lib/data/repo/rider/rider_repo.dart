import 'package:EquineApp/data/models/rider_model.dart';

import '../../models/api_response.dart';

abstract class RiderRepo {
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
      required String nationality});
  Future<List<RiderModel>> getAllRider();
  Future<RiderModel> getAllRiderById({required int id});
  Future<void> deleteRiderById({required int id});
  Future<ApiResponse> updateRider(
      {required int id,
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
      required String active});
}
