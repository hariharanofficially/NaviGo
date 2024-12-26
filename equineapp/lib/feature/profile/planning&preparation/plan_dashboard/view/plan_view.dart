import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../../data/models/horse_model.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../plan_form/bloc/plan_form_bloc.dart';
import '../../plan_form/view/plan_form_view.dart';
import '../../plan_graph/bloc/plangraph_bloc.dart';
import '../../plan_graph/view/plangraph_view.dart';
import '../bloc/plan_bloc.dart';

class PlanDashboard extends StatefulWidget {
  final HorseModel horse;
  const PlanDashboard({super.key, required this.horse});

  @override
  State<PlanDashboard> createState() => _PlanDashboardState();
}

class _PlanDashboardState extends State<PlanDashboard> {
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    context
        .read<PlanBloc>()
        .add(LoadPlanning(horseId: widget.horse.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanBloc, PlanState>(
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
                  child: state is PlanLoading
                      ? Center(child: CircularProgressIndicator())
                      : state is PlanLoaded
                          ? Column(
                              children: [
                                Row(
                                  children: [
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
                                              IconButton(
                                                icon: Icon(Icons.arrow_back,
                                                    color: Colors
                                                        .redAccent), // Back icon
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Action when back icon is pressed
                                                },
                                              ),
                                              Text(
                                                'Planning & Preparation',
                                                style: GoogleFonts.karla(
                                                  textStyle: TextStyle(
                                                    color: Color(0xFF595BD4),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BlocProvider(
                                                              create: (context) =>
                                                                  PlanFormBloc(),
                                                              child: PlanForn(
                                                                horse: widget
                                                                    .horse,
                                                              ),
                                                            )),
                                                  );
                                                },
                                                child: Container(
                                                  width:
                                                      30, // Adjust width to fit the icon
                                                  height:
                                                      50, // Adjust height to fit the icon
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF595BD4),
                                                    shape: BoxShape
                                                        .circle, // Circular shape
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      28,
                                      (index) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Container(
                                              width: 3, // Width of each dot
                                              height: 2, // Height of each dot
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .grey, // Color of the dots
                                                shape: BoxShape
                                                    .rectangle, // Shape of the dots
                                              ),
                                            ),
                                          )),
                                ),

                                // ...state.planning
                                //     .map(
                                //       (plan) => Padding(
                                //         padding:
                                //             const EdgeInsets.only(bottom: 8.0),
                                //         child: Planningcard(
                                //           planning: plan['planning'] ??
                                //               'Default Title', // Replace with your actual key
                                //           percentage: plan['percentage'] != null
                                //               ? double.parse(plan['percentage']
                                //                   .toString()) // Safely convert to double
                                //               : 0.0,
                                //           cardColor: plan['color'] ??
                                //               Colors
                                //                   .grey, // Use default color if missing
                                //         ),
                                //       ),
                                //     )
                                //     .toList(),
                                state.planning.isEmpty
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
                                        children: state.planning.map(
                                          (plan) {
                                            // Check if the planning type is 'farrier'
                                            bool isFarrier =
                                                plan['planning'] == 'Farrier';
                                            bool isdates =
                                                plan['planning'] == 'Summary';
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Column(
                                                children: [
                                                  Planningcard(
                                                    planning:
                                                        plan['planning'] ??
                                                            'Default Title',
                                                    percentage: plan[
                                                                'percentage'] !=
                                                            null
                                                        ? double.parse(
                                                            plan['percentage']
                                                                .toString())
                                                        : 0.0,
                                                    cardColor: plan['color'] ??
                                                        Colors.grey,
                                                    horse: widget.horse,
                                                    isdates: isdates,
                                                    startdate: plan[
                                                                'startDate'] !=
                                                            null
                                                        ? plan['startDate']
                                                            .toString()
                                                        : '0', // Provide a default string value
                                                    enddate: plan['endDate'] !=
                                                            null
                                                        ? plan['endDate']
                                                            .toString()
                                                        : '0', // Provide a default string value
                                                  ),

                                                  // Show the dot row only if 'farrier' is in planning
                                                  if (isFarrier)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: List.generate(
                                                          28,
                                                          (index) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        4.0),
                                                            child: Container(
                                                              width: 3,
                                                              height: 2,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                shape: BoxShape
                                                                    .rectangle,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                              ],
                            )
                          : Container())),
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

class Planningcard extends StatelessWidget {
  final String planning;
  final double percentage;
  final Color cardColor; // Add a color property for the card background
  final HorseModel horse;
  final bool isdates;
  final String startdate;
  final String enddate;
  const Planningcard({
    super.key,
    required this.planning,
    required this.percentage,
    required this.cardColor,
    required this.horse,
    required this.isdates,
    required this.startdate,
    required this.enddate,
  });

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => PlangraphBloc(),
        child: Plangraph(
          horse: horse,
        ),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation, // Fades in based on the animation value
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isdates)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Summary",
                  style: GoogleFonts.karla(
                      textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ))),
              RichText(
                text: TextSpan(
                  text: startdate,
                  style: GoogleFonts.karla(
                    textStyle: TextStyle(
                      color: Colors.black, // Give this part a different color
                      fontSize: 14,
                      // fontWeight: FontWeight.w400,
                    ),
                  ),
                  children: [
                    TextSpan(
                      text: ' - ', // Second part
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          color: Colors.black, // Default color for this part
                          fontSize: 14,
                          // fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: enddate,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          color: Colors.black, // Default color for this part
                          fontSize: 14,
                          // fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text('30 days'),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Add your delete action here
                  print('Delete button pressed');
                },
                color: Colors.red, // Set color if needed
                iconSize: 30.0, // Set size if needed
              ),
            ],
          ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(_createRoute());
          },
          child: Card(
            elevation: 4, // Adds shadow to the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            color: cardColor, // Apply background color
            child: Padding(
              padding:
                  const EdgeInsets.all(10.0), // Adds padding inside the card
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Aligns text to the left
                children: [
                  Text(
                    planning, // Title text
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%', // Right text (percentage)
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // You can use any color here
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
