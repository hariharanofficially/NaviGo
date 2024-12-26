// invoice_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final String subPlan;
  final DateTime selectedDate;

  InvoiceBloc({required this.subPlan, required this.selectedDate}) : super(InvoiceInitial()) {
    on<LoadInvoice>(_onLoadInvoice);
  }

  void _onLoadInvoice(LoadInvoice event, Emitter<InvoiceState> emit) {
    emit(InvoiceLoaded(subPlan, selectedDate));
  }
}
