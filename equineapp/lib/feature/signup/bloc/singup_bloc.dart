import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/singup_model.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/google/google_login.dart';

part 'singup_event.dart';
part 'singup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  Logger logger = new Logger();
  SignupBloc() : super(SignupInitialState()) {
    on<SignupInitialEvent>((event, emit) {
      // TODO: implement event handler
      emit(SignupOptionsState());
    });
    on<SignupOptionsViewEvent>((event, emit) {
      emit(SignupOptionsState());
    });
    on<SignupWithEmailViewEvent>((event, emit) {
      emit(SignupWithEmailState());
    });
    on<SignupWithGoogleEvent>((event, emit) async {
      await _signupWithGoogle(event, emit);
    });
    on<SignupWithEmailEvent>((event, emit) async {
      await _signupWithEmail(event, emit);
    });
    on<SignupWithFacebookEvent>((event, emit) async {
      await _signupWithFacebook(event, emit);
    });
  }

  Future<void> _signupWithGoogle(
    SignupWithGoogleEvent event,
    Emitter<SignupState> emit,
  ) async {
    try {
      var user = await GoogleLoginApiService.login();
      if (user != null) {
        logger.d("=======Just before signup - launch");
        await authRepo.postLaunch();

        logger.d('Email: ${user.email}');

        Map data = {
          "user": {
            "firstName": user.displayName,
            "lastName": '',
            "userName": user.email,
            "password": 'equineapp',
            "email": user.email,
            "userType": "GMAIL",
            "socialAuthCode": user.id,
            "role": {"id": "1"}
          }
        };

        ApiResponse response = await authRepo.postSignup(data);

        if (response.statusCode == 200) {
          emit(SignupSuccessState());
        } else {
          await GoogleLoginApiService.signOut();
          emit(SignupWithGoogleBackendFailedState());
        }
      } else {
        await GoogleLoginApiService.signOut();
        emit(SignupWithGoogleFailedState());
      }
    } catch (e) {
      logger.e(e.toString());
      await GoogleLoginApiService.signOut();
      emit(SignupWithGoogleFailedState());
    }
  }

  Future<void> _signupWithEmail(
    SignupWithEmailEvent event,
    Emitter<SignupState> emit,
  ) async {
    try {
      logger.d("=======Just before signup - launch");
      await authRepo.postLaunch();

      SignupModel signupModel = event.signupModel;
      Map data = {
        "user": {
          "firstName": signupModel.firstname,
          "lastName": '',
          "userName": signupModel.username,
          "password": signupModel.password,
          "email": signupModel.email,
          "userType": "IN-APP",
          "socialAuthCode": signupModel.username,
          "role": {"id": "1"}
        }
      };

      ApiResponse response = await authRepo.postSignup(data);

      if (response.statusCode == 200) {
        await Future.delayed(Duration(seconds: 2));
        emit(SignupSuccessState());
      } else {
        emit(SigninWithEmailFailedState());
      }
    } catch (e) {
      logger.e(e.toString());
      emit(SigninWithEmailFailedState());
    }
  }
  Future<void> _signupWithFacebook(
    SignupWithFacebookEvent event,
    Emitter<SignupState> emit,
  ) async {
    try {
      var result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        var user = await FacebookAuth.instance.getUserData();
        if (user != null) {
          logger.d("=======Just before signup - launch");
          await authRepo.postLaunch();
          logger.d('Email: ${user['email']}');
          Map data = {
            "user": {
              "firstName": user['name'],
              "lastName": '',
              "userName": user['email'],
              "password": 'equineapp',
              "email": user['email'],
              "userType": "FACEBOOK",
              "socialAuthCode": user['id'],
              "role": {"id": "1"}
            }
          };
          ApiResponse response = await authRepo.postSignup(data);
          if (response.statusCode == 200) {
            emit(SignupSuccessState());
          } else {
            await FacebookAuth.instance.logOut();;
            emit(SignupWithFacebookBackendFailedState());
          }
        } else {
          emit(SignupWithFacebookFailedState());
        }
      } else {
        await FacebookAuth.instance.logOut();
        emit(SignupWithFacebookFailedState());
      }
    } catch (e) {
      logger.e(e.toString());
      await FacebookAuth.instance.logOut();
      emit(SignupWithFacebookFailedState());
    }
  }
}
