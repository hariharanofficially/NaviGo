// invoice_event.dart
import 'package:equatable/equatable.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class LoadInvoice extends InvoiceEvent {}
