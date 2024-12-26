import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class StartPayment extends PaymentEvent {
  final int amount;
  final String contact;
  final String email;

  StartPayment({
    required this.amount,
    required this.contact,
    required this.email,
  });

  @override
  List<Object?> get props => [amount, contact, email];
}
