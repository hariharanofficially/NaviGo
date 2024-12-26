import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_bloc.dart';
import 'package:EquineApp/feature/generate_qr/view/generate_qr_view.dart';

import '../../common/widgets/custom_app_bar_widget.dart';
import '../bloc/my_plan_bloc.dart';
import '../bloc/my_plan_event.dart';
import '../bloc/my_plan_state.dart';
import 'package:intl/intl.dart';

class CustomIcons {
  static const IconData whatsapp = IconData(0xe800, fontFamily: 'CustomIcons');
  static const IconData imo = IconData(0xe801, fontFamily: 'CustomIcons');
  static const IconData messenger = IconData(0xe802, fontFamily: 'CustomIcons');
  static const IconData message = IconData(0xe803, fontFamily: 'CustomIcons');
}

class MyPlan extends StatefulWidget {
  const MyPlan({super.key});

  @override
  State<MyPlan> createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myplanBloc()..add(Loadmyplan()),
      child: Scaffold(
        endDrawer: const NavigitionWidget(),
        appBar: CustomAppBarWidget(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'My Subscription',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            BlocBuilder<myplanBloc, myplanState>(
              builder: (context, state) {
                if (state is myplanLoading) {
                  return CircularProgressIndicator();
                } else if (state is myplanLoaded) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 322,
                          height: 160.77,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: Color(0xFFD5DCEE),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 21,
                                width: 101,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
                                  color: Color(0XFF8E8CF6),
                                ),
                                child: Center(
                                  child: Text(
                                    'My Plan',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.planName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0XFF2C29B6)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                       'expires ${DateFormat.yMMMd().format(state.expiryDate)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0XFF7B3193)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          context.read<myplanBloc>().add(Upgrademyplan());
                                        },
                                        child: Text('Upgrade plan'))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 110,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromRGBO(142, 140, 246, 1),
                          child: Center(
                            child: Text(
                              '1990',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else if (state is myplanError) {
                  return Text(state.message);
                } else {
                  return Text('Please wait...');
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 248,
                height: 27,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => QrBloc(),
                          child: GenerateQr(),
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFE29F3A),
                    ),
                  ),
                  child: Text(
                    'Generate and Share Code',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
