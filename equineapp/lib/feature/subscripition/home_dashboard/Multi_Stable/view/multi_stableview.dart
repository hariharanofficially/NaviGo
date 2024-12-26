// import 'package:EquineApp/Subscription_plan/Menu/singlestable_menu.dart';
import 'package:EquineApp/feature/all_api/TrackDevice/track_device_information.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:EquineApp/feature/header/app_bar.dart';
import 'package:EquineApp/feature/nav_bar/nav_bar.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/EventWidget.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Multi_Stable/bloc/multi_stable_bloc.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Multi_Stable/bloc/multi_stable_event.dart';
import 'package:EquineApp/utils/constants/icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../../data/models/roles.dart';
import '../../../manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';

class MultiStableDashboard extends StatefulWidget {
  const MultiStableDashboard({Key? key}) : super(key: key);

  @override
  _MultiStableDashboardState createState() => _MultiStableDashboardState();
}

class _MultiStableDashboardState extends State<MultiStableDashboard> {
  late MultiStableDashboardBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MultiStableDashboardBloc();
    _bloc.emitEvent(MultiStableDashboardEvent.loadInitialData);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const NavigitionWidget(),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                // Stable Container
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      height: 115,
                      decoration: BoxDecoration(
                        color: Color(0xffFDD9A3),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                        child: Column(
                          children: [
                            // Your Stable content
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(

                                  children: [
                                    Text(
                                      'Stables',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                    ),
                                    ),
                                    SizedBox(width: 15,),
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
                                )
                              ],
                            ),
                            SizedBox(height: 5,),

                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  'Al - Maghaweer Stables',style: GoogleFonts.karla(
                                  textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  'MSM Stables',style: GoogleFonts.karla(
                                  textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                ),
                              ],
                            ),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                textAlign: TextAlign.right,
                                'Tap to view more',style: GoogleFonts.karla(
                                textStyle: TextStyle( color: Color.fromRGBO(234, 146, 53, 1), fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Horses Container
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(208, 231, 249, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                        child: Column(
                          children: [
                            // Your Horses content
                                Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(

                                  children: [
                                    Text(
                                      'Horses',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                    ),
                                    ),
                                    SizedBox(width: 15,),
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
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 10,
                                      //Text
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      'Antico Oriente',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 10,
                                      //Text
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      'Gadjette Teoulere',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 10,
                                      //Text
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      'Shardell Nikayla',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    'Total Horses - 20/30',style: GoogleFonts.karla(
                                    textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                  ),
                                  ),
                                ),

                              ],

                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Riders Container
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                        child: Column(
                          children: [
                            // Your Riders content
                               Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(

                                  children: [
                                    Text(
                                      'Riders',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                                    ),
                                    ),
                                    SizedBox(width: 15,),
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
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 10,
                                      //Text
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      'Antico Oriente',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 10,
                                      //Text
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      'Gadjette Teoulere',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 10,
                                      //Text
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      'Shardell Nikayla',style: GoogleFonts.karla(
                                      textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                    ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 8),


                              ],

                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Events
                SizedBox(height: 10,),
                EventWidgetList(events: [], role: new RolesModel(id: 1, name: "test", level: 1)),
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
      //     backgroundColor: Colors.white,
      //     elevation: 0,
      //     onPressed: () => _bloc.emitEvent(MultiStableDashboardEvent.navigateToTrackDevice),
      //     shape: RoundedRectangleBorder(
      //       side: const BorderSide(width: 1.5, color: Color.fromRGBO(254, 149, 38, 0.7)),
      //       borderRadius: BorderRadius.circular(100),
      //     ),
      //     child: Image.asset('assets/images/Racing.png'),
      //   ),
      // ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _bloc.selectedTabIndex,
        initialData: 0, // Provide an initial value for the selected tab
        builder: (context, snapshot) {
          return NavBar(
            pageIndex: snapshot.data!,
            
          );
        },
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab $tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),

          ],
        ),
      ),
    );
  }
}

