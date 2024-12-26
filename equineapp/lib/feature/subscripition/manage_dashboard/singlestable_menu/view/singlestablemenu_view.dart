import 'package:EquineApp/feature/all_api/TrackDevice/track_device_information.dart';
import 'package:EquineApp/feature/MockRace_dashboard/bloc/MockRace_dashboard_bloc.dart';
import 'package:EquineApp/feature/MockRace_dashboard/view/MockRace_dashboard_view.dart';
import 'package:EquineApp/feature/byhorses/bloc/byhorses_bloc.dart';
import 'package:EquineApp/feature/byhorses/byhorses_view.dart';
import 'package:EquineApp/feature/bysession/bloc/bysession_bloc.dart';
import 'package:EquineApp/feature/bysession/view/bysession_view.dart';
import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:EquineApp/feature/nav_bar/nav_bar.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/horse_dashboard/bloc/horse_dashboard_bloc.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/horse_dashboard/view/horse_dashboard_view.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/participant_dashboard/bloc/participant_dashboard_bloc.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/participant_dashboard/view/participant_dashboard_view.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/riders_dashboard/bloc/riders_dashboard_bloc.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/riders_dashboard/view/riders_dashboard_view.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/singlestable_menu/bloc/singlestablemenu_event.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/singlestable_menu/bloc/singlestablemenu_state.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_bloc.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/stable_dashboard/view/stable_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../my_approval/bloc/my_approval_bloc.dart';
import '../../../../my_approval/view/my_approval_view.dart';
import '../../../../mydevice/mydevice_dashboard/bloc/mydevice_bloc.dart';
import '../../../../mydevice/mydevice_dashboard/view/my_device_view.dart';
import '../../cards/events_dashboard/bloc/events_dashboard_bloc.dart';
import '../../cards/events_dashboard/view/events_dashboard_view.dart';
import '../../cards/owner_dashboard/bloc/owner_bloc.dart';
import '../../cards/owner_dashboard/view/owner_view.dart';
import '../../cards/trainer_dashboard/bloc/trainer_dashboard_bloc.dart';
import '../../cards/trainer_dashboard/view/trainer_dashboard_view.dart';

class SingeleStableMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SingleStableMenuBloc(),
      child: SingeleStableMenuView(),
    );
  }
}

class SingeleStableMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  height: 45, width: double.infinity,
                  //width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(11, 73, 28, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Manage',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildDashboardItem(
                          context,
                          'Stables',
                          'assets/images/Stables.png',
                          BlocProvider(
                              create: (context) => StableBloc(),
                              child: StableDashboard()),
                        ),
                        buildDashboardItem(
                          context,
                          'Horses',
                          'assets/images/Horses.png',
                          BlocProvider(
                            create: (context) => HorseDashboardBloc(),
                            child: HorseDashboard(
                              title: 'Horses',
                              isProfile: false,
                              showActions: true,
                            ),
                          ),
                        ),
                        buildDashboardItem(
                          context,
                          'Race',
                          'assets/images/event.png',
                          BlocProvider(
                              create: (context) => EventsDashboardBloc(),
                              child: EventsDashboard()),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildDashboardItem(
                          context,
                          'Owner',
                          'assets/images/participants.png',
                          BlocProvider(
                              create: (context) => OwnerBloc(),
                              child: OwnerDashboard()),
                          //ParticipantDashboard(),
                        ),
                        buildDashboardItem(
                          context,
                          'Rider',
                          'assets/images/Riders.png',
                          BlocProvider(
                              create: (context) => RidersBloc(),
                              child: RidersDashboard()),
                        ),
                        buildDashboardItem(
                            context,
                            'Trainer',
                            'assets/images/trainer.png',
                            BlocProvider(
                                create: (context) => TrainersBloc(),
                                child: TrainersDashboard())),

                        // buildDashboardItem(
                        //   context,
                        //   'Participants',
                        //   'assets/images/participants.png',
                        //   BlocProvider(
                        //       create: (context) => ParticipantBloc(),
                        //       child: ParticipantDashboard()),
                        //   //ParticipantDashboard(),
                        // ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildDashboardItem(
                          context,
                          'My Approval',
                          'assets/images/myapproval.png',
                          BlocProvider(
                              create: (context) => MyApprovalBloc(),
                              child: MyApproval()),
                          //ParticipantDashboard(),
                        ),
                        buildDashboardItem(
                          context,
                          'My device',
                          'assets/images/mydevice.png',
                          BlocProvider(
                              create: (context) => MydeviceBloc(),
                              child: mydevice()),
                          //ParticipantDashboard(),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  height: 45, width: double.infinity,
                  //width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(11, 73, 28, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Training & Analysis',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDashboardItem(
                      context,
                      'Mock Race',
                      'assets/images/MockRace.png',
                      // null,
                      BlocProvider(
                          create: (context) => MockRaceDashboardBloc(),
                          child: MockRaceDashboard()),
                    ),
                    buildDashboardItem(
                      context,
                      'Training',
                      'assets/images/Horse_riding.png',
                      // null,
                      BlocProvider(
                          create: (context) => Bysessionbloc(),
                          child: Bysession()),
                    ),
                    buildDashboardItem(
                      context,
                      'By Horse',
                      'assets/images/by-horse.png',
                      // null,
                      BlocProvider(
                          create: (context) => byhorsesbloc(),
                          child: byhorses()),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  height: 45, width: double.infinity,
                  //width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(11, 73, 28, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Profiling',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: buildDashboardItem(
                    context,
                    'Health',
                    'assets/images/Health.png',
                    BlocProvider(
                      create: (context) => HorseDashboardBloc(),
                      child: HorseDashboard(
                        title: 'Horses Lists',
                        isProfile: true,
                        showActions: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //   margin: const EdgeInsets.only(top: 80),
      //   height: 64,
      //   width: 64,
      //   child: FloatingActionButton(
      //       backgroundColor: Colors.white,
      //       elevation: 0,
      //       onPressed: () => Navigator.push(
      //           // context, MaterialPageRoute(builder: (context) => TrackDeviceInfoScreen())),
      //           context,
      //           MaterialPageRoute(builder: (context) => HomeScreen())),
      //       shape: RoundedRectangleBorder(
      //         side: const BorderSide(
      //           width: 1.5,
      //           color: Color.fromRGBO(254, 149, 38, 0.7),
      //         ),
      //         borderRadius: BorderRadius.circular(100),
      //       ),
      //       child: Image.asset('assets/images/Racing.png')),
      // ),
      bottomNavigationBar:
          BlocBuilder<SingleStableMenuBloc, SingleStableMenuState>(
        builder: (context, state) {
          int selectedTab = 0;
          if (state is SingleStableMenuSelectedTab) {
            selectedTab = state.tabIndex;
          }
          return NavBar(
            pageIndex: selectedTab,
            // onTap: (index) {
            //   BlocProvider.of<SingleStableMenuBloc>(context)
            //       .add(SelectTabEvent(index));
            // },
          );
        },
      ),
    );
  }

  Widget buildDashboardItem(BuildContext context, String title,
      String assetPath, Widget? targetPage) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        height: 85,
        width: MediaQuery.sizeOf(context).width * 0.25,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 0.75))
            ],
            border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.2)),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                Image.asset(
                  assetPath,
                  height: 50,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  style: GoogleFonts.karla(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(133, 68, 154, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => targetPage));
        }
      },
    );
  }
}
