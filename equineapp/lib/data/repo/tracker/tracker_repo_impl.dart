import 'dart:convert';

import 'package:flutter_timezone/flutter_timezone.dart';

// import 'package:http/src/response.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/event_model.dart';
import '../../models/participant_model.dart';
import '../../models/registered_device_model.dart';
import '../../models/tracker_device_model.dart';
import '../../models/tracker_feed_data.dart';
import '../../service/service.dart';
import '../repo.dart';
import 'tracker_repo.dart';

class TrackerRepoImpl implements TrackerRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addtrackerdevices(
      {required String deviceName,
      required String macId,
      required String deviceId}) async {
    try {
      String userDeviceId = await cacheRepo.getString(name: 'userDeviceId');
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      var tenantId = await cacheService.getString(name: 'tenantId');
      Map data = {
        "trackerDevice": {
          "userDeviceId": userDeviceId,
          "trackerDeviceId": deviceName,
          "deviceMacId": macId,
          "heartRateCensorId": deviceId,
          "gpsSignalStrength": "12",
          "censorVoltage": "10",
          "deviceVoltage": "10",
          "timeZone": currentTimeZone,
          "dayLightSavingMinutes": "10",
          "frequancy": 2,
          "tenantid": tenantId,
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.postdevicetracker())}';

      final response = await httpApiService.postCall(url, data);

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
  Future<ApiResponse> updatetrackerdevices(
      {required int id,
      required String deviceName,
      required String macId,
      required String deviceId}) async {
    try {
      String userDeviceId = await cacheRepo.getString(name: 'userDeviceId');
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      var tenantId = await cacheService.getString(name: 'tenantId');
      Map data = {
        "trackerDevice": {
          "id": id,
          "userDeviceId": userDeviceId,
          "trackerDeviceId": deviceName,
          "deviceMacId": macId,
          "heartRateCensorId": deviceId,
          "gpsSignalStrength": "12",
          "censorVoltage": "10",
          "deviceVoltage": "10",
          "timeZone": currentTimeZone,
          "dayLightSavingMinutes": "10",
          "frequancy": 2,
          "tenantid": tenantId,
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.updatedevicetracker())}';

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
  Future<List<RegisteredDevice>> getAlltrackerdevice() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlltrackerdevice(tenantId: tenantId))}';

      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<RegisteredDevice> trackerDevices =
            (data['trackerDevices'] as List)
                .map((tracker) => RegisteredDevice.fromJson(tracker))
                .toList();

        return trackerDevices;
      }

      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<RegisteredDevice> getAlltrackerdeviceById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlltrackerdevicebyId(id: id))}';

      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final trackerDevices = RegisteredDevice.fromJson(data['trackerDevice']);

        return trackerDevices;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch device details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      DateTime dateTime = DateTime.now();
      String endDate = DateFormat('yyyy-MM-dd').format(dateTime);
      String startDate = DateFormat('yyyy-MM-dd')
          .format(dateTime.subtract(Duration(days: 90)));
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllEventsByPeriods(startDate, endDate))}';

      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<EventModel> events = (data['events'] as List)
            .map((event) => EventModel.fromJson(event))
            .toList();

        return events;
      }

      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<List<ParticipantModel>> getEventParticipants(
      {required String id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getEventParticipants(id))}';

      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        logger.d(response.body.toString());
        final List<ParticipantModel> participants =
            (data['participants'] as List)
                .map((event) => ParticipantModel.fromJson(event))
                .toList();
        return participants;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<List<TrackerFeedData>> getEventParticipantTrackerFeed(
      {required String participantId, required String eventId}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getTrackerFeed(participantId: participantId))}';
      logger.d(url);
      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<TrackerFeedData> feedDataList =
            (data['trackerFeeds'] as List)
                .map((data) => TrackerFeedData.fromJson(data))
                .toList();
        return feedDataList;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<ParticipantModel?> getTrackerParticipant(
      {required String trackerDeviceId}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getTrackerParticipant(trackerDeviceId: trackerDeviceId))}';
      logger.d(url);
      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final ParticipantModel participant =
            ParticipantModel.fromJson(data['currentParticipant']);
        return participant;
      }
      return null;
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<List<RegisteredDevice>> getRegisteredDevicesByUserId(
      {required String userId}) async {
    try {
      String tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getRegisteredDevices(userId: userId, tenantId: tenantId))}';

      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<RegisteredDevice> registeredDeviceList =
            (data['trackerDevices'] as List)
                .map((data) => RegisteredDevice.fromJson(data))
                .toList();
        return registeredDeviceList;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<List<RegisteredDevice>> getRegisteredDevicesByTenantId(
      {required String tenantId}) async {
    try {
      String tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getRegisteredDevicesByTenant(tenantId: tenantId))}';

      final response = await httpApiService.getCall(url);

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<RegisteredDevice> registeredDeviceList =
            (data['trackerDevices'] as List)
                .map((data) => RegisteredDevice.fromJson(data))
                .toList();
        return registeredDeviceList;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<ApiResponse> postNewTrackerData(
      {required deviceId, required deviceName, required macId}) async {
    try {
      String userDeviceId = await cacheRepo.getString(name: 'userDeviceId');
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

      Map data = {
        "trackerDevice": {
          "userDeviceId": userDeviceId,
          "trackerDeviceId": deviceName,
          "deviceMacId": macId,
          "heartRateCensorId": deviceId,
          "gpsSignalStrength": "",
          "censorVoltage": "",
          "deviceVoltage": "",
          "timeZone": currentTimeZone,
          "dayLightSavingMinutes": "10"
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.postRegisterDevice())}';

      final response = await httpApiService.postCall(url, data);

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
  Future<ApiResponse> postTrackerFeed({required Map data}) async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.postTrackerFeed())}';

      final response = await httpApiService.postCall(url, data);

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
}
