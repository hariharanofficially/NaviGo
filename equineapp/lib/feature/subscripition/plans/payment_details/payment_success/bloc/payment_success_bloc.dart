import 'package:bloc/bloc.dart';
import 'payment_success_event.dart';
import 'payment_success_state.dart';

class PaymentSuccessBloc extends Bloc<PaymentSuccessEvent, PaymentSuccessState> {
  PaymentSuccessBloc() : super(PaymentSuccessInitial()) {
    on<DownloadReceipt>((event, emit) {
      emit(DownloadingReceipt());
      // Add your logic to handle the receipt download here
      emit(ReceiptDownloaded());
    });

    on<Continue>((event, emit) {
      if (event.subPlan == 'Single Stable (Individual)' || event.subPlan == 'Multiple Stable Group') {
        emit(NavigationToScreen('SingleStableDashboard'));
      } else {
        emit(NavigationToScreen('EventsOrganizerDashboard'));
      }
    });
  }
}
