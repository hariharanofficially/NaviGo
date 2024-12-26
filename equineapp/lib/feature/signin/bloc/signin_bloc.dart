import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/login_model.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/google/google_login.dart';
import '../../../data/service/service.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  Logger logger = new Logger();
  bool showPasswordIcon = true;
  SigninBloc() : super(SigninInitialState()) {
    on<SigninInitialEvent>((event, emit) {
      emit(SigninInitialState());
    });

    on<SigninSubmitEvent>((event, emit) async {
      await _signinWithEmail(event, emit);
    });

    on<SigninPasswordShowEvent>((event, emit) {
      showPasswordIcon = !showPasswordIcon;
      emit(SigninPasswordShowState(showPasswordIcon: showPasswordIcon));
    });
    on<SigninWithGoogleEvent>((event, emit) async {
      await _signinWithGoogle(event, emit);
    });
    on<SigninWithFacebookEvent>((event, emit) async {
      await _signinWithFacebook(event, emit);
    });
    on<SigninForgotPasswordEvent>((event, emit) async {
      await _forgotPassword(event, emit);
    });
  }

  Future<void> _signinWithEmail(
    SigninSubmitEvent event,
    Emitter<SigninState> emit,
  ) async {
    try {
      emit(SigninSubmittingState());
      ApiResponse response = await authRepo.postLaunch();
      logger.d(response.data.toString());
      LoginModel loginmodel =
          LoginModel(userName: event.username, password: event.password);
      loginmodel.loginType = "inapp";
      loginmodel.loginName = event.username;
      loginmodel.profileUrl = "";
      response = await authRepo.postLogin(loginmodel);
      logger.d(response.data.toString());
      if (response.statusCode == 200) {
        // var tenantId = response.data['tenantId'];
        //      await _saveTenantId(tenantId);
        var tenant = await cacheService.getString(name: 'tenant');
        var planId = await cacheService.getString(name: 'planId');
        logger.d(tenant);
        logger.d(planId);

        print("tenant");
        print("planId");
        // print(tenantId);
        if (tenant == '0') {
          emit(SigninSuccessNoTenantState());
        } else {
          if (planId == '1') {
            emit(SigninSuccessEventState());
          } else {
            emit(SigninSuccessStableState());
          }
          //emit(SigninSuccessState());
        }
      } else {
        emit(SigninFailedState(message: "Incorrect Username Or Password"));
      }
    } catch (e) {
      emit(SigninFailedState(message: "Incorrect Username Or Password"));
    }
  }

  Future<void> _signinWithGoogle(
    SigninWithGoogleEvent event,
    Emitter<SigninState> emit,
  ) async {
    try {
      var user = await GoogleLoginApiService.login();
      if (user != null) {
        logger.d("Just before singin - launch");
        ApiResponse response = await authRepo.postLaunch();
        logger.d(response.data.toString());
        LoginModel loginmodel =
            LoginModel(userName: user.email, password: 'equineapp');
        loginmodel.loginType = "google";
        loginmodel.loginName = user.email;
        loginmodel.profileUrl = user.photoUrl ?? '';
        response = await authRepo.postLogin(loginmodel);

        if (response.statusCode == 200) {
          // var tenantId = response.data['tenantId'];
          // await _saveTenantId(tenantId);

          // var tenantId = response.data['tenantId'];
          //      await _saveTenantId(tenantId);
          var tenant = await cacheService.getString(name: 'tenant');
          var planId = await cacheService.getString(name: 'planId');
          logger.d(tenant);
          logger.d(planId);

          print("tenant");
          print("planId");

          //emit(SigninSuccessState());
          //var tenant = await cacheService.getString(name: 'tenant');
          if (tenant == '0') {
            emit(SigninSuccessNoTenantState());
          } else {
            if (planId == '1') {
              emit(SigninSuccessEventState());
            } else {
              emit(SigninSuccessStableState());
            }
          }
        } else {
          await GoogleLoginApiService.signOut();
          emit(SigninWithGoogleBackendFailedState());
        }
      } else {
        await GoogleLoginApiService.signOut();
        emit(SigninWithGoogleFailedState());
      }
    } catch (e) {
      logger.e(e.toString());
      await GoogleLoginApiService.signOut();
      emit(SigninWithGoogleFailedState());
    }
  }

  Future<void> _signinWithFacebook(
    SigninWithFacebookEvent event,
    Emitter<SigninState> emit,
  ) async {
    try {
      var result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        var user = await FacebookAuth.instance.getUserData();
        if (user != null) {
          logger.d("Just before signin - launch");
          ApiResponse response = await authRepo.postLaunch();
          logger.d(response.data.toString());
          LoginModel loginmodel =
              LoginModel(userName: user['email'], password: 'equineapp');
          loginmodel.loginType = "facebook";
          loginmodel.loginName = user['email'];
          loginmodel.profileUrl = user['picture']['data']['url'] ?? '';
          response = await authRepo.postLogin(loginmodel);
          if (response.statusCode == 200) {
            var tenantId = response.data['tenantId'];
            await _saveTenantId(tenantId);
            var tenant = await cacheService.getString(name: 'tenant');
            if (tenant == '0') {
              emit(SigninSuccessNoTenantState());
            } else {
              emit(SigninSuccessState());
            }
          } else {
            await FacebookAuth.instance.logOut();
            emit(SigninWithFacebookBackendFailedState());
          }
        } else {
          await FacebookAuth.instance.logOut();
          emit(SigninWithFacebookFailedState());
        }
      } else {
        await FacebookAuth.instance.logOut();
        emit(SigninWithFacebookFailedState());
      }
    } catch (e) {
      logger.e(e.toString());
      await FacebookAuth.instance.logOut();
      emit(SigninWithFacebookFailedState());
    }
  }

  Future<void> _forgotPassword(
    SigninForgotPasswordEvent event,
    Emitter<SigninState> emit,
  ) async {
    try {
      emit(SigninForgotPasswordSubmittingState());
      ApiResponse response =
          await authRepo.postForgetPasseword(emailid: event.email);

      if (response.statusCode == 200) {
        emit(SigninForgotPasswordSuccessState(message: response.message));
      } else {
        emit(SigninForgotPasswordFailedState(message: response.message));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(SigninForgotPasswordFailedState(message: e.toString()));
    }
  }

  Future<void> _saveTenantId(int tenantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tenantId', tenantId);
  }
}
