import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class InitialPaymentState extends PaymentState {}

class PaymentInProgress extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String errorMessage;

  PaymentFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
