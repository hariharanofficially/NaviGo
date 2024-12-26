import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:EquineApp/feature/profile/Blood_test/Blood_dashboard/view/Blood_Test.dart';
import 'package:EquineApp/feature/profile/Farrier/Farrier_dashboard/bloc/farrier_bloc.dart';
import 'package:EquineApp/feature/profile/Farrier/Farrier_dashboard/view/Farrier.dart';
import 'package:EquineApp/feature/profile/Nutrition/Nutrition_dashboard/bloc/nutrition_bloc.dart';
import 'package:EquineApp/feature/profile/Nutrition/Nutrition_dashboard/view/Nutrition.dart';
import 'package:EquineApp/feature/profile/Treatment/Treatment_dashboard/bloc/treatment_bloc.dart';
import 'package:EquineApp/feature/profile/Treatment/Treatment_dashboard/view/Treatment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/horse_model.dart';
import '../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../common/widgets/navigation_widget.dart';
import '../../../header/app_bar.dart';
import '../../../nav_bar/nav_bar.dart';
import '../../../subscripition/manage_dashboard/cards/horse_dashboard/bloc/horse_dashboard_bloc.dart';
import '../../../subscripition/manage_dashboard/cards/horse_dashboard/view/horse_dashboard_view.dart';
import '../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../Blood_test/Blood_dashboard/bloc/blood_bloc.dart';
import '../../Body_measurement/Body_dashboard/bloc/body_bloc.dart';
import '../../Body_measurement/Body_dashboard/view/Body_Measurement.dart';
import '../../Training/Training_dashboard/bloc/training_bloc.dart';
import '../../Training/Training_dashboard/view/Training_dashboard_view.dart';
import '../../planning&preparation/plan_dashboard/bloc/plan_bloc.dart';
import '../../planning&preparation/plan_dashboard/view/plan_view.dart';
import '../bloc/Profiling_bloc.dart';
import '../bloc/Profiling_state.dart';

class Profiling extends StatefulWidget {
  final HorseModel horse;
  Profiling({super.key, required this.horse});

  @override
  State<Profiling> createState() => _ProfilingState();
}

class _ProfilingState extends State<Profiling> {
  int selectedTab = 0;
  bool _isTyping = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // context.read<byhorsesbloc>().add(LoadByHorses());
    // Detect when user starts typing
    _searchController.addListener(() {
      setState(() {
        _isTyping = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilingBloc, ProfilingState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(
                                  0xFFE5E5FC), // Set the background color to blue
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 10, 25, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.redAccent), // Back icon
                                  onPressed: () {
                                    Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                                  create: (context) =>
                                                      HorseDashboardBloc(),
                                                  child: HorseDashboard(
                                                    title: 'Horses Lists',
                                                    isProfile: true,
                                                    showActions: false,
                                                  ),
                                                )));
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'Profiling',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        color: Color(0xFF595BD4),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // New Row with Search Box and Search Button
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: 20.0), // Spacing between rows
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Browse',
                  //         style: GoogleFonts.karla(
                  //           textStyle: TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //         ),
                  //       ),
                  //       // Search TextField
                  //       Expanded(
                  //         child: Padding(
                  //           padding:
                  //               const EdgeInsets.symmetric(horizontal: 8.0),
                  //           child: TextField(
                  //             controller: _searchController,
                  //             decoration: InputDecoration(
                  //               // hintText: 'Enter search term...',
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(20.0),
                  //                 borderSide: BorderSide(color: Colors.grey),
                  //               ),
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(20.0),
                  //                 borderSide: BorderSide(
                  //                     color: Colors
                  //                         .grey), // Border color when enabled
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(20.0),
                  //                 borderSide: BorderSide(
                  //                     color: Colors
                  //                         .grey), // Border color when focused
                  //               ),
                  //               contentPadding: EdgeInsets.fromLTRB(15.0, 10.0,
                  //                   10.0, 10.0), // Move the text to the right
                  //               filled: true,
                  //               fillColor: Colors.white,
                  //               suffixIcon: OutlinedButton(
                  //                 onPressed: () {
                  //                   // Implement search functionality here
                  //                   print("Search button clicked!");
                  //                 },
                  //                 style: OutlinedButton.styleFrom(
                  //                   side: BorderSide(
                  //                       color: Colors.grey), // Outline color
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(
                  //                         20.0), // Rounded edges
                  //                   ),
                  //                   minimumSize:
                  //                       Size(40, 40), // Adjust the button size
                  //                   padding: EdgeInsets
                  //                       .zero, // Remove default padding
                  //                 ),
                  //                 child: Icon(
                  //                   Icons.search,
                  //                   color: Color(
                  //                       0xFFD8A353), // Background color/ Icon color
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Health Categories',
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container with Cards
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey, // Set your border color here
                          width: 1.0, // Adjust the border width as needed
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(children: [
                        CardItem(
                          title: 'Body Measurement',
                          icon: "assets/images/Weight.png",
                          onTap: () {
                            print('object');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => BodyBloc(),
                                  child: Body_Measurement(
                                      horse: widget.horse), // Pass the horse id
                                ),
                              ),
                            );
                          }, // Example icon
                        ),
                        CardItem(
                          title: 'Training Details',
                          icon: "assets/images/Training.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => TraningBloc(),
                                  child: TraningDashboard(
                                      horse: widget.horse), // Pass the horse id
                                ),
                              ),
                            );
                          }, // Example icon
                        ),
                        CardItem(
                          title: 'Blood Test',
                          icon: "assets/images/BloodTest.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => BloodBloc(),
                                  child: BloodTest(
                                      horse: widget.horse), // Pass the horse id
                                ),
                              ),
                            );
                          }, // Example icon
                        ),
                        CardItem(
                          title: 'Treatment',
                          icon: "assets/images/Treatment.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => TreatmentBloc(),
                                  child: Treatment(
                                      horse: widget.horse), // Pass the horse id
                                ),
                              ),
                            );
                          }, // Example icon
                        ),
                        CardItem(
                          title: 'Nutrition',
                          icon: "assets/images/Nutrition.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => NutritionBloc(),
                                        child: Nutrition(
                                          horseid: widget.horse,
                                        ),
                                      )),
                            );
                          }, // Example icon
                        ),
                        CardItem(
                          title: 'Farrier',
                          icon: "assets/images/Farrier.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => FarrierBloc(),
                                        child: Farrier(
                                          horse: widget.horse,
                                        ),
                                      )),
                            );
                          }, // Example icon
                        ),
                        CardItem(
                          title: 'Planning & Preparation',
                          icon: "assets/images/Planning.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => PlanBloc(),
                                        child: PlanDashboard(
                                          horse: widget.horse,
                                        ),
                                      )),
                            );
                          }, // Example icon
                        ),
                        CardItem(
                          title: 'Analysis & Report',
                          icon: "assets/images/Analysis.png",
                          onTap: () {}, // Example icon
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: _isTyping
          //     ? Container(
          //         margin: const EdgeInsets.only(top: 80),
          //         height: 64,
          //         width: 64,
          //         child: FloatingActionButton(
          //           backgroundColor: Colors.white,
          //           elevation: 0,
          //           onPressed: () => Navigator.push(
          //               // context, MaterialPageRoute(builder: (context) => TrackDeviceInfoScreen())),
          //               context,
          //               MaterialPageRoute(builder: (context) => HomeScreen())),
          //           shape: RoundedRectangleBorder(
          //             side: const BorderSide(
          //                 width: 1.5, color: Color.fromRGBO(254, 149, 38, 0.7)),
          //             borderRadius: BorderRadius.circular(100),
          //           ),
          //           child: Image.asset('assets/images/Racing.png'),
          //         ),
          //       )
          // : null,
          bottomNavigationBar: NavBar(
            pageIndex: selectedTab,
          ),
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String icon; // Add an icon parameter
  final VoidCallback onTap; // Add an onTap parameter

  const CardItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap, // Default to a generic icon if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Call the onTap callback when tapped

      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        leading: Image.asset(
          icon, // Use the custom icon
          width: 24, // Adjust size as needed
          height: 24,
        ), // Display the icon
        title: Text(title),
        trailing: Icon(
          Icons.arrow_right_outlined,
          color: Colors.grey,
        ),
      ),
    );
  }
}
