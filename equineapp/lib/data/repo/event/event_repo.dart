import 'dart:convert';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:EquineApp/data/models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/event_model.dart';
import '../../models/events.dart';
import '../../service/service.dart';

part 'event_repo_impl.dart';

abstract class EventRepo {
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
    required String divisionId,
    required String eventCountryId,
    required String category,
    required String phase,
  });

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
  });

  Future<ApiResponse> addtraning();

  Future<List<EventModel>> getAllEvent({required String tenantId});

  Future<EventModel> getAlleventsById({required int id});

  Future<void> deleteEventById({required int id});
}
