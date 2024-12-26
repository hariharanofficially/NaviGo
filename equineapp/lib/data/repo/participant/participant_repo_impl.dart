import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:EquineApp/data/repo/participant/participant_repo.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/participant.dart';
import '../../service/service.dart';

class ParticipantRepoImpl implements ParticipantRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addParticipant(
      {required String startNumber,
      required String ownername,
      required String stablename,
      required String eventId,
      required String horseId,
      required String riderId,
      required String deviceId}) async {
    try {
      Map data = {
        "participant": {
          "startNumber": startNumber,
          "event": {"id": eventId},
          "owner": {"id": ownername},
          "stable": {"id": stablename},
          "rider": {"id": riderId},
          "horse": {"id": horseId},
          "trackerDevice": {"id": deviceId}
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.addParticipant())}';
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
  Future<List<Participant>> getAllParticipant({required String id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getEventParticipants(id))}';
      logger.d("load participant : " + url);
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Participant> participant = (data['participants'] as List)
            .map((p) => Participant.fromJson(p))
            .toList();
        return participant;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<Participant> getAllParticipantById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllParticipantById(id: id))}';
      logger.d(url);
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      int participantId = responseData['participant']['id'];
      cacheService.setString(name: 'participantId', value: participantId.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // Assuming the API response structure returns a single horse object
        final participants = Participant.fromJson(data['participant']);

        // Return the HorseModel instance
        return participants;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch participants details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<ApiResponse> updateParticipant(
      {required int id,
      required String startNumber,
      required String ownername,
      required String stablename,
      required String eventId,
      required String horseId,
      required String riderId,
      required String deviceId}) async {
    try {
      Map data = {
        "participant": {
          "id": id,
          "startNumber": startNumber,
          "event": {"id": eventId},
          "owner": {"id": ownername},
          "stable": {"id": stablename},
          "rider": {"id": riderId},
          "horse": {"id": horseId},
          "trackerDevice": {"id": deviceId},
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.updateParticipant())}';

      final response = await httpApiService.putCall(url, data);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<void> deleteAllParticipant({required int id}) async {
    try {
      final String url =
          ApiPath.getUrlPath(ApiPath.deleteAllParticipant(id: id));

      final response = await httpApiService.deleteCall(url);

      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete participants");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting participants");
    }
  }
}
