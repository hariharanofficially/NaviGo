import '../../models/api_response.dart';
import '../../models/training_model.dart';

abstract class TrainingRepo {
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
      required String gallop});
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
      required String gallop});
  Future<List<TrainingModel>> getAllTraining();
  Future<TrainingModel> getAllTrainingById({required int id});
  Future<void> deletetraining({required int id});
}
