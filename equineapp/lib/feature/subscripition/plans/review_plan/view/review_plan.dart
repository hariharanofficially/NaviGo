import 'package:EquineApp/feature/subscripition/plans/payment_details/payment_success/bloc/payment_success_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/payment_details/payment_success/view/payment_success_view.dart';
// import 'package:EquineApp/payment_details/payment_success.dart';
import 'package:EquineApp/feature/subscripition/plans/review_plan/bloc/review_plan_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/review_plan/bloc/review_plan_state.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/bloc/subscription_plan_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/view/subscription_plan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:EquineApp/feature/InvoiceScreen/view/quatation.dart';

import '../bloc/review_plan_event.dart';

class ReviewPage extends StatelessWidget {
  final String name;
  final int planId;
  final String planName;
  final String noOfEvents;
  final String noOfStables;
  final String noOfHorses;
  final String selectedSubscription;
  final String selectedSubName;

  ReviewPage({
    required this.name,
    required this.planId,
    required this.planName,
    required this.noOfEvents,
    required this.noOfStables,
    required this.noOfHorses,
    required this.selectedSubscription,
    required this.selectedSubName,
  });

  @override
  Widget build(BuildContext context) {
  return BlocProvider(
  create: (context) => ReviewPageBloc(),
  child: MaterialApp(debugShowCheckedModeBanner: false,
    home: ReviewPagescreen(
        name: this.name,
        planId: this.planId,
        planName: this.planName,
        noOfEvents: this.noOfEvents,
        noOfStables: this.noOfStables,
        noOfHorses: this.noOfHorses,
        selectedSubscription: this.selectedSubscription,
        selectedSubName: this.selectedSubName
    ),
  ),
);

  }
}

class ReviewPagescreen extends StatelessWidget {
  String subPlan = "";
  DateTime selectedDate = DateTime.now();
  final String name;
  final int planId;
  final String planName;
  final String noOfEvents;
  final String noOfStables;
  final String noOfHorses;
  final String selectedSubscription;
  final String selectedSubName;
  ReviewPagescreen({
    required this.name,
    required this.planId,
    required this.planName,
    required this.noOfEvents,
    required this.noOfStables,
    required this.noOfHorses,
    required this.selectedSubscription,
    required this.selectedSubName,
  });
  final ReviewPageBloc bloc = ReviewPageBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<ReviewPageBloc, ReviewPageState>(
        listener: (conent, state) {
          if (state is AddTenantSuccess) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (_) => PaymentSuccessBloc(),
                    child: PaymentSuccess(planId: this.planId, subPlan: this.subPlan, selectedDate: this.selectedDate),
                   ),
                ),
              );
          } else if (state is AddTenantFailed) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => PaymentSuccessBloc(),
                  child: PaymentSuccess(planId: this.planId, subPlan: this.subPlan, selectedDate: this.selectedDate),
                ),
              ),
            );
          } else if (state is ReviewPageLoaded) {
            this.subPlan = state.subPlan;
            this.selectedDate = state.selectedDate!;
          }
        },
        builder: (context, state) {
          if (state is ReviewPageLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Review your Plan'),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 50,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              color: Color(0xFF8B48DF),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        this.planName,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(
                                        this.selectedSubName,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: 15,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     if (state.selectedDate != null)
                                  //       Text(
                                  //         'Plan Start From : ${state.selectedDate?.day}-${state.selectedDate?.month}-${state.selectedDate?.year}',
                                  //         style: TextStyle(color: Colors.white),
                                  //       )
                                  //     else if (state.selectedOption ==
                                  //         'Unlimited')
                                  //       Text(
                                  //         'Plan start - After payment is received',
                                  //         style: TextStyle(color: Colors.white),
                                  //       )
                                  //     else
                                  //       Text(
                                  //         'Plan time - 15 days',
                                  //         style: TextStyle(color: Colors.white),
                                  //       )
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      (this.planId == 1)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  height: 75,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    color: Color(0xFFF6ADAD),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Number of Events',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              this.noOfEvents,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                height: 100,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  color: Color(0xFFF6ADAD),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Number of Stables',
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            this.noOfStables,
                                            style: TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Number of Horses',
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            this.noOfHorses,
                                            style: TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: 65,
                          width: 351,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    (state.noofStables != '')
                                        ? Text(
                                            ((int.parse(state.noofStables)) *
                                                    (int.parse(state.noofHorse)) *
                                                    2)
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          )
                                        : Text(
                                            '1990',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '* Offers Term apply',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 100,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              color: Color(0xFFF6ADAD),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Choose Option to pay',
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.72,
                                        child: Text(
                                          'You can use direct payment or using your Gpay',
                                          style: GoogleFonts.karla(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: InkWell(
                            onTap: () {

                              context.read<ReviewPageBloc>().add(AddUserTenant(
                                name: this.name,
                                plan: this.planId.toString(),
                                  selectedSubscription: this.selectedSubscription,
                                noofEvents: this.noOfEvents,
                                noofHorse: this.noOfHorses,
                                noofStables: this.noOfStables
                              ));


//                               Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => BlocProvider(
//       create: (_) => PaymentSuccessBloc(),
//       child: PaymentSuccess(planId: this.planId, subPlan: state.subPlan, selectedDate: state.selectedDate),
//      ),
//   ),
// );

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PaymentSuccess(
                              //       subPlan: state.subPlan,
                              //       selectedDate: state.selectedDate,
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              height: 60,
                              width: 350,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 30,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/plans/upi.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 30,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/plans/gpay.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 30,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/plans/paytm.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 30,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/plans/visa.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          height: 42,
                          width: 350,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceScreen(
                                    subPlan: state.subPlan,
                                    selectedDate: state.selectedDate,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text(
                              'Quotation',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          height: 42,
                          width: 350,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(   create: (context) => SubscriptionBloc(),
                                  child: subs_plan()),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text(
                              'Change Plan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }


}
