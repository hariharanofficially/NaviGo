import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../service.dart';
import 'httpapi_service.dart';
import 'package:http/http.dart' as http; // For MultipartRequest
import 'dart:io'; // Needed for the File class

class HttpApiServiceImpl extends HttpApiService {
  Logger logger = new Logger();

  @override
  Future<Response> getCall(String url) async {
    String token = await cacheService.getString(name: 'jwt');
    logger.d("get call authcode : " + token);
    Response response = await get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return response;
  }

  @override
  Future<Response> postCall(String url, Map data) async {
    String token = await cacheService.getString(name: 'jwt');
    logger.d("post call : " + url + " :: authcode : " + token);
    var body = json.encode(data);
    logger.d("post data : " + body);
    Response response = await post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    return response;
  }

  @override
  Future<Response> postCallNoToken(String url, Map data) async {
    var body = json.encode(data);
    Response response = await post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    return response;
  }

  @override
  Future<Response> putCall(String url, Map data) async {
    String token = await cacheService.getString(name: 'jwt');
    logger.d("put call : " + url + " :: authcode : " + token);
    var body = json.encode(data);
    logger.d("put data : " + body);
    Response response = await put(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    return response;
  }

  @override
  Future<Response> deleteCall(String url) async {
    String token = await cacheService.getString(name: 'jwt');
    logger.d("delete call : " + url + " :: authcode : " + token);
    Response response = await delete(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return response;
  }

  @override
  Future<http.StreamedResponse> postFormWithFile(
      String url,
      Map<String, String> data,
      File?
          file // Made File nullable to handle cases where there might not be a file
      ) async {
    // Fetch token from cache or local storage
    String token = await cacheService.getString(name: 'jwt');
    logger.d("Post form with file: $url :: authcode: $token");

    // Create a MultipartRequest for POST
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add required headers
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Add form fields, converting them to strings if necessary
    data.forEach((key, value) {
      request.fields[key] = value.toString(); // Convert all values to strings
    });

    // Add file if it exists
    if (file != null) {
      // Add the file using the http.MultipartFile.fromPath method
      request.files.add(await http.MultipartFile.fromPath('images', file.path));
    }

    logger.d("Form data with file: ${request.fields}");
    if (file != null) {
      logger.d("File to be uploaded: ${file.path}");
    }

    // Send the request
    try {
      final response =
          await request.send(); // Ensure this returns http.StreamedResponse
      return response;
    } catch (e) {
      logger.e("Failed to upload file: $e");
      rethrow; // Re-throw the error after logging
    }
  }

  @override
  Future<http.StreamedResponse> PostDocument(
      String url,
      Map<String, String> data,
      File?
          file // Made File nullable to handle cases where there might not be a file
      ) async {
    // Fetch token from cache or local storage
    String token = await cacheService.getString(name: 'jwt');
    logger.d("Post Document with file: $url :: authcode: $token");

    // Create a MultipartRequest for POST
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add required headers
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Add form fields, converting them to strings if necessary
    data.forEach((key, value) {
      request.fields[key] = value.toString(); // Convert all values to strings
    });

    // Add file if it exists
    if (file != null) {
      // Add the file using the http.MultipartFile.fromPath method
      request.files
          .add(await http.MultipartFile.fromPath('documents', file.path));
    }

    logger.d("Document data with file: ${request.fields}");
    if (file != null) {
      logger.d("File to be uploaded: ${file.path}");
    }

    // Send the request
    try {
      final response =
          await request.send(); // Ensure this returns http.StreamedResponse
      return response;
    } catch (e) {
      logger.e("Failed to upload file: $e");
      rethrow; // Re-throw the error after logging
    }
  }
}
