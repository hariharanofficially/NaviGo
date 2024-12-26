part of 'event_repo.dart';

class EventRepoimpl implements EventRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addEvent({
    required String startDate,
    required String endDate,
    required String shortName,
    required String title,
    required String groupName,
    required String locationName,
    required String city,
    required String rideStartTime,
    required String rideDate,
    required String source,
    required String vendorName,
    required String stableId,
    required String eventGroupId,
    required String eventTypeId,
    required String eventCountryId,
    required String divisionId,
    required String category,
    required String phase,
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      Map data = {
        "event": {
          "name": title,
          "tenantid": tenantId,
          "startDate": startDate,
          "endDate": endDate,
          "groupFlag": true,
          "shortName": shortName,
          "title": title,
          "groupName": groupName,
          "category": category,
          "raceType": category,
          "locationName": locationName,
          "city": city,
          "rideStartTime": rideStartTime,
          "rideDate": rideDate,
          "source": source,
          "vendorName": vendorName,
          "eventGroup": {"id": eventGroupId},
          "eventType": {"id": eventTypeId},
          "division": {"id": divisionId},
          "country": {"id": eventCountryId},
          "state": {"id": 1},
          "phases": [
            {"gateNumber": 1, "distance": phase, "loopColor": "Green"}
          ],
          //"vendorLogo": vendorLogo,
          //"vendorRideId": vendorRideId,
          // "phases": [
          //   {
          //     "gateNumber": gateNumber,
          //     "distance": distance,
          //     "loopColor": loopColor,
          //   }
          // ],
          //"timeZone": timeZone
        }
      };

      final String url = '${ApiPath.getUrlPath(ApiPath.addevents())}';
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
  Future<ApiResponse> addtraning() async {
    try {
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      var tenantId = await cacheService.getString(name: 'tenantId');
      Map data = {
        "event": {"tenantid": tenantId, "timeZone": currentTimeZone}
      };

      final String url = '${ApiPath.getUrlPath(ApiPath.addtraning())}';
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
  Future<List<EventModel>> getAllEvent({required String tenantId}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      var planId = await cacheService.getString(name: 'planId');
      // Ensure tenantId is not null before proceeding
      if (tenantId == null) {
        throw RepoException("Tenant ID not found");
      }

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllevents(id: tenantId))}';

      final response = await httpApiService.getCall(url);

      logger.d("events start :${response.body.toString()}");
      if (response.statusCode == 200) {
        logger.d("events enter :${response.body.toString()}");
        var data = jsonDecode(response.body.toString());
        final List<EventModel> events = (data['events'] as List)
            .map((e) => EventModel.fromJson(e))
            .toList();
        logger.d("events end :${response.body.toString()}");
        return events;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  @override
  Future<void> deleteEventById({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteEventById(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());
      if (response.statusCode != 200) {
        throw RepoException("Failed to delete event");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting events");
    }
  }

  @override
  Future<ApiResponse> updateEvent({
    required int id,
    required String startDate,
    required String endDate,
    required String shortName,
    required String title,
    required String groupName,
    required String locationName,
    required String city,
    required String rideStartTime,
    required String rideDate,
    required String source,
    required String vendorName,
    required String stableId,
    required String eventGroupId,
    required String eventTypeId,
    required String divisionId,
    required String eventCountryId,
    required String category,
    required String phase,
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      Map data = {
        "event": {
          "id": id,
          "name": title,
          "tenantid": tenantId,
          "startDate": startDate,
          "endDate": endDate,
          "groupFlag": true,
          "shortName": shortName,
          "title": title,
          "groupName": groupName,
          "category": category,
          "raceType": category,
          "locationName": locationName,
          "city": city,
          "rideStartTime": rideStartTime,
          "rideDate": rideDate,
          "source": source,
          "vendorName": vendorName,
          "eventGroup": {"id": eventGroupId},
          "eventType": {"id": eventTypeId},
          "division": {"id": divisionId},
          "country": {"id": eventCountryId},
          "state": {"id": 1},
          "phases": [
            {"gateNumber": 1, "distance": phase, "loopColor": "Green"}
          ],
          //"vendorLogo": vendorLogo,
          //"vendorRideId": vendorRideId,
          // "phases": [
          //   {
          //     "gateNumber": gateNumber,
          //     "distance": distance,
          //     "loopColor": loopColor,
          //   }
          // ],
          //"timeZone": timeZone
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.updateEvents())}';
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
  Future<EventModel> getAlleventsById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlleventsById(id: id))}';

      // Make the API call
      final response = await httpApiService.getCall(url);

      // Log the response body for debugging
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      int horsesId = responseData['event']['id'];
      cacheService.setString(name: 'eventId', value: horsesId.toString());
      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = jsonDecode(response.body.toString());

        // Assuming the API response structure returns a single horse object
        final horse = EventModel.fromJson(data['event']);

        // Return the HorseModel instance
        return horse;
      } else {
        // Handle the case where the status code is not 200
        throw RepoException(
            "Failed to fetch horse details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Log and throw a more descriptive error
      logger.e(e.toString());
      throw RepoException("Error while fetching horse details");
    }
  }
}
