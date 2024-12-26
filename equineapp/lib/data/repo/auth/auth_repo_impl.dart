import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';

import '../../../app/config/server_config.dart';
import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/api_response.dart';
import '../../models/login_model.dart';
//import '../../service/google/google_login.dart';
import '../../service/service.dart';
import 'auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  Logger logger = new Logger();
  @override
  Future<ApiResponse> postLaunch() async {
    String? deviceId;
    String? device;
    String? osVersion;
    try {
      // String resp = "";
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

      var deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        var info = await deviceInfo.androidInfo;

        deviceId = info.id;
        device = info.device;
        osVersion = info.version.release;
      } else if (Platform.isIOS) {
        var info = await deviceInfo.iosInfo;

        deviceId = info.identifierForVendor;
        device = info.name;
        osVersion = info.systemVersion;
      }

      // var deviceId = "63D689E3-1675-4219-BB6F-BF06436CF549";
      // var device = "device";
      // var osVersion = "osVersion";

      cacheService.setString(name: 'deviceId', value: deviceId ?? "");
      Map data = {
        'userDevice': {
          'appCommunicationKey': ServerConfig.appCommunicationKey,
          'userDeviceId': deviceId,
          //"fireBaseToken": "TEST_FBT_RAJ_122111222222",
          //"fireBaseToken": "TEST_FBT_122111222222",
          "fireBaseToken": deviceId,
          "deviceDetails": {
            "locale": "en",
            // "timezone": "Asia/Kolkata",
            "timezone": currentTimeZone,
            "platform": "Android",
            "device": device,
            "osVersion": osVersion,
            "appVersion": ServerConfig.appVersion
          }
        }
      };
      //  String resp = data.toString();

      // final String url = '${ApiPath.getUrlPath(ApiPath.postUserLaunch)}';
      final String url = ApiPath.getUrlPath(ApiPath.postUserLaunch);
      logger.d(url);
      logger.d(data);
      final response = await httpApiService.postCallNoToken(url, data);
      logger.d(response.body.toString());
      logger.d(response.statusCode);

      if (response.statusCode == 200) {
        return ApiResponse();
      }

      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while signin validation");
    }
  }

  @override
  Future<ApiResponse> postLogin(LoginModel loginData) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.postUserLogin);
      Map data = loginData.toMap();
      data["appCommunicationKey"] = ServerConfig.appCommunicationKey;
      data["userDeviceId"] = await cacheService.getString(name: "deviceId");
      logger.d(url);
      logger.d(data);

      final response = await httpApiService.postCallNoToken(url, data);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        logger.d(responseData.toString());

        String token = responseData['loggedUser']['token']['accessToken'];
        int userId = responseData['loggedUser']['user']['id'];
        int userDeviceId = responseData['loggedUser']['userDevice']['id'];
        var tenants =
            responseData['loggedUser']['tenants']['subscriptionTenant'];
        logger.d(tenants.length);
        logger.d(token);

        cacheService.setString(
            name: 'tenant', value: tenants.length.toString());

        if (tenants.isNotEmpty) {
          cacheService.setString(
              name: 'tenantId', value: tenants[0]['id'].toString());
          cacheService.setString(
              name: 'planId', value: tenants[0]['plan']['id'].toString());
        }

        cacheService.setString(name: 'jwt', value: token);
        cacheService.setString(name: 'profileUrl', value: '');
        cacheService.setString(name: 'userId', value: userId.toString());
        cacheService.setString(name: 'userName', value: loginData.userName);
        cacheService.setString(
            name: 'userDeviceId', value: userDeviceId.toString());
        cacheService.setString(name: 'loginType', value: loginData.loginType);
        cacheService.setBoolean(name: 'isLoggedIn', value: true);
        cacheService.setString(name: 'profileUrl', value: loginData.profileUrl);

        return ApiResponse.fromHttpResponse(response);
      }

      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching signin");
    }
  }

  @override
  Future<ApiResponse> postSignup(Map<dynamic, dynamic>? data) async {
    try {
      //final String url = '${ApiPath.getUrlPath(ApiPath.postUserSignup)}';
      final String url = ApiPath.getUrlPath(ApiPath.postUserSignup);
      data?["appCommunicationKey"] = ServerConfig.appCommunicationKey;
      data?["userDeviceId"] = await cacheService.getString(name: "deviceId");
      logger.d(url);
      logger.d(data);

      final response = await httpApiService.postCallNoToken(url, data ?? {});

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return new ApiResponse.fromHttpResponse(response);
      } else {
        return ApiResponse();
      }
      //return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching signin");
    }
  }

  @override
  Future<ApiResponse> postValidate() async {
    try {
      //final String url = '${ApiPath.getUrlPath(ApiPath.postValidate)}';
      final String url = ApiPath.getUrlPath(ApiPath.postValidate);

      final response = await httpApiService.postCall(url, {});

      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return new ApiResponse.fromHttpResponse(response);
      } else {
        return ApiResponse();
      }
      //return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching signin");
    }
  }

  @override
  Future<ApiResponse> postForgetPasseword({required String emailid}) async {
    try {
      final String url =
          ApiPath.getUrlPath(ApiPath.postforgetpassword(emailid: emailid));
      final body = {'email': emailid}; // Adjust key as per your API

      final response = await httpApiService.postCall(url, body);

      // Log the response for debugging
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        // Assuming response body is JSON and parsing it for ApiResponse
        return ApiResponse.fromHttpResponse(response);
      } else {
        // Create ApiResponse with error message from the response
        final errorResponse = ApiResponse.fromHttpResponse(response);
        logger.e('Error: ${errorResponse.message}');
        return errorResponse;
      }
    } catch (e) {
      // Handle exceptions and log the error
      logger.e('Exception occurred: ${e.toString()}');
      throw RepoException("Error while fetching ForgetPassword");
    }
  }
}
