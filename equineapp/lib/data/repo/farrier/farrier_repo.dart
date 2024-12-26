import '../../models/api_response.dart';
import '../../models/farrier_model.dart';

abstract class FarrierRepo {
  Future<ApiResponse> addfarrier({
    required String horseId,
    required String shoeDatetime,
    required String foreShoeType,
    required String foreShoeSpecification,
    required String foreShoeComplement,
    required String hindShoeType,
    required String hindShoeSpecification,
    required String hindShoeComplement,
    required String surfaceType,
  });  Future<ApiResponse> updatefarrier({
    required int id,
    required String horseId,
    required String shoeDatetime,
    required String foreShoeType,
    required String foreShoeSpecification,
    required String foreShoeComplement,
    required String hindShoeType,
    required String hindShoeSpecification,
    required String hindShoeComplement,
    required String surfaceType,
  });
  Future<List<FarrierModel>> getAllFarrier();
  Future<FarrierModel> getAllFarrierById({required int id});
  Future<void> deletefarrier({required int id});
}
