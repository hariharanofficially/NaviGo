import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  late Razorpay _razorpay;

  PaymentBloc() : super(InitialPaymentState()) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    emit(PaymentSuccess());
    // Handle payment success here
  }

void _handlePaymentError(PaymentFailureResponse response) {
  emit(PaymentFailure(response.message ?? "Unknown error"));
  // Handle payment failure here
}


  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    // Handle external wallet selection here
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is StartPayment) {
      yield PaymentInProgress();
      var options = {
        'key': 'rzp_test_evHfKWMfi8iPsf', // Replace with your Razorpay API key
        'amount': event.amount,
        'name': 'Example Store',
        'description': 'Test Payment',
        'prefill': {'contact': event.contact, 'email': event.email},
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        yield PaymentFailure('Error starting payment: $e');
      }
    }
  }
}
