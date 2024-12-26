import 'package:equatable/equatable.dart';

abstract class PaymentSuccessEvent extends Equatable {
  const PaymentSuccessEvent();

  @override
  List<Object> get props => [];
}

class DownloadReceipt extends PaymentSuccessEvent {
  final String subPlan;
  final DateTime? selectedDate;

  const DownloadReceipt({required this.subPlan, this.selectedDate});

  @override
  List<Object> get props => [subPlan, selectedDate ?? ''];
}

class Continue extends PaymentSuccessEvent {
  final String subPlan;

  const Continue({required this.subPlan});

  @override
  List<Object> get props => [subPlan];
}
