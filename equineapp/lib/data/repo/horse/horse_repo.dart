import 'package:EquineApp/data/models/horse_model.dart';

import '../../models/api_response.dart';

abstract class HorseRepo {
  Future<ApiResponse> addHorses({
    required String name,
    required String currentName,
    required String originalName,
    required String dateOfBirth,
    required String microchipNo,
    required String remarks,
    required String breedId,
    required String divisionId,
    required String active,
    required String stableId
  });

  Future<ApiResponse> updatehorse({
    required String name,
    required String currentName,
    required String originalName,
    required String dateOfBirth,
    required String microchipNo,
    required int id,
    required String remarks,
    required String breedId,
    required String divisionId,
    required String active,
    required String stableId
  });

  Future<List<HorseModel>> getAllHorses({required String tenantId});

  Future<HorseModel> getHorseById({required int id});

  Future<void> deleteHorsesById({required int id});
}
