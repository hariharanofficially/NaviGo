import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:EquineApp/data/repo/uploads/uploads_repo.dart';
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
import '../../models/tracker_feed_data.dart';
import '../../service/service.dart';
import '../repo.dart';

class UploadsRepoImpl implements UploadsRepo {
  Logger logger = new Logger();

  @override
  Future<Uint8List> getProfileImage(
      {required String recordId,
      required String tableName,
      required String displayPane}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getProfileImage(recordId, tenantId, tableName, displayPane))}';
      logger.d("image profile url " + url);
      final response = await httpApiService.getCall(url);
      logger.d("Response Status Code: ${response.statusCode}");
      logger.d("Response Headers: ${response.headers}");
      logger.d("Response Body Bytes Length: ${response.bodyBytes.length}");

      //logger.d(response.body.toString());
      if (response.statusCode == 200) {
        logger.e("Error: Status code ${response.statusCode}");
        logger.e("Error Body: ${response.body}");
        return response.bodyBytes;
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception(
            'Failed to load image with status code ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }

  Future<ApiResponse> addStableWithFile({
    required String recordId,
    required String tableName,
    required String displayPane,
    required File images,
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      Map<String, String> data = {
        'recordId': recordId,
        'tableName': tableName,
        'tenantid': tenantId,
        'displayPane': displayPane,
      };

      final String url = '${ApiPath.getUrlPath(ApiPath.postimagestable())}';
      logger.d("URL: $url");

      // Call the postFormWithFile method from the HTTP service
      final http.StreamedResponse streamedResponse =
          await httpApiService.postFormWithFile(url, data, images);

      // Convert StreamedResponse to Response
      final http.Response response =
          await http.Response.fromStream(streamedResponse);

      // Check for the response status
      if (response.statusCode == 200) {
        logger.d(response.body);

        // Pass the Response object to ApiResponse.fromHttpResponse
        return ApiResponse.fromHttpResponse(response);
      }

      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while adding stable with file");
    }
  }

// // New method to handle adding a stable with file upload
//   Future<ApiResponse> addStableWithFile({
//     required String recordId,
//     required String tableName,
//     required File images,
//   }) async {
//     try {
//       var tenantId = await cacheService.getString(name: 'tenantId');

//       Map<String, String> data = {
//         'recordId': recordId,
//         'tableName': tableName,
//         'tenantid': tenantId,
//         'displayPane': 'profileImgs',
//       };

//       final String url = '${ApiPath.getUrlPath(ApiPath.postimagestable())}';
//       logger.d("URL: $url");

//       // Call the postFormWithFile method from the HTTP service
//       final response = await httpApiService.postFormWithFile(url, data, images);

//       // Check for the response status
//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         logger.d(responseBody);
//         return ApiResponse.fromHttpResponse(json.decode(responseBody));
//       }

//       return ApiResponse();
//     } catch (e) {
//       logger.e(e.toString());
//       throw RepoException("Error while adding stable with file");
//     }
//   }
}
