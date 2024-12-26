import 'package:EquineApp/feature/bysession/bloc/bysession_bloc.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:EquineApp/feature/header/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../utils/constants/icons.dart';
import '../../subscripition/add_forms/Event/bloc/AddEvent_bloc.dart';
import '../../subscripition/add_forms/Event/view/add_event.dart';
import '../../../data/models/event_model.dart';
import '../../subscripition/manage_dashboard/cards/participant_dashboard/bloc/participant_dashboard_bloc.dart';
import '../../subscripition/manage_dashboard/cards/participant_dashboard/view/participant_dashboard_view.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../home/home_screen.dart';
import '../../horsesActivity/bloc/horseactivity_bloc.dart';
import '../../horsesActivity/horseactivity_view.dart';
import '../../nav_bar/nav_bar.dart';

class Bysession extends StatefulWidget {
  const Bysession({super.key});

  @override
  State<Bysession> createState() => _BysessionState();
}

class _BysessionState extends State<Bysession> {
  int selectedTab = 0;
  String? _selectedTime; // Selected value from dropdown

  @override
  void initState() {
    super.initState();
    // Dispatch event to load sessions initially
    context.read<Bysessionbloc>().add(LoadSessionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Bysessionbloc, Bysessionstate>(
      listener: (BuildContext context, state) {
        if (state is TraningSubmittedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Traning Created Succedfully')),
          );
        } else if (state is TraningSubmittedFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Traning Created Failure')),
          );
        }
      },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: state is BysessionLoading
                ? Padding(
                    padding: EdgeInsets.all(160),
                    child: CircularProgressIndicator())
                : state is BysessionLoaded
                    ? Column(
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        10,
                                        10,
                                        25,
                                        10), // Add some padding inside the blue box
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Training',
                                          style: GoogleFonts.karla(
                                            textStyle: TextStyle(
                                              color: Color(
                                                  0xFF595BD4), // Change text color to white for contrast
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        // PopupMenuButton<String>(
                                        //   color: Color(0xFFE5E5FC),
                                        // icon:
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<Bysessionbloc>()
                                                .add(Traningcreated());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BlocProvider(
                                                            create: (context) =>
                                                                Bysessionbloc(),
                                                            child:
                                                                Bysession())));
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF595BD4),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 211, 209, 209),
                                                width: 3.0,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // onSelected: (String newValue) {
                                        //   setState(() {
                                        //     _selectedTime = newValue;
                                        //   });
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           BlocProvider(
                                        //               create: (context) =>
                                        //                   AddEventBloc(),
                                        //               child: AddEventScreen(
                                        //                   fromScreen:
                                        //                       "training")),
                                        //     ),
                                        //   );
                                        // },
                                        //   itemBuilder: (BuildContext context) {
                                        //     return <String>[
                                        //       'Morning',
                                        //       'Midday',
                                        //       'Evening'
                                        //     ].map((String value) {
                                        //       return PopupMenuItem<String>(
                                        //         value: value,
                                        //         child: Container(
                                        //           color: _selectedTime == value
                                        //               ? Color(0xFFC9B0E0)
                                        //               : Color(
                                        //                   0xFFE5E5FC), // Conditional color

                                        //           child: Padding(
                                        //             padding: const EdgeInsets
                                        //                 .symmetric(
                                        //                 vertical: 10.0,
                                        //                 horizontal: 16.0),
                                        //             child: Text(value),
                                        //           ),
                                        //         ),
                                        //       );
                                        //     }).toList();
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // if (_selectedTime != null)
                          //   Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          //     child: Text(
                          //       'Selected Time: $_selectedTime',
                          //       style: TextStyle(fontSize: 16),
                          //     ),
                          //   ),
                          state.sessions.isEmpty
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
                                  children: state.sessions
                                      .map((Bysession) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 25.0),
                                            child: bysessioncard(
                                                bysessionname: Bysession,
                                                event: Bysession),
                                          ))
                                      .toList(),
                                )
                          // ...state.sessions
                          //     .map(
                          //       (Bysession) => Padding(
                          //         padding: const EdgeInsets.only(bottom: 25.0),
                          //         child: bysessioncard(
                          //           bysessionname: Bysession,
                          //           event: Bysession,
                          //         ),
                          //       ),
                          //     )
                          //     // ...state.sessions
                          //     //     .map((session) => bysessioncard(
                          //     //           bysessionname: session['bysessionname']!,
                          //     //         ))
                          //     .toList(),
                        ],
                      )
                    : Container(),
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
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
      },
    );
  }
}

class bysessioncard extends StatelessWidget {
  final EventModel bysessionname;
  final EventModel event;

  TextEditingController walkcontroller = TextEditingController();
  TextEditingController Trotcontroller = TextEditingController();
  TextEditingController cantercontroller = TextEditingController();

  bysessioncard({
    super.key,
    required this.bysessionname,
    required this.event,
  });
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          backgroundColor: Color(0xFFF6E9E9),
          actions: [
            Column(
              children: [
                Center(
                  child: Container(
                    width: 370,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Color(0xFFF6E9E9), // Set opacity here
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text('Walk (KM)'),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  color: Colors.white,
                                  child: TextFormField(
                                    controller: walkcontroller,
                                    style: TextStyle(fontSize: 10),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text('Trot (KM)'),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  color: Colors.white,
                                  child: TextFormField(
                                    controller: Trotcontroller,
                                    style: TextStyle(fontSize: 10),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text('Canter (KM)'),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  color: Colors.white,
                                  child: TextFormField(
                                    controller: cantercontroller,
                                    style: TextStyle(fontSize: 10),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            height: 24,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: Text('Save',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => ParticipantBloc(),
                child: ParticipantDashboard(
                  eventId: event.id
                      .toString(), // Provide a default value or handle null
                ),
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(children: [
          Row(
            children: [
              Container(
                height: 70,
                width: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9), // Background color set to #D9D9D9
                  border: Border.all(
                    width: 1,
                    color: Color.fromRGBO(197, 192, 192, 1),
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    bysessionname.name,
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    bysessionname.category,
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              )),
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
                          print('Edit selected');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (context) => AddEventBloc(),
                                  child: AddEventScreen(
                                    fromScreen: "training",
                                    eventId: event.id,
                                    edittitle: 'Edit Training',
                                    addtitle: 'Add Training',
                                    updateadd: 'Add Training',
                                    updateedit: 'Update Training',
                                  )),
                            ),
                          );
                          break;
                        case 'delete':
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              // Use a new context variable here
                              return AlertDialog(
                                title: Text('Confirm Delete'),
                                content: Text(
                                    'Are you sure you want to delete this Training?'),
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
                                      context.read<Bysessionbloc>().add(
                                          Deletebysession(eventsId: event.id));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) =>
                                            horseactivitybloc(),
                                        child: horseactivity(),
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
                      ];
                    },
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Color(0xFFD8A353), // Background color
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 10.0, horizontal: 16.0),
                  //     textStyle: GoogleFonts.karla(
                  //       fontSize: 10, // Font size
                  //       fontWeight: FontWeight.w400, // Font weight
                  //       height: 1.17, // Line height (11.69px / 10px)
                  //     ),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(5), // 5px radius
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => BlocProvider(
                  //                   create: (context) => horseactivitybloc(),
                  //                   child: horseactivity(),
                  //                 )));
                  //   },
                  //   child: Text(
                  //     'Analysis',
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                ],
              )
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
          ),
        ]),
      ),
    );
  }
}
