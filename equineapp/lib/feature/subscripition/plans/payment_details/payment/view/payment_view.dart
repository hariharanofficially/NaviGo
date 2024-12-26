import 'package:EquineApp/feature/common/widgets/custom_app_bar_widget.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:EquineApp/feature/subscripition/plans/payment_details/payment/bloc/payment_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/payment_details/payment/bloc/payment_event.dart';
import 'package:EquineApp/feature/subscripition/plans/payment_details/payment/bloc/payment_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PaymentPage extends StatelessWidget {
   const PaymentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(),
      child: Scaffold(
        endDrawer: const NavigitionWidget(),
        appBar: CustomAppBarWidget(),
        body: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is PaymentInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PaymentSuccess) {
              return _buildSuccessWidget(context);
            } else if (state is PaymentFailure) {
              return _buildFailureWidget(context, state.errorMessage);
            } else {
              return _buildInitialWidget(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildInitialWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          height: 132,
          decoration: const BoxDecoration(
            color: Color(0xFF8B48DF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<PaymentBloc>().add(
                      StartPayment(
                        amount: 10000,
                        contact: '1234567890',
                        email: 'example@example.com',
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
              ),
              child: const Text('Continue'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessWidget(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          SizedBox(height: 20),
          Text(
            'Payment Successful!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 20),
          const Text(
            'Payment Failed!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(errorMessage),
        ],
      ),
    );
  }
}
