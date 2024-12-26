import 'package:EquineApp/feature/subscripition/add_forms/Horse/bloc/add_horse_bloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Horse/view/add_horse.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Rider/view/add_rider.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Stable/bloc/add_stable_bloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Stable/view/add_stable.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:EquineApp/feature/header/app_bar.dart';
import 'package:EquineApp/feature/nav_bar/nav_bar.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/riders_dashboard/bloc/riders_dashboard_bloc.dart';
import 'package:EquineApp/feature/nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import 'package:EquineApp/feature/nav_bar/Dashboard/bloc/Dashboard_event.dart';
import 'package:EquineApp/feature/nav_bar/Dashboard/bloc/Dashboard_state.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/EventWidget.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/bloc/event_oraganizer_bloc.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/view/event_organizer_view.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Multi_Stable/bloc/multi_stable_bloc.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Multi_Stable/view/multi_stableview.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/bloc/single_stable_bloc.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/view/single_stable_view.dart';
import 'package:EquineApp/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../data/models/roles.dart';



class AddDashboard extends StatelessWidget {
  const AddDashboard({super.key, required this.screen});
  final String screen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadDashboardEvent()),
      child: AddDashboardView(screen: screen),
    );
  }
}

class AddDashboardView extends StatelessWidget {
  const AddDashboardView({super.key, required this.screen});
  final String screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const NavigitionWidget(),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is NavigateToStable) {
           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(create: (context) => AddStableBloc(),child: AddStableScreen())),
                          );
          } else if (state is NavigateToHorse) {
            Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider(create: (context) => AddHorseBloc(),child: AddHorseScreen())),
                                    );
          } else if (state is NavigateToRider) {
              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(create: (context) => RidersBloc(),child: AddRiderScreen()),
                                      ),
                                    );
          } else if (state is NavigateToPlan) {
            if (state.screen == 'Single Stable (Individual)') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>BlocProvider(create:(context) => SingleStableDashboardBloc(),child: SingleStableDashboard())
                ),
              );
            } else if (state.screen == 'Multiple Stable Group') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>BlocProvider(create: (context) =>MultiStableDashboardBloc(),child: MultiStableDashboard()),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(create: (context) => EventsOrganizerBloc(),child: EventsOrganizerDashboard()),
                ),
              );
            }
          }
        },
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: GestureDetector(
                      onTap: () {
                        context.read<DashboardBloc>().add(NavigateToAddStableEvent());
                      },
                      child: Container(
                        height: 85,
                        decoration: BoxDecoration(
                          color: Color(0xffFDD9A3),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Stables',
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Icon(
                                        Icons.add_circle_outline_outlined,
                                        color: Color.fromRGBO(234, 146, 53, 1),
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                  Iconify(
                                    moreHorizondal,
                                    color: Color.fromRGBO(234, 146, 53, 1),
                                    size: 28,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Center(
                                child: Text(
                                  'Please add stables',
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: GestureDetector(
                      onTap: () {
                        context.read<DashboardBloc>().add(NavigateToAddHorseEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(208, 231, 249, 1),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Horses',
                                          style: GoogleFonts.karla(
                                            textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Icon(
                                          Icons.add_circle_outline_outlined,
                                          color: Color.fromRGBO(139, 72, 223, 0.5),
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                    Iconify(
                                      moreHorizondal,
                                      color: Color.fromRGBO(139, 72, 223, 1),
                                      size: 28,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Center(
                                  child: Text(
                                    'Please add Horses',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    'Total Horses - 0/0',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: GestureDetector(
                      onTap: () {
                        context.read<DashboardBloc>().add(NavigateToAddRiderEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Riders',
                                          style: GoogleFonts.karla(
                                            textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Icon(
                                          Icons.add_circle_outline_outlined,
                                          color: Color.fromRGBO(139, 72, 223, 0.5),
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                    Iconify(
                                      moreHorizondal,
                                      color: Color.fromRGBO(139, 72, 223, 1),
                                      size: 28,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Center(
                                  child: Text(
                                    'Please add riders',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  EventWidgetList(events: [], role: new RolesModel(id: 1, name: "test", level: 1)),
                ],
              ),
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
      //     backgroundColor: Colors.white,
      //     elevation: 0,
      //     onPressed: () => debugPrint("Add Button pressed"),
      //     shape: RoundedRectangleBorder(
      //       side: const BorderSide(
      //         width: 1.5,
      //         color: Color.fromRGBO(254, 149, 38, 0.7),
      //       ),
      //       borderRadius: BorderRadius.circular(100),
      //     ),
      //     child: Image.asset('assets/images/Racing.png'),
      //   ),
      // ),
      bottomNavigationBar: NavBar(
        pageIndex: 0,
        // onTap: (index) {
        //   if (index == 3) {
        //     context.read<DashboardBloc>().add(NavigateToPlanEvent(screen));
        //   }
        // },
      ),
    );
  }
}
