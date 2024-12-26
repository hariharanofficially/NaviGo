import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

class ApiResponse {
  final String message;

  final String error;

  final int statusCode;

  final dynamic data;

  ApiResponse({
    this.message = "",
    this.error = "",
    this.statusCode = 0,
    this.data = const {},
  });

  factory ApiResponse.error(String error, {int statusCode = 0}) {
    return ApiResponse(
      error: error,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromDioResponse(dio.Response response) {
    return ApiResponse(
      statusCode: response.statusCode ?? 0,
      data: response.data,
      message: response.statusMessage ?? "",
    );
  }

  factory ApiResponse.fromHttpResponse(http.Response response) {
    return ApiResponse(
      statusCode: response.statusCode,
      data: response.body,
      message: response.reasonPhrase ?? "",
    );
  }
}
