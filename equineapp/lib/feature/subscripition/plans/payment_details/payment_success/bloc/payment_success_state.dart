import 'package:equatable/equatable.dart';

abstract class PaymentSuccessState extends Equatable {
  const PaymentSuccessState();

  @override
  List<Object> get props => [];
}

class PaymentSuccessInitial extends PaymentSuccessState {}

class DownloadingReceipt extends PaymentSuccessState {}

class ReceiptDownloaded extends PaymentSuccessState {}

class NavigationToScreen extends PaymentSuccessState {
  final String routeName;

  const NavigationToScreen(this.routeName);

  @override
  List<Object> get props => [routeName];
}
