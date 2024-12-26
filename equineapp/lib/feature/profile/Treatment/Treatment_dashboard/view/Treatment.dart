import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:EquineApp/feature/profile/Treatment/Treatment_dashboard/bloc/treatment_bloc.dart';
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
import '../../Treatment_Form/bloc/treatment_form_bloc.dart';
import '../../Treatment_Form/view/Treatment_form_view.dart';

class Treatment extends StatefulWidget {
  final HorseModel horse;
  const Treatment({super.key, required this.horse});

  @override
  State<Treatment> createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<TreatmentBloc>().add(LoadTreatment());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TreatmentBloc, TreatmentState>(
      listener: (context, state) {
        if (state is TreatmentDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Treatment deleted Successfully")),
          );
          context.read<TreatmentBloc>().add(LoadTreatment());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: state is TreatmentLoading
                    ? Center(child: CircularProgressIndicator())
                    : state is TreatmentLoaded
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
                                                'Treatment',
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
                                                                TreatmentFormBloc(),
                                                            child:
                                                                TreatmentForm(
                                                              horse:
                                                                  widget.horse,
                                                              isSave: true,
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
                              state.Treatment.isEmpty
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
                                      children: state.Treatment.map(
                                          (TreatmentData) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 25.0),
                                                child: TreatmentCard(
                                                  Treatment:
                                                      TreatmentData["Treatment"]
                                                              ?.toString() ??
                                                          "",
                                                  Treatment2: TreatmentData[
                                                              "Treatment2"]
                                                          ?.toString() ??
                                                      "",
                                                  Treatment3: TreatmentData[
                                                              "Treatment3"]
                                                          ?.toString() ??
                                                      "",
                                                  Treatment4: TreatmentData[
                                                              "Treatment4"]
                                                          ?.toString() ??
                                                      "",
                                                  TreatmentDate: TreatmentData[
                                                              "TreatmentDate"]
                                                          ?.toString() ??
                                                      "",
                                                  treatmentId: int.tryParse(
                                                          TreatmentData[
                                                                      "treatmentId"]
                                                                  ?.toString() ??
                                                              "") ??
                                                      0,
                                                  horseid: widget.horse,
                                                ),
                                              )).toList(),
                                    )
                              // ...state.Treatment.map(
                              //   (TreatmentData) => Padding(
                              //     padding: const EdgeInsets.only(bottom: 25.0),
                              //     child: TreatmentCard(
                              //       Treatment: TreatmentData["Treatment"]
                              //               ?.toString() ??
                              //           "",
                              //       Treatment2: TreatmentData["Treatment2"]
                              //               ?.toString() ??
                              //           "",
                              //       Treatment3: TreatmentData["Treatment3"]
                              //               ?.toString() ??
                              //           "",
                              //       Treatment4: TreatmentData["Treatment4"]
                              //               ?.toString() ??
                              //           "",
                              //       TreatmentDate:
                              //           TreatmentData["TreatmentDate"]
                              //                   ?.toString() ??
                              //               "",
                              //       treatmentId: int.tryParse(
                              //               TreatmentData["treatmentId"]
                              //                       ?.toString() ??
                              //                   "") ??
                              //           0,
                              //       horseid: widget.horse,
                              //     ),
                              //   ),
                              // ).toList(),
                            ],
                          )
                        : Container()),
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

class TreatmentCard extends StatelessWidget {
  final String Treatment;
  final String Treatment2;
  final String Treatment3;
  final String Treatment4;
  final String TreatmentDate;
  final int treatmentId; // Add this field to accept nutritionId
  final HorseModel horseid;

  const TreatmentCard({
    super.key,
    required this.Treatment,
    required this.Treatment2,
    required this.Treatment3,
    required this.Treatment4,
    required this.TreatmentDate,
    required this.treatmentId,
    required this.horseid,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => TreatmentFormBloc(),
              child: TreatmentForm(
                treatmentId: treatmentId,
                horse: horseid!,
                isSave: false,
              ),
            ),
          ),
        );
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
                          horizontal: 12.0, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Treatment2,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFFE0323F),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                Treatment3,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                Treatment4,
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
                          Column(
                            children: [
                              Text(
                                "Treatment  Date",
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(TreatmentDate),
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
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  TreatmentFormBloc(),
                                              child: TreatmentForm(
                                                treatmentId: treatmentId,
                                                horse: horseid!,
                                                isSave: true,
                                              ),
                                            ),
                                          ),
                                        );
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
                                                      .read<TreatmentBloc>()
                                                      .add(DeleteTreatment(
                                                          treatmentId:
                                                              treatmentId));
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
                              //                         .read<TreatmentBloc>()
                              //                         .add(DeleteTreatment(
                              //                             treatmentId:
                              //                                 treatmentId));
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
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => BlocProvider(
                              //           create: (context) =>
                              //               TreatmentFormBloc(),
                              //           child: TreatmentForm(
                              //             treatmentId: treatmentId,
                              //             horse: horseid!,
                              //             isSave: false,
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   child: Text(
                              //     'Show Notes',
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
