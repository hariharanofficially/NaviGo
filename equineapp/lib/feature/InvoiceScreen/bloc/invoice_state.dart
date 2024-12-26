// invoice_state.dart
import 'package:equatable/equatable.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final String subPlan;
  final DateTime selectedDate;

  const InvoiceLoaded(this.subPlan, this.selectedDate);

  @override
  List<Object> get props => [subPlan, selectedDate];
}
