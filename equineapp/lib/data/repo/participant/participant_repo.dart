import '../../models/api_response.dart';
import '../../models/participant.dart';

abstract class ParticipantRepo {
  Future<ApiResponse> addParticipant(
      {required String startNumber,
      required String ownername,
      required String stablename,
      required String eventId,
      required String horseId,
      required String riderId,
      required String deviceId});
  Future<List<Participant>> getAllParticipant({required String id});
  Future<Participant> getAllParticipantById({required int id});
  Future<void> deleteAllParticipant({required int id});
  Future<ApiResponse> updateParticipant(
      {required int id,
      required String startNumber,
      required String ownername,
      required String stablename,
      required String eventId,
      required String horseId,
      required String riderId,
      required String deviceId});
}
