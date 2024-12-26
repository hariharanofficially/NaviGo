import 'package:EquineApp/feature/subscripition/plans/payment_details/payment_success/bloc/payment_success_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/payment_details/payment_success/bloc/payment_success_event.dart';
import 'package:EquineApp/feature/subscripition/plans/payment_details/payment_success/bloc/payment_success_state.dart';
import 'package:EquineApp/feature/InvoiceScreen/view/quatation.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/bloc/event_oraganizer_bloc.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/view/event_organizer_view.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/bloc/single_stable_bloc.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/view/single_stable_view.dart';
import 'package:EquineApp/utils/constants/icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';



class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key,
    required this.planId,
    required this.subPlan,
    required this.selectedDate});
  final int planId;
  final String subPlan;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInRight(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Iconify(
                  success,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            FadeInLeft(
              child: Text(
                'Payment Success!',
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: SizedBox(
                  height: 42,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PaymentSuccessBloc>().add(DownloadReceipt(subPlan: subPlan, selectedDate: selectedDate));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      'Download Receipt',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                height: 42,
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PaymentSuccessBloc>().add(Continue(subPlan: subPlan));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    'Continue',style: GoogleFonts.karla(
                    textStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  ),
                ),
              ),
            ),
            BlocListener<PaymentSuccessBloc, PaymentSuccessState>(
              listener: (context, state) {
                if (state is ReceiptDownloaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoiceScreen(
                        subPlan: subPlan,
                        selectedDate: selectedDate,
                      ),
                    ),
                  );
                } else if (state is NavigationToScreen) {
                  //if (state.routeName == 'SingleStableDashboard') {
                  if (this.planId != 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>BlocProvider(create:(context) => SingleStableDashboardBloc(),child: SingleStableDashboard(),)
                      ),
                    );
                  //} else if (state.routeName == 'EventsOrganizerDashboard') {
                  } else if (this.planId == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(create: (context) => EventsOrganizerBloc(),child: EventsOrganizerDashboard()),
                      ),
                    );
                  }
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
