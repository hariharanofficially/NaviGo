import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../service/service.dart';
import 'docs_repo.dart';
import 'package:path_provider/path_provider.dart'; // Import the path_provider package
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DocsRepoImpl implements DocsRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> postuploaddocs({
    required String recordId,
    required String tableName,
    required String rootLabel,
    required String displayPane,
    required File documents,
  }) async {
    try {
      // Retrieve the tenant ID from the cache
      var tenantId = await cacheService.getString(name: 'tenantId');
      if (tenantId == null || tenantId.isEmpty) {
        logger.e("Tenant ID is missing or empty.");
        throw RepoException("Tenant ID is required but not found.");
      }
      logger.d("Tenant ID: $tenantId");

      // Prepare form data
      Map<String, String> data = {
        'recordId': recordId,
        'tableName': tableName,
        'rootLabel': rootLabel,
        'tenantid': tenantId,
        'displayPane': displayPane,
      };
      logger.d("Form Data: ${json.encode(data)}");

      // API endpoint
      final String url = '${ApiPath.getUrlPath(ApiPath.postuploaddocs())}';
      logger.d("Request URL: $url");

      // Log document file details
      if (!documents.existsSync()) {
        logger.e("The file does not exist: ${documents.path}");
        throw RepoException("The document file is missing or invalid.");
      }
      logger.d("Uploading file: ${documents.path}");

      // Make the API call
      final http.StreamedResponse streamedResponse =
          await httpApiService.PostDocument(url, data, documents);

      // Convert streamed response to standard HTTP response
      final http.Response response =
          await http.Response.fromStream(streamedResponse);
      logger.d("HTTP Response Status: ${response.statusCode}");
      logger.d("HTTP Response Body: ${response.body}");

      // Check response status
      if (response.statusCode == 200) {
        logger.d("Upload successful. Response: ${response.body}");
        return ApiResponse.fromHttpResponse(response);
      } else {
        logger.e(
            "Upload failed with status code: ${response.statusCode}, Body: ${response.body}");
        throw RepoException(
            "Failed to upload document. Status: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      // Log exception details
      logger.e("Error in postuploaddocs: $e");
      logger.e("StackTrace: $stackTrace");

      // Re-throw with a custom error message
      throw RepoException("Error while uploading document: $e");
    }
  }

  @override
  Future<ApiResponse> postfetchDocs({
    required String recordId,
    required String tableName,
    required String displayPane,
  }) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');
      if (tenantId == null || tenantId.isEmpty) {
        logger.e("Tenant ID is missing or empty.");
        throw RepoException("Tenant ID is required but not found.");
      }
      logger.d("Tenant ID: $tenantId");

      // Prepare the request body
      Map data = {
        'tenantid': tenantId,
        'recordId': recordId,
        'tableName': tableName,
        'displayPane': displayPane,
      };
      logger.d("Request Data: ${json.encode(data)}");

      final String url = '${ApiPath.getUrlPath(ApiPath.postfetchDocs())}';
      logger.d("Request URL: $url");

      // Make the API call
      final response = await httpApiService.postCall(url, data);
      logger.d("HTTP Response Status: ${response.statusCode}");
      logger.d("HTTP Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        logger.d("Response Data: $responseData");

        // Parse the response into ApiResponse
        return ApiResponse.fromHttpResponse(response);
      } else {
        logger.e("Request failed with status code: ${response.statusCode}");
        throw RepoException(
            "Failed to fetch documents. Status: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      logger.e("Error in postfetchDocumentsByRecord: $e");
      logger.e("StackTrace: $stackTrace");
      throw RepoException("Error while fetching documents: $e");
    }
  }

  // @override
  // Future<Uint8List> getdownloadDocs(String docsId) async {
  //   try {
  //     // Retrieve tenantId from cache
  //     String tenantId = await cacheService.getString(name: 'tenantId');
  //     if (tenantId.isEmpty) {
  //       throw Exception('Tenant ID is missing');
  //     }

  //     // Construct the URL
  //     final String url =
  //         '${ApiPath.getUrlPath(ApiPath.getdownloadDocs(tenantId, docsId))}';
  //     logger.d("getdownloadDocs URL: $url");

  //     // Make the GET call
  //     final response = await httpApiService.getCall(url);

  //     // Check response status
  //     if (response.statusCode == 200) {
  //       logger.d("Document downloaded successfully");
  //       return response.bodyBytes; // Return the binary data
  //     } else {
  //       logger.e("Failed to download document. Status: ${response.statusCode}");
  //       throw Exception('Failed to download document');
  //     }
  //   } catch (e) {
  //     logger.e("Error in getdownloadDocs: $e");
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> getdownloadDocs(int docsId) async {
  //   try {
  //     // Step 1: Request permission to manage external storage (for Android 11+)
  //     await requestManageExternalStoragePermission(() async {
  //       // Retrieve tenantId from cache
  //       String tenantId = await cacheService.getString(name: 'tenantId');
  //       if (tenantId.isEmpty) {
  //         throw Exception('Tenant ID is missing');
  //       }

  //       // Construct the URL
  //       final String url =
  //           '${ApiPath.getUrlPath(ApiPath.getdownloadDocs(tenantId, docsId))}';
  //       logger.d("getdownloadDocs URL: $url");

  //       // Make the GET call to retrieve the document data
  //       final response = await httpApiService.getCall(url);

  //       // Check response status
  //       if (response.statusCode == 200) {
  //         logger.d("Document downloaded successfully");

  //         // Get the content type (MIME type) from the response headers
  //         String contentType = response.headers['content-type'] ?? '';
  //         String fileExtension = _getFileExtensionFromContentType(contentType);

  //         // If the content type is unknown, default to .pdf
  //         if (fileExtension.isEmpty) {
  //           fileExtension =
  //               'pdf'; // Default to pdf if the MIME type is not recognized
  //         }

  //         final directory = await getApplicationDocumentsDirectory();
  //         final filePath =
  //             '${directory.path}/document_${docsId}.$fileExtension'; // Dynamically set the file extension

  //         // Create the file and write the document data to it
  //         final file = File(filePath);
  //         await file.writeAsBytes(
  //             response.bodyBytes); // Save the binary data to the file

  //         logger.d("File saved at: $filePath");
  //         // Attempt to open the file
  //         final result = await OpenFile.open(filePath);

  //         // Check if the file opened successfully
  //         if (result.type == ResultType.done) {
  //           logger.d("File opened successfully");
  //         } else {
  //           logger.e("Failed to open file: ${result.message}");
  //         }
  //       } else {
  //         logger
  //             .e("Failed to download document. Status: ${response.statusCode}");
  //         throw Exception('Failed to download document');
  //       }
  //     });
  //   } catch (e) {
  //     logger.e("Error in getdownloadDocs: $e");
  //     rethrow; // Rethrow the error so you can handle it in your UI or BLoC
  //   }
  // }

  // /// Helper method to get the file extension from the content type
  // String _getFileExtensionFromContentType(String contentType) {
  //   if (contentType.contains('pdf')) {
  //     return 'pdf';
  //   } else if (contentType.contains('msword') || contentType.contains('docx')) {
  //     return 'docx';
  //   } else if (contentType.contains('vnd.ms-excel') ||
  //       contentType.contains('spreadsheetml')) {
  //     return 'xlsx';
  //   } else if (contentType.contains('plain') || contentType.contains('text')) {
  //     return 'txt';
  //   } else if (contentType.contains('image')) {
  //     return 'jpg'; // Assuming image is in JPG format. You can enhance this to handle other image types.
  //   }
  //   // Add more conditions as needed for other content types
  //   return '';
  // } // Open the downloaded document

  // /// Request permission and execute the download logic if granted
  // Future<void> requestManageExternalStoragePermission(
  //     Future<void> Function() onPermissionGranted) async {
  //   if (await Permission.manageExternalStorage.isGranted) {
  //     // Permission is already granted
  //     await onPermissionGranted();
  //   } else {
  //     // Request permission
  //     PermissionStatus status =
  //         await Permission.manageExternalStorage.request();
  //     if (status.isGranted) {
  //       // Permission granted, execute the download logic
  //       await onPermissionGranted();
  //     } else {
  //       // Handle permission denial
  //       logger.e('Permission denied');
  //     }
  //   }
  // }
  @override
  Future<String> getdownloadDocs(int docsId) async {
    try {
      // Comprehensive permission check for different Android versions
      if (Platform.isAndroid) {
        bool permissionGranted = await _checkAndRequestPermissions();
        if (!permissionGranted) {
          throw PermissionDeniedException(
              'Storage permission is required to download files');
        }
      }

      // Retrieve tenantId from cache
      String tenantId = await cacheService.getString(name: 'tenantId');
      if (tenantId.isEmpty) {
        throw Exception('Tenant ID is missing');
      }

      // Construct the URL for downloading the document
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getdownloadDocs(tenantId, docsId))}';
      logger.d("getdownloadDocs URL: $url");

      // Make the GET call to retrieve the document data
      final response = await httpApiService.getCall(url);

      // Check response status
      if (response.statusCode == 200) {
        logger.d("Document downloaded successfully");

        // Extract filename from Content-Disposition header or generate a default name
        String filename = _extractFilenameFromHeaders(response.headers, docsId);

        // Determine the appropriate download directory
        final directory = await _getDownloadDirectory();
        final filePath = '${directory.path}/$filename';

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        logger.d("File saved at: $filePath");

        // Attempt to open the file
        await _openDownloadedFile(filePath);

        // Optional: Show a local notification about successful download
        // await _showDownloadNotification(filename);

        return filePath; // Return the path of the downloaded file
      } else {
        logger.e("Failed to download document. Status: ${response.statusCode}");
        throw Exception('Failed to download document');
      }
    } catch (e) {
      logger.e("Error in getdownloadDocs: $e");
      rethrow;
    }
  }

  // /// Helper method to get the file extension from the content type
  String _getFileExtensionFromContentType(String contentType) {
    if (contentType.contains('pdf')) {
      return 'pdf';
    } else if (contentType.contains('msword') || contentType.contains('docx')) {
      return 'docx';
    } else if (contentType.contains('vnd.ms-excel') ||
        contentType.contains('spreadsheetml')) {
      return 'xlsx';
    } else if (contentType.contains('plain') || contentType.contains('text')) {
      return 'txt';
    } else if (contentType.contains('image')) {
      return 'jpg'; // Assuming image is in JPG format. You can enhance this to handle other image types.
    }
    // Add more conditions as needed for other content types
    return '';
  } // Open the downloaded document

// Comprehensive permission check and request method
  Future<bool> _checkAndRequestPermissions() async {
    // Check Android version
    int sdkInt = int.tryParse(Platform.version.split('.').first) ?? 0;

    // For Android 10 (SDK 29) and above
    if (sdkInt >= 29) {
      return await _requestAndroidTenPlusPermissions();
    }
    // For Android 6.0 (SDK 23) to Android 9 (SDK 28)
    else if (sdkInt >= 23) {
      return await _requestRuntimePermissions();
    }
    // For older versions, return true as they don't require runtime permissions
    return true;
  }

// Permission handling for Android 10 and above
  Future<bool> _requestAndroidTenPlusPermissions() async {
    try {
      // First, try manage external storage permission
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Request manage external storage permission
      PermissionStatus manageStatus =
          await Permission.manageExternalStorage.request();
      if (manageStatus.isGranted) {
        return true;
      }

      // Fallback to storage permissions if manage external storage is denied
      return await _requestRuntimePermissions();
    } catch (e) {
      logger.e("Error in Android 10+ permissions: $e");
      return false;
    }
  }

// Runtime permissions for Android 6.0 to 9
  Future<bool> _requestRuntimePermissions() async {
    try {
      // Check if storage permissions are already granted
      if (await Permission.storage.isGranted) {
        return true;
      }

      // Request storage permissions
      PermissionStatus storageStatus = await Permission.storage.request();

      if (storageStatus.isGranted) {
        return true;
      } else if (storageStatus.isPermanentlyDenied) {
        // Open app settings if permissions are permanently denied
        await openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      logger.e("Error in runtime permissions: $e");
      return false;
    }
  }

// Helper method to get download directory
  Future<Directory> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        // Try to get external downloads directory
        Directory? externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          return externalDir;
        }
      }

      // Fallback to application documents directory
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      logger.e("Error getting download directory: $e");
      // Absolute fallback
      return Directory.current;
    }
  }

// Extract filename from response headers or generate a default name
  String _extractFilenameFromHeaders(Map<String, String> headers, int docsId) {
    String contentDisposition = headers['content-disposition'] ?? '';
    String contentType = headers['content-type'] ?? '';

    // Try to extract filename from Content-Disposition header
    if (contentDisposition.contains('filename=')) {
      return contentDisposition
          .split('filename=')[1]
          .replaceAll('"', '')
          .trim();
    }

    // Generate a filename based on content type
    String extension = _getFileExtensionFromContentType(contentType);
    return 'document_$docsId.$extension';
  }

// Open the downloaded file
  Future<void> _openDownloadedFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        logger.e("Failed to open file: ${result.message}");
      }
    } catch (e) {
      logger.e("Error opening file: $e");
    }
  }

// Show a local notification about the download
  Future<void> _showDownloadNotification(String filename) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize notification settings (you may need to configure this in your app's initialization)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create a notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'File downloaded: $filename',
      platformChannelSpecifics,
    );
  }
}

// Custom exception for permission-related errors
class PermissionDeniedException implements Exception {
  final String message;

  PermissionDeniedException(this.message);

  @override
  String toString() => message;
}
