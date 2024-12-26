import 'package:http/http.dart';
import 'package:http/http.dart' as http; // For MultipartRequest
import 'dart:io'; // Needed for the File class

abstract class HttpApiService {
  Future<Response> postCallNoToken(String url, Map data);
  Future<Response> postCall(String url, Map data);
  Future<Response> getCall(String url);
  Future<Response> putCall(String url, Map data);
  Future<Response> deleteCall(String url);
  Future<http.StreamedResponse> postFormWithFile(
      String url, Map<String, String> data, File file);
  Future<http.StreamedResponse> PostDocument(
      String url,
      Map<String, String> data,
      File?
          file // Made File nullable to handle cases where there might not be a file
      );
}
