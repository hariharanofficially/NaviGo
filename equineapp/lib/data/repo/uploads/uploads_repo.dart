// import 'package:http/http.dart';

import 'dart:io';
import 'dart:typed_data';

import '../../models/api_response.dart';
import '../../models/event_model.dart';
import '../../models/participant_model.dart';
import '../../models/registered_device_model.dart';
import '../../models/tracker_feed_data.dart';

abstract class UploadsRepo {
  Future<Uint8List> getProfileImage(
      {required String recordId,
      required String tableName,
      required String displayPane});
  Future<ApiResponse> addStableWithFile({
    required String recordId,
    required String tableName,
    required File images,    
    required String displayPane,
  });
}
