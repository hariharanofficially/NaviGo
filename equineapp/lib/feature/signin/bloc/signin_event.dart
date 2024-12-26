part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();
  @override
  List<Object> get props => [];
}

class SigninInitialEvent extends SigninEvent {}

class SigninSubmitEvent extends SigninEvent {
  final String username;
  final String password;

  const SigninSubmitEvent({required this.username, required this.password});

  @override
  List<Object> get props => [];
}

class SigninPasswordShowEvent extends SigninEvent {}

class SigninWithGoogleEvent extends SigninEvent {}

class SigninWithFacebookEvent extends SigninEvent {}

class SigninForgotPasswordEvent extends SigninEvent {
  final String email;

  SigninForgotPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}
