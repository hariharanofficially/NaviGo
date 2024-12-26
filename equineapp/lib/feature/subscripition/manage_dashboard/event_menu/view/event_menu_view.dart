import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../feature/home/home_screen.dart';
import '../../../../../feature/my_approval/bloc/my_approval_bloc.dart';
import '../../../../../feature/my_approval/view/my_approval_view.dart';
import '../../../../../feature/nav_bar/event_nav_bar.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/events_dashboard/bloc/events_dashboard_bloc.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/events_dashboard/view/events_dashboard_view.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/horse_dashboard/bloc/horse_dashboard_bloc.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/horse_dashboard/view/horse_dashboard_view.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/owner_dashboard/bloc/owner_bloc.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/owner_dashboard/view/owner_view.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/participant_dashboard/bloc/participant_dashboard_bloc.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/participant_dashboard/view/participant_dashboard_view.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/riders_dashboard/bloc/riders_dashboard_bloc.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/riders_dashboard/view/riders_dashboard_view.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_bloc.dart';
import '../../../../../feature/subscripition/manage_dashboard/cards/stable_dashboard/view/stable_dashboard_view.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../cards/trainer_dashboard/bloc/trainer_dashboard_bloc.dart';
import '../../cards/trainer_dashboard/view/trainer_dashboard_view.dart';
import '../bloc/event_menu_bloc.dart';

class EventMenu extends StatelessWidget {
  const EventMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventMenuBloc(),
      child: EventMenuview(),
    );
  }
}

class EventMenuview extends StatelessWidget {
  const EventMenuview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
              height: 45,
              width: MediaQuery.sizeOf(context).width * 0.85,
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
                      title: 'Horse',
                      isProfile: false,
                      showActions: true,
                    ),
                  ),
                ),
                buildDashboardItem(
                  context,
                  'Events',
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
                      child: TrainersDashboard()),
                ),
              ],
            ),
            Row(
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
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
              height: 45,
              width: MediaQuery.sizeOf(context).width * 0.85,
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
                null,
              ),
            ),
          ],
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
      bottomNavigationBar: BlocBuilder<EventMenuBloc, EventMenuState>(
        builder: (context, state) {
          int selectedTab = 0;
          if (state is EventMenuSelectedTab) {
            selectedTab = state.tabIndex;
          }
          return NavBar(
            pageIndex: selectedTab,
            // onTap: (index) {
            //   BlocProvider.of<EventMenuBloc>(context)
            //       .add(SelectTabEventMenu(index));
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
