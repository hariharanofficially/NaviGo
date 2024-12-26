import '../../models/api_response.dart';
import '../../models/login_model.dart';

abstract class AuthRepo {
  Future<ApiResponse> postLaunch();
  Future<ApiResponse> postLogin(LoginModel loginData);
  Future<ApiResponse> postSignup(Map<dynamic, dynamic>? data);
  Future<ApiResponse> postValidate();
  Future<ApiResponse> postForgetPasseword({required String emailid});
}
