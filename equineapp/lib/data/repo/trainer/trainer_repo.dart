import '../../models/api_response.dart';
import '../../models/trainermodel.dart';

abstract class TrainerRepo {
  Future<ApiResponse> addTrainer({
    required String name,
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
    required String nationality,
    required String addressline1,

  });
  Future<List<TrainerModel>> getAllTrainer();
  Future<TrainerModel> getAllTrainerById({required int id});
  Future<void> deleteTrainerById({required int id});
  Future<ApiResponse> updateTrainer({
    required int id,
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
    required String active,
    required String addressline1,
  
  });
}
