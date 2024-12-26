part of 'signin_bloc.dart';

abstract class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitialState extends SigninState {}

class SigninSubmittingState extends SigninState {}

class SigninSuccessState extends SigninState {}

class SigninSuccessEventState extends SigninState {}

class SigninSuccessStableState extends SigninState {}

class SigninSuccessNoTenantState extends SigninState {}

class SigninFailedState extends SigninState {
  final String message;
  const SigninFailedState({required this.message});
  @override
  List<Object> get props => [message];
}

class SigninPasswordShowState extends SigninState {
  final bool showPasswordIcon;
  const SigninPasswordShowState({required this.showPasswordIcon});
  @override
  List<Object> get props => [showPasswordIcon];
}

class SigninWithGoogleSuccessState extends SigninState {}

class SigninWithGoogleBackendFailedState extends SigninState {}

class SigninWithGoogleFailedState extends SigninState {}

class SigninWithFacebookSuccessState extends SigninState {}

class SigninWithFacebookBackendFailedState extends SigninState {}

class SigninWithFacebookFailedState extends SigninState {}

class SigninForgotPasswordSubmittingState extends SigninState {}

class SigninForgotPasswordSuccessState extends SigninState {
  final String message;
  SigninForgotPasswordSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class SigninForgotPasswordFailedState extends SigninState {
  final String message;

  SigninForgotPasswordFailedState({required this.message});

  @override
  List<Object> get props => [message];
}
