import 'package:EquineApp/data/models/body_model.dart';
import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Horse/horse_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../Body_Form/view/Body_form_view.dart';
import '../bloc/body_bloc.dart';
import '../../Body_Form/bloc/body_form_bloc.dart';

class Body_Measurement extends StatefulWidget {
  final HorseModel horse;
  Body_Measurement({super.key, required this.horse});

  @override
  State<Body_Measurement> createState() => _Body_MeasurementState();
}

class _Body_MeasurementState extends State<Body_Measurement> {
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    context.read<BodyBloc>().add(LoadBody());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BodyBloc, BodyState>(
      listener: (context, state) {
        if (state is BodyDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Body Measurement deleted Successfully")),
          );
          context.read<BodyBloc>().add(LoadBody());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: state is BodyLoading
                  ? Center(child: CircularProgressIndicator())
                  : state is BodyLoaded
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
                                          10, 10, 10, 10),
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
                                            'Body Measurement',
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
                                                              BodyFormBloc(),
                                                          child: BodyForm(
                                                              horse:
                                                                  widget.horse),
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
                                                // border: Border.all(
                                                //   color: const Color.fromARGB(
                                                //       255,
                                                //       211,
                                                //       209,
                                                //       209), // Grey border
                                                //   width: 3.0,
                                                // ),
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
                            state.Body.isEmpty
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
                                    children: state.Body.map((body) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 25.0),
                                          child: BodyCard(
                                            body: body,
                                            horse: widget.horse,
                                          ),
                                        )).toList(),
                                  )
                            // ...state.Body.map(
                            //   (horse) => Padding(
                            //     padding: const EdgeInsets.only(bottom: 25.0),
                            //     child: BodyCard(
                            //       horse: horse,
                            //     ),
                            //   ),
                            // ).toList(),
                          ],
                        )
                      : Container(),
            ),
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

class BodyCard extends StatelessWidget {
  final HorseModel horse;
  final BodyModel body;
  const BodyCard({
    super.key,
    required this.body,
    required this.horse,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Row(
            children: [
              // SizedBox(width: 15),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Weight",
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: body.weight, // The weight value
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                          color: Color(
                                              0xFF00418F), // Color for the weight
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' kg', // The "kg" part
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                          color: Color(0xFF8B48DF),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Expanded(
                          //   child: Text(
                          //     "Weight",
                          //     style: GoogleFonts.karla(
                          //       textStyle: TextStyle(
                          //         color: Color(0xFF8B48DF),
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Expanded(
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: [
                          //         TextSpan(
                          //           text: horse.weight, // The weight value
                          //           style: GoogleFonts.karla(
                          //             textStyle: TextStyle(
                          //               color: Color(
                          //                   0xFF00418F), // Color for the weight
                          //               fontSize: 15,
                          //               fontWeight: FontWeight.w400,
                          //             ),
                          //           ),
                          //         ),
                          //         TextSpan(
                          //           text: ' kg', // The "kg" part
                          //           style: GoogleFonts.karla(
                          //             textStyle: TextStyle(
                          //               color: Color(0xFF8B48DF),
                          //               fontSize: 15,
                          //               fontWeight: FontWeight.w400,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Column(
                            children: [
                              Text(
                                "Recorded Date",
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                '${body.getFormattedDate()}',
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              iconSize: 30.0,
                              tooltip: 'Edit',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (context) => BodyFormBloc(),
                                            child: BodyForm(
                                              horse: horse,
                                              bodyformId: body.id,
                                            ),
                                          )),
                                );
                              }),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Add your delete action here
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  // Use a new context variable here
                                  return AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text(
                                        'Are you sure you want to delete this horse?'),
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
                                          context.read<BodyBloc>().add(
                                              DeleteBody(bodyId: horse.id));
                                          print('Delete selected');
                                          Navigator.of(dialogContext)
                                              .pop(); // Use dialogContext here to close the dialog after confirming
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              print('Delete button pressed');
                            },
                            color: Colors.red, // Set color if needed
                            iconSize: 30.0, // Set size if needed
                          ),
                          // Expanded(
                          //   child: Text(
                          //     '${horse.getFormattedDate()}',
                          //     style: GoogleFonts.karla(
                          //       textStyle: TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Column(
                          //   children: [
                          //     Text(
                          //       '${horse.getFormattedDate()}',
                          //       style: GoogleFonts.karla(
                          //         textStyle: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     ),
                          //     IconButton(
                          //       icon: Icon(Icons.delete),
                          //       onPressed: () {
                          //         // Add your delete action here
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext dialogContext) {
                          //             // Use a new context variable here
                          //             return AlertDialog(
                          //               title: Text('Confirm Delete'),
                          //               content: Text(
                          //                   'Are you sure you want to delete this horse?'),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   child: Text('Cancel'),
                          //                   onPressed: () {
                          //                     Navigator.of(dialogContext)
                          //                         .pop(); // Use dialogContext here to close the dialog
                          //                   },
                          //                 ),
                          //                 TextButton(
                          //                   child: Text('Confirm'),
                          //                   onPressed: () {
                          //                     context.read<BodyBloc>().add(
                          //                         DeleteBody(bodyId: horse.id));
                          //                     print('Delete selected');
                          //                     Navigator.of(dialogContext)
                          //                         .pop(); // Use dialogContext here to close the dialog after confirming
                          //                   },
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //         print('Delete button pressed');
                          //       },
                          //       color: Colors.red, // Set color if needed
                          //       iconSize: 30.0, // Set size if needed
                          //     ),
                          //     // PopupMenuButton<String>(
                          //     //   icon: Iconify(
                          //     //     moreHorizondal, // Use the correct Iconify icon
                          //     //     color: Color.fromRGBO(234, 146, 53, 1),
                          //     //     size: 28,
                          //     //   ),
                          //     //   onSelected: (value) {
                          //     //     switch (value) {
                          //     //       case 'edit':
                          //     //         print('Edit selected');
                          //     //         break;
                          //     //       case 'delete':
                          //     //         // Show confirmation dialog before deleting
                          //     //         // Show confirmation dialog before deleting
                          //     //         showDialog(
                          //     //           context: context,
                          //     //           builder: (BuildContext dialogContext) {
                          //     //             // Use a new context variable here
                          //     //             return AlertDialog(
                          //     //               title: Text('Confirm Delete'),
                          //     //               content: Text(
                          //     //                   'Are you sure you want to delete this horse?'),
                          //     //               actions: <Widget>[
                          //     //                 TextButton(
                          //     //                   child: Text('Cancel'),
                          //     //                   onPressed: () {
                          //     //                     Navigator.of(dialogContext)
                          //     //                         .pop(); // Use dialogContext here to close the dialog
                          //     //                   },
                          //     //                 ),
                          //     //                 TextButton(
                          //     //                   child: Text('Confirm'),
                          //     //                   onPressed: () {
                          //     //                     context.read<BodyBloc>().add(
                          //     //                         DeleteBody(
                          //     //                             bodyId: horse.id));
                          //     //                     print('Delete selected');
                          //     //                     Navigator.of(dialogContext)
                          //     //                         .pop(); // Use dialogContext here to close the dialog after confirming
                          //     //                   },
                          //     //                 ),
                          //     //               ],
                          //     //             );
                          //     //           },
                          //     //         );
                          //     //         break;
                          //     //     }
                          //     //   },
                          //     //   itemBuilder: (BuildContext context) {
                          //     //     return [
                          //     //       PopupMenuItem<String>(
                          //     //         value: 'edit',
                          //     //         child: Text('Edit'),
                          //     //       ),
                          //     //       PopupMenuItem<String>(
                          //     //         value: 'delete',
                          //     //         child: Text('Delete'),
                          //     //       ),
                          //     //     ];
                          //     //   },
                          //     // ),
                          //     // ElevatedButton(
                          //     //   style: ElevatedButton.styleFrom(
                          //     //     backgroundColor:
                          //     //         Color(0xFFD8A353), // Background color
                          //     //     padding: EdgeInsets.symmetric(
                          //     //         vertical: 10.0, horizontal: 16.0),
                          //     //     textStyle: GoogleFonts.karla(
                          //     //       fontSize: 10, // Font size
                          //     //       fontWeight: FontWeight.w400, // Font weight
                          //     //       height:
                          //     //           1.17, // Line height (11.69px / 10px)
                          //     //     ),
                          //     //     shape: RoundedRectangleBorder(
                          //     //       borderRadius:
                          //     //           BorderRadius.circular(5), // 5px radius
                          //     //     ),
                          //     //   ),
                          //     //   onPressed: () {},
                          //     //   child: Text(
                          //     //     'Analysis',
                          //     //     style: TextStyle(color: Colors.black),
                          //     //   ),
                          //     // ),
                          //   ],
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
      ),
    );
  }
}
