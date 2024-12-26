// import 'package:http/http.dart';

import '../../models/api_response.dart';
import '../../models/event_model.dart';
import '../../models/participant_model.dart';
import '../../models/registered_device_model.dart';
import '../../models/tracker_device_model.dart';
import '../../models/tracker_feed_data.dart';

abstract class TrackerRepo {
  Future<ApiResponse> updatetrackerdevices(
      {required int id,
      required String deviceName,
      required String macId,
      required String deviceId});

  Future<ApiResponse> addtrackerdevices(
      {required String deviceName,
      required String macId,
      required String deviceId});

  Future<List<RegisteredDevice>> getAlltrackerdevice();

  Future<RegisteredDevice> getAlltrackerdeviceById({required int id});

  Future<List<EventModel>> getAllEvents();

  Future<List<ParticipantModel>> getEventParticipants({required String id});

  Future<ParticipantModel?> getTrackerParticipant(
      {required String trackerDeviceId});

  Future<List<TrackerFeedData>> getEventParticipantTrackerFeed(
      {required String participantId, required String eventId});

  Future<List<RegisteredDevice>> getRegisteredDevicesByUserId(
      {required String userId});

  Future<List<RegisteredDevice>> getRegisteredDevicesByTenantId(
      {required String tenantId});

  Future<ApiResponse> postNewTrackerData(
      {required deviceId, required deviceName, required macId});

  Future<ApiResponse> postTrackerFeed({required Map data});
}
