import 'package:EquineApp/feature/profile/Treatment/Treatment_dashboard/view/Treatment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../../data/models/horse_model.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../bloc/training_bloc.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../common/widgets/dropdown_type.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../Training_form/bloc/training_form_bloc.dart';
import '../../Training_form/view/training_form_view.dart';

class TraningDashboard extends StatefulWidget {
  final HorseModel horse;
  TraningDashboard({super.key, required this.horse});

  @override
  State<TraningDashboard> createState() => _TraningDashboardState();
}

class _TraningDashboardState extends State<TraningDashboard> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<TraningBloc>().add(LoadTraning());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TraningBloc, TraningState>(
      listener: (context, state) {
        if (state is TrainingDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Training deleted Successfully")),
          );
          context.read<TraningBloc>().add(LoadTraning());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: state is TraningLoading
                  ? Center(child: CircularProgressIndicator())
                  : state is TraningLoaded
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
                                              'Training',
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
                                                              TraningFormBloc(),
                                                          child: TraningForm(
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
                            state.Traning.isEmpty
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
                                    children: state.Traning.map(
                                        (TreatmentData) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 25.0),
                                              child: TraningCard(
                                                Traning:
                                                    TreatmentData["Traning"]
                                                            ?.toString() ??
                                                        "",
                                                Traning2:
                                                    TreatmentData["Traning2"]
                                                            ?.toString() ??
                                                        "",
                                                Traning3:
                                                    TreatmentData["Traning3"]
                                                            ?.toString() ??
                                                        "",
                                                Traning4:
                                                    TreatmentData["Traning4"]
                                                            ?.toString() ??
                                                        "",
                                                Traning5:
                                                    TreatmentData["Traning5"]
                                                            ?.toString() ??
                                                        "",
                                                Traning6:
                                                    TreatmentData["Traning6"]
                                                            ?.toString() ??
                                                        "",
                                                Traning7:
                                                    TreatmentData["Traning7"]
                                                            ?.toString() ??
                                                        "",
                                                datetime:
                                                    TreatmentData["datetime"]
                                                            ?.toString() ??
                                                        "",
                                                trainingId: int.tryParse(
                                                        TreatmentData[
                                                                    "treatmentId"]
                                                                ?.toString() ??
                                                            "") ??
                                                    0,
                                                horse: widget.horse,
                                              ),
                                            )).toList(),
                                  )

                            // ...state.Traning.map(
                            //   (TreatmentData) => Padding(
                            //     padding: const EdgeInsets.only(bottom: 25.0),
                            //     child: TraningCard(
                            //       Traning:
                            //           TreatmentData["Traning"]?.toString() ??
                            //               "",
                            //       Traning2:
                            //           TreatmentData["Traning2"]?.toString() ??
                            //               "",
                            //       Traning3:
                            //           TreatmentData["Traning3"]?.toString() ??
                            //               "",
                            //       Traning4:
                            //           TreatmentData["Traning4"]?.toString() ??
                            //               "",
                            //       Traning5:
                            //           TreatmentData["Traning5"]?.toString() ??
                            //               "",
                            //       Traning6:
                            //           TreatmentData["Traning6"]?.toString() ??
                            //               "",
                            //       Traning7:
                            //           TreatmentData["Traning7"]?.toString() ??
                            //               "",
                            //       datetime:
                            //           TreatmentData["datetime"]?.toString() ??
                            //               "",
                            //     ),
                            //   ),
                            // ).toList()
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

class TraningCard extends StatelessWidget {
  final HorseModel horse;
  final String Traning;
  final String Traning2;
  final String Traning3;
  final String Traning4;
  final String Traning5;
  final String Traning6;
  final String Traning7;
  final String datetime;
  final int trainingId; // Add this field to accept nutritionId

  const TraningCard({
    super.key,
    required this.Traning,
    required this.Traning2,
    required this.Traning3,
    required this.Traning4,
    required this.Traning5,
    required this.Traning6,
    required this.Traning7,
    required this.datetime,
    required this.trainingId,
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
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Traning,
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                color: Color(0xFF8B48DF),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Duration",
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFFE0323F),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                Traning2.replaceFirst("PT", ""),
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Speed",
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFFE0323F),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                Traning3,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _buildTrainingColumn(
                                  "Walk", Traning4, Colors.black),
                              SizedBox(
                                  width: 8), // Adjust spacing between columns
                              _buildTrainingColumn(
                                  "Trot", Traning5, Colors.black),
                              SizedBox(
                                  width: 8), // Adjust spacing between columns
                              _buildTrainingColumn(
                                  "Canter", Traning6, Colors.black),
                              SizedBox(
                                  width: 8), // Adjust spacing between columns
                              _buildTrainingColumn(
                                  "Gallop", Traning7, Colors.black),
                            ],
                          )
                        ],
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Training Date",
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                color: Color(0xFF8B48DF),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(datetime),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  iconSize: 30.0,
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                                create: (context) =>
                                                    TraningFormBloc(),
                                                child: TraningForm(
                                                  horse: horse,
                                                  TraningId: trainingId,
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
                                              context.read<TraningBloc>().add(
                                                  DeleteTraining(
                                                      trainingId: trainingId));
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
                          //                     context.read<TraningBloc>().add(
                          //                         DeleteTraining(
                          //                             trainingId:
                          //                                 trainingId));
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
                        ],
                      ),
                    ],
                  ),
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

  Widget _buildTrainingColumn(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.karla(
            textStyle: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.karla(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
