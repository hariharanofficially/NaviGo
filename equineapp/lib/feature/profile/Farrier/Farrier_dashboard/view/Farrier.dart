import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:EquineApp/feature/profile/Farrier/Farrier_dashboard/bloc/farrier_bloc.dart';
import 'package:EquineApp/feature/profile/Treatment/Treatment_dashboard/view/Treatment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../Farrier_Form/bloc/farrier_form_bloc.dart';
import '../../Farrier_Form/view/farrier_form_view.dart';

class Farrier extends StatefulWidget {
  final HorseModel horse;
  const Farrier({super.key, required this.horse});

  @override
  State<Farrier> createState() => _FarrierState();
}

class _FarrierState extends State<Farrier> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<FarrierBloc>().add(LoadFarrier());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FarrierBloc, FarrierState>(
      listener: (context, state) {
        if (state is FarrierDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Farrier deleted Successfully")),
          );
          context.read<FarrierBloc>().add(LoadFarrier());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: state is FarrierLoading
                  ? Center(child: CircularProgressIndicator())
                  : state is FarrierLoaded
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
                                          Expanded(
                                            child: Text(
                                              'Farrier',
                                              style: GoogleFonts.karla(
                                                textStyle: TextStyle(
                                                  color: Color(0xFF595BD4),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
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
                                                              FarrierFormBloc(),
                                                          child: FarrierForm(
                                                            horse: widget.horse,
                                                            isSave: true,
                                                            isSurfaceType: true,
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
                            state.Farrier.isEmpty
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
                                    children: state.Farrier.map(
                                        (TreatmentData) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 25.0),
                                              child: FarrierCard(
                                                farrier:
                                                    TreatmentData["Farrier"]
                                                            ?.toString() ??
                                                        "",
                                                farrier2:
                                                    TreatmentData["Farrier2"]
                                                            ?.toString() ??
                                                        "",
                                                farrier3:
                                                    TreatmentData["Farrier3"]
                                                            ?.toString() ??
                                                        "",
                                                farrier4:
                                                    TreatmentData["Farrier4"]
                                                            ?.toString() ??
                                                        "",
                                                farrier5:
                                                    TreatmentData["Farrier5"]
                                                            ?.toString() ??
                                                        "",
                                                farrier6:
                                                    TreatmentData["Farrier6"]
                                                            ?.toString() ??
                                                        "",
                                                farrier7:
                                                    TreatmentData["Farrier7"]
                                                            ?.toString() ??
                                                        "",
                                                farrier8:
                                                    TreatmentData["Farrier8"]
                                                            ?.toString() ??
                                                        "",
                                                farrier9:
                                                    TreatmentData["Farrier9"]
                                                            ?.toString() ??
                                                        "",
                                                farrier10:
                                                    TreatmentData["Farrier10"]
                                                            ?.toString() ??
                                                        "",
                                                farrier11:
                                                    TreatmentData["Farrier11"]
                                                            ?.toString() ??
                                                        "",
                                                farrier12:
                                                    TreatmentData["Farrier12"]
                                                            ?.toString() ??
                                                        "",
                                                farrierdate:
                                                    TreatmentData["farrierdate"]
                                                            ?.toString() ??
                                                        "",
                                                horseid: widget.horse,
                                                farrierId: int.tryParse(
                                                        TreatmentData[
                                                                    "farrierId"]
                                                                ?.toString() ??
                                                            "") ??
                                                    0,
                                              ),
                                            )).toList(),
                                  )
                            // ...state.Farrier.map(
                            //   (TreatmentData) => Padding(
                            //     padding: const EdgeInsets.only(bottom: 25.0),
                            //     child: FarrierCard(
                            //       farrier:
                            //           TreatmentData["Farrier"]?.toString() ??
                            //               "",
                            //       farrier2:
                            //           TreatmentData["Farrier2"]?.toString() ??
                            //               "",
                            //       farrier3:
                            //           TreatmentData["Farrier3"]?.toString() ??
                            //               "",
                            //       farrier4:
                            //           TreatmentData["Farrier4"]?.toString() ??
                            //               "",
                            //       farrier5:
                            //           TreatmentData["Farrier5"]?.toString() ??
                            //               "",
                            //       farrier6:
                            //           TreatmentData["Farrier6"]?.toString() ??
                            //               "",
                            //       farrier7:
                            //           TreatmentData["Farrier7"]?.toString() ??
                            //               "",
                            //       farrier8:
                            //           TreatmentData["Farrier8"]?.toString() ??
                            //               "",
                            //       farrier9:
                            //           TreatmentData["Farrier9"]?.toString() ??
                            //               "",
                            //       farrier10:
                            //           TreatmentData["Farrier10"]?.toString() ??
                            //               "",
                            //       farrier11:
                            //           TreatmentData["Farrier11"]?.toString() ??
                            //               "",
                            //       farrier12:
                            //           TreatmentData["Farrier12"]?.toString() ??
                            //               "",
                            //       farrierdate: TreatmentData["farrierdate"]
                            //               ?.toString() ??
                            //           "",
                            //       horseid: widget.horse,
                            //       farrierId: int.tryParse(
                            //               TreatmentData["farrierId"]
                            //                       ?.toString() ??
                            //                   "") ??
                            //           0,
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

class FarrierCard extends StatelessWidget {
  final String farrier;
  final String farrier2;
  final String farrier3;
  final String farrier4;
  final String farrier5;
  final String farrier6;
  final String farrier7;
  final String farrier8;
  final String farrier9;
  final String farrier10;
  final String farrier11;
  final String farrier12;
  final String farrierdate;
  final HorseModel horseid;
  final int farrierId; // Add this field to accept nutritionId

  const FarrierCard({
    super.key,
    required this.farrier,
    required this.farrier2,
    required this.farrier3,
    required this.farrier4,
    required this.farrier5,
    required this.farrier6,
    required this.farrier7,
    required this.farrier8,
    required this.farrier9,
    required this.farrier10,
    required this.farrier11,
    required this.farrier12,
    required this.farrierdate,
    required this.horseid,
    required this.farrierId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => FarrierFormBloc(),
                      child: FarrierForm(
                        horse: horseid,
                        farrierId: farrierId,
                        isSave: false,
                        isSurfaceType: false,
                      ),
                    )));
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        farrier,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFF8B48DF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier2,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFF8B48DF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier3,
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
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        farrier7,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFFE0323F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier8,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFFE0323F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier9,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFFE0323F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        180, // Make the divider span the full width
                                    height: 1, // Thickness of the line
                                    color: Colors.black, // Line color
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        farrier4,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFF8B48DF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier5,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFF8B48DF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier6,
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
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        farrier10,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFFE0323F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier11,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFFE0323F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        farrier12,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Color(0xFFE0323F),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                "Recorded Date",
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(farrierdate),

                              Row(
                                children: [
                                  IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      iconSize: 30.0,
                                      tooltip: 'Edit',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                      create: (context) =>
                                                          FarrierFormBloc(),
                                                      child: FarrierForm(
                                                        horse: horseid,
                                                        farrierId: farrierId,
                                                        isSave: true,
                                                        isSurfaceType: true,
                                                      ),
                                                    )));
                                      }),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // Add your delete action here
                                      print('Delete button pressed');
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
                                                  context
                                                      .read<FarrierBloc>()
                                                      .add(DeleteFarrier(
                                                          farrierId:
                                                              farrierId));
                                                  print('Delete selected');
                                                  Navigator.of(dialogContext)
                                                      .pop(); // Use dialogContext here to close the dialog after confirming
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    color: Colors.red, // Set color if needed
                                    iconSize: 30.0, // Set size if needed
                                  ),
                                ],
                              ),
                              // PopupMenuButton<String>(
                              //   icon: Iconify(
                              //     moreHorizondal, // Use the correct Iconify icon
                              //     color: Color.fromRGBO(234, 146, 53, 1),
                              //     size: 28,
                              //   ),
                              //   onSelected: (value) {
                              //     switch (value) {
                              //       case 'edit':
                              //         print('Edit selected');
                              //         break;
                              //       case 'delete':
                              //         // Show confirmation dialog before deleting
                              //         // Show confirmation dialog before deleting
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
                              //                     context
                              //                         .read<FarrierBloc>()
                              //                         .add(DeleteFarrier(
                              //                             farrierId:
                              //                                 farrierId));
                              //                     print('Delete selected');
                              //                     Navigator.of(dialogContext)
                              //                         .pop(); // Use dialogContext here to close the dialog after confirming
                              //                   },
                              //                 ),
                              //               ],
                              //             );
                              //           },
                              //         );
                              //         break;
                              //     }
                              //   },
                              //   itemBuilder: (BuildContext context) {
                              //     return [
                              //       PopupMenuItem<String>(
                              //         value: 'edit',
                              //         child: Text('Edit'),
                              //       ),
                              //       PopupMenuItem<String>(
                              //         value: 'delete',
                              //         child: Text('Delete'),
                              //       ),
                              //     ];
                              //   },
                              // ),
                              // ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor:
                              //         Color(0xFFFEB567), // Background color
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 10.0, horizontal: 16.0),
                              //     textStyle: GoogleFonts.karla(
                              //       fontSize: 10, // Font size
                              //       fontWeight: FontWeight.w400, // Font weight
                              //       height:
                              //           1.17, // Line height (11.69px / 10px)
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius:
                              //           BorderRadius.circular(20), // 5px radius
                              //     ),
                              //   ),
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => BlocProvider(
                              //                   create: (context) =>
                              //                       FarrierFormBloc(),
                              //                   child: FarrierForm(
                              //                     horse: horseid,
                              //                     farrierId: farrierId,
                              //                     isSave: false,
                              //                     isSurfaceType: false,
                              //                   ),
                              //                 )));
                              //   },
                              //   child: Text(
                              //     'View',
                              //     style: TextStyle(color: Colors.white),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
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
        ],
      ),
    );
  }
}
