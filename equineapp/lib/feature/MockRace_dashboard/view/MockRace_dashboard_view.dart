import 'package:EquineApp/feature/subscripition/add_forms/Event/bloc/AddEvent_bloc.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Event/event_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:EquineApp/feature/header/app_bar.dart';
import 'package:EquineApp/utils/constants/icons.dart';

import '../../../../data/models/event_model.dart';

import '../../../../feature/home/home_screen.dart';
import '../../../../feature/nav_bar/nav_bar.dart';
import '../../horsesActivity/bloc/horseactivity_bloc.dart';
import '../../horsesActivity/horseactivity_view.dart';
import '../../subscripition/add_forms/Event/view/add_event.dart';
import '../../subscripition/manage_dashboard/cards/participant_dashboard/bloc/participant_dashboard_bloc.dart';
import '../../subscripition/manage_dashboard/cards/participant_dashboard/view/participant_dashboard_view.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../bloc/MockRace_dashboard_bloc.dart';
import '../bloc/MockRace_dashboard_event.dart';
import '../bloc/MockRace_dashboard_state.dart';

class MockRaceDashboard extends StatefulWidget {
  const MockRaceDashboard({super.key});

  @override
  State<MockRaceDashboard> createState() => _MockRaceDashboardState();
}

class _MockRaceDashboardState extends State<MockRaceDashboard> {
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    context.read<MockRaceDashboardBloc>().add(LoadMockRace());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MockRaceDashboardBloc, MockRaceDashboardState>(
        listener: (context, state) {
      if (state is MockRaceError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(),
        endDrawer: const NavigitionWidget(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: state is MockRaceLoading
                  ? Center(child: CircularProgressIndicator())
                  : state is MockRaceLoaded
                      ? Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.redAccent), // Back icon
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Action when back icon is pressed
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(
                                            0xFFE5E5FC), // Set the background color to blue
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Set the border radius
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 25, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Mock Race',
                                            style: GoogleFonts.karla(
                                              textStyle: TextStyle(
                                                color: Color(0xFF595BD4),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider(
                                                          create: (context) =>
                                                              AddEventBloc(),
                                                          child: AddEventScreen(
                                                            fromScreen: "mock",
                                                            edittitle:
                                                                'Edit MockRace',
                                                            addtitle:
                                                                'Add MockRace',
                                                            updateadd:
                                                                'Add MockRace',
                                                            updateedit:
                                                                'Update MockRace',
                                                          )),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width:
                                                  50, // Adjust width to fit the icon
                                              height:
                                                  50, // Adjust height to fit the icon
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    139, 72, 223, 1),
                                                shape: BoxShape
                                                    .circle, // Circular shape
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255,
                                                      211,
                                                      209,
                                                      209), // Grey border
                                                  width: 3.0,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add, // Plus icon
                                                  color: Colors.white,
                                                  size: 24, // Icon size
                                                ),
                                              ),
                                            ),
                                          ),
                                          // GestureDetector(
                                          //   child: Container(
                                          //     width: 150,
                                          //     decoration: BoxDecoration(
                                          //       color: Color.fromRGBO(139, 72, 223, 1),
                                          //       borderRadius: BorderRadius.circular(30),
                                          //        border: Border.all(
                                          //                 // Add a grey border
                                          //                 color: const Color.fromARGB(
                                          //                     255,
                                          //                     211,
                                          //                     209,
                                          //                     209), // Grey color for the outline
                                          //                 width: 2.0, // Width of the outline
                                          //               ),
                                          //     ),
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.symmetric(
                                          //         vertical: 4.0,
                                          //         horizontal: 5,
                                          //       ),
                                          //       child: Text(
                                          //         textAlign: TextAlign.center,
                                          //         'Add MockRace',
                                          //         style: GoogleFonts.karla(
                                          //           textStyle: TextStyle(
                                          //             color: Colors.white,
                                          //             fontSize: 16,
                                          //             fontWeight: FontWeight.w700,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   onTap: () {
                                          //     Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //         builder: (context) => BlocProvider(
                                          //             create: (context) => AddEventBloc(),
                                          //             child: AddMockRacecreen()),
                                          //       ),
                                          //     );
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //  Align(
                            //             alignment: Alignment.centerRight,
                            //             child: CustomSearchBar(
                            //               width: 100,
                            //               height: 30,
                            //             )),
                            // SizedBox(height: 25),
                            state.MockRace.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 50.0),
                                      child: Text(
                                        'No data available',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children:
                                        state.MockRace.map((event) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 25.0),
                                              child: EventCard(event: event),
                                            )).toList(),
                                  )
                            // ...state.MockRace.map((event) => Padding(
                            //       padding: const EdgeInsets.only(bottom: 25.0),
                            //       child: EventCard(event: event),
                            //     )).toList(),
                          ],
                        )
                      : Container()),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Container(
        //   margin: const EdgeInsets.only(top: 80),
        //   height: 64,
        //   width: 64,
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.white,
        //     elevation: 0,
        //     onPressed: () => Navigator.push(
        //         // context, MaterialPageRoute(builder: (context) => TrackDeviceInfoScreen())),
        //         context,
        //         MaterialPageRoute(builder: (context) => HomeScreen())),
        //     shape: RoundedRectangleBorder(
        //       side: const BorderSide(
        //           width: 1.5, color: Color.fromRGBO(254, 149, 38, 0.7)),
        //       borderRadius: BorderRadius.circular(100),
        //     ),
        //     child: Image.asset('assets/images/Racing.png'),
        //   ),
        // ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
        ),
      );
    });
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) => ParticipantBloc(),
                      child:
                          ParticipantDashboard(eventId: event.id.toString()))));
        },
        child: Column(
          children: [
            Row(
              children: [
                // Container(
                //   height: 70,
                //   width: 80,
                //   decoration: BoxDecoration(
                //     color: Color(0xFFD9D9D9), // Background color set to #D9D9D9
                //     border: Border.all(
                //       width: 1,
                //       color: Color.fromRGBO(197, 192, 192, 1),
                //     ),
                //     borderRadius: BorderRadius.circular(50),
                //   ),
                // ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                event.name,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                PopupMenuButton<String>(
                                  icon: Iconify(
                                    moreHorizondal, // Use the correct Iconify icon
                                    color: Color.fromRGBO(234, 146, 53, 1),
                                    size: 28,
                                  ),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'edit':
                                        // Handle edit action
                                        print('Edit selected');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                                create: (context) =>
                                                    AddEventBloc(),
                                                child: AddEventScreen(
                                                  eventId: event.id,
                                                  fromScreen: "mock",
                                                  edittitle: 'Edit MockRace',
                                                  addtitle: 'Add MockRace',
                                                  updateadd: 'Add MockRace',
                                                  updateedit: 'Update MockRace',
                                                )),
                                          ),
                                        );
                                        break;
                                      case 'delete':
                                        // Handle delete action
                                        print('Delete selected');
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            // Use a new context variable here
                                            return AlertDialog(
                                              title: Text('Confirm Delete'),
                                              content: Text(
                                                  'Are you sure you want to delete this MockRace?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(dialogContext)
                                                        .pop(); // Use dialogContext here to close the dialog
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Confirm'),
                                                  onPressed: () {
                                                    // Use the original context to access the HorseDashboardBloc
                                                    context
                                                        .read<
                                                            MockRaceDashboardBloc>()
                                                        .add(DeleteMockRace(
                                                            eventsId:
                                                                event.id));
                                                    print('Delete selected');
                                                    Navigator.of(dialogContext)
                                                        .pop(); // Use dialogContext here to close the dialog after confirming
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        break;
                                      case 'analysis':
                                        // Handle delete action
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                      create: (context) =>
                                                          horseactivitybloc(),
                                                      child: horseactivity(),
                                                    )));
                                        print('analysis selected');
                                        break;

                                      case 'participant':
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                      create: (context) =>
                                                          ParticipantBloc(),
                                                      child:
                                                          ParticipantDashboard(
                                                        eventId:
                                                            event.id.toString(),
                                                      ),
                                                    )));
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'analysis',
                                        child: Text('Analysis'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'participant',
                                        child: Text('Participant'),
                                      ),
                                    ];
                                  },
                                ),
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor:
                                //         Color(0xFFD8A353), // Background color
                                //     padding: EdgeInsets.symmetric(
                                //         vertical: 10.0, horizontal: 16.0),
                                //     textStyle: GoogleFonts.karla(
                                //       fontSize: 10, // Font size
                                //       fontWeight:
                                //           FontWeight.w400, // Font weight
                                //       height:
                                //           1.17, // Line height (11.69px / 10px)
                                //     ),
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(
                                //           5), // 5px radius
                                //     ),
                                //   ),
                                //   onPressed: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => BlocProvider(
                                //                   create: (context) =>
                                //                       horseactivitybloc(),
                                //                   child: horseactivity(),
                                //                 )));
                                //   },
                                //   child: Text(
                                //     'Analysis',
                                //     style: TextStyle(color: Colors.black),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Text(
                                //   event.startdate,
                                //   // '7yr',
                                //   style: GoogleFonts.karla(
                                //     textStyle: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.w400,
                                //     ),
                                //   ),
                                // ),
                                // Iconify(
                                //   divider,
                                //   color: Color.fromRGBO(158, 18, 144, 1),
                                //   size: 28,
                                // ),
                                // Text(
                                //   event.eventType,
                                //   style: GoogleFonts.karla(
                                //     textStyle: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.w400,
                                //     ),
                                //   ),
                                // ),
                                // Iconify(
                                //   divider,
                                //   color: Color.fromRGBO(158, 18, 144, 1),
                                //   size: 28,
                                // ),
                                // Text(
                                //   // 'Pure Arab',
                                //   event.groupName,
                                //   style: GoogleFonts.karla(
                                //     textStyle: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.w400,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            // Iconify(
                            //   heart,
                            //   color: Color.fromRGBO(158, 18, 144, 1),
                            //   size: 20,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  25,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          width: 4, // Width of each dot
                          height: 4, // Height of each dot
                          decoration: BoxDecoration(
                            color: Colors.grey, // Color of the dots
                            shape: BoxShape.circle, // Shape of the dots
                          ),
                        ),
                      )),
            )
          ],
        ));
  }
}
