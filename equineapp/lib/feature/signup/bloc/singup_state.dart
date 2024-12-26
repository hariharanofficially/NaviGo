part of 'singup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();
  @override
  List<Object> get props => [];
}

class SignupInitialState extends SignupState {}
class SignupOptionsState extends SignupState {}
class SignupWithEmailState extends SignupState {}
class SignupSubmittingState extends SignupState {}
class SignupSuccessState extends SignupState {}
class SigninFailedState extends SignupState {
  final String message;
  const SigninFailedState({required this.message});
  @override
  List<Object> get props => [message];
}
class SigninWithEmailFailedState extends SignupState{}

class SignupWithGoogleSuccessState extends SignupState {}
class SignupWithGoogleBackendFailedState extends SignupState{}
class SignupWithGoogleFailedState extends SignupState {}
class SignupWithFacebookSuccessState extends SignupState {}
class SignupWithFacebookBackendFailedState extends SignupState{}
class SignupWithFacebookFailedState extends SignupState {}
