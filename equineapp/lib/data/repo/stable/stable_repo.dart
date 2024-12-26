import '../../models/api_response.dart';
import '../../models/stable_model.dart';

abstract class StableRepo {
  Future<ApiResponse> addStable(
      {required String tenantId, required String stablename});
  Future<ApiResponse> updateStable(
      {required int stableId,
      required String tenantId,
      required String stablename});
  Future<List<StableModel>> getAllStable(String tenantid);
  Future<StableModel> getAllStableById({required int id});
  Future<void> deleteStableById({required int id});
}
