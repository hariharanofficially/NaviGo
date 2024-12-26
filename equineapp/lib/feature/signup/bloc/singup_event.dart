part of 'singup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object> get props => [];
}

class SignupInitialEvent extends SignupEvent {}

class SignupOptionsViewEvent extends SignupEvent {}

class SignupWithEmailViewEvent extends SignupEvent {}

class SignupWithGoogleEvent extends SignupEvent {}
class SignupWithFacebookEvent extends SignupEvent {}
class SignupWithEmailEvent extends SignupEvent {
  final SignupModel signupModel;
  SignupWithEmailEvent({required this.signupModel});
}
