import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:EquineApp/feature/profile/Nutrition/Nutrition_dashboard/bloc/nutrition_bloc.dart';
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
import '../../Nutrition_Form/bloc/nutrition_form_bloc.dart';
import '../../Nutrition_Form/view/nutrition_form_view.dart';

class Nutrition extends StatefulWidget {
  final HorseModel horseid;
  const Nutrition({super.key, required this.horseid});

  @override
  State<Nutrition> createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    context.read<NutritionBloc>().add(LoadNutrition());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NutritionBloc, NutritionState>(
      listener: (context, state) {
        if (state is NutritionDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Nutrition deleted Successfully")),
          );
          context.read<NutritionBloc>().add(LoadNutrition());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: state is NutritionLoading
                  ? Center(child: CircularProgressIndicator())
                  : state is NutritionLoaded
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
                                              'Nutrition',
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
                                                              NutritionFormBloc(),
                                                          child: NutritionForm(
                                                            horseid:
                                                                widget.horseid,
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
                            state.nutritions.isEmpty
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
                                    children: state.nutritions
                                        .map((TreatmentData) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 25.0),
                                              child: nutritionCard(
                                                Nutrition:
                                                    TreatmentData["Nutrition"]
                                                            ?.toString() ??
                                                        "",
                                                Nutrition2:
                                                    TreatmentData["Nutrition2"]
                                                            ?.toString() ??
                                                        "",
                                                Nutrition3:
                                                    TreatmentData["Nutrition3"]
                                                            ?.toString() ??
                                                        "",
                                                Nutrition4:
                                                    TreatmentData["Nutrition4"]
                                                            ?.toString() ??
                                                        "",
                                                NutritionDate: TreatmentData[
                                                            "NutritionDate"]
                                                        ?.toString() ??
                                                    "",
                                                nutritionId: int.tryParse(
                                                        TreatmentData[
                                                                    "nutritionId"]
                                                                ?.toString() ??
                                                            "") ??
                                                    0,
                                                horseid: widget.horseid,
                                              ),
                                            ))
                                        .toList(),
                                  )
                            // ...state.nutritions
                            //     .map(
                            //       (TreatmentData) => Padding(
                            //         padding:
                            //             const EdgeInsets.only(bottom: 25.0),
                            //         child: nutritionCard(
                            //           Nutrition: TreatmentData["Nutrition"]
                            //                   ?.toString() ??
                            //               "",
                            //           Nutrition2: TreatmentData["Nutrition2"]
                            //                   ?.toString() ??
                            //               "",
                            //           Nutrition3: TreatmentData["Nutrition3"]
                            //                   ?.toString() ??
                            //               "",
                            //           Nutrition4: TreatmentData["Nutrition4"]
                            //                   ?.toString() ??
                            //               "",
                            //           NutritionDate:
                            //               TreatmentData["NutritionDate"]
                            //                       ?.toString() ??
                            //                   "",
                            //           nutritionId: int.tryParse(
                            //                   TreatmentData["nutritionId"]
                            //                           ?.toString() ??
                            //                       "") ??
                            //               0,
                            //           horseid: widget.horseid,
                            //         ),
                            //       ),
                            //     )
                            //     .toList(),
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

class nutritionCard extends StatelessWidget {
  final String Nutrition;
  final String Nutrition2;
  final String Nutrition3;
  final String Nutrition4;
  final String NutritionDate;
  final int nutritionId; // Add this field to accept nutritionId
  final HorseModel horseid;
  const nutritionCard({
    super.key,
    required this.Nutrition,
    required this.Nutrition2,
    required this.Nutrition3,
    required this.Nutrition4,
    required this.NutritionDate,
    required this.nutritionId,
    required this.horseid, // Add this required parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => NutritionFormBloc(),
              child: NutritionForm(
                nutritionId: nutritionId,
                horseid: horseid!,
                isSave: false,
              ),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                          Column(
                            children: [
                              Text(
                                Nutrition2,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFFE0323F),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),Text(
                                Nutrition3,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFFE0323F),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                Nutrition4,
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
                                "Serving Date",
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(NutritionDate),
                            ],
                          ),

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
                                              NutritionFormBloc(),
                                          child: NutritionForm(
                                            nutritionId: nutritionId,
                                            horseid: horseid!,
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
                                              context.read<NutritionBloc>().add(
                                                  DeleteNutrition(
                                                      nutritionId:
                                                          nutritionId));
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
                          // Column(
                          //   children: [
                          //     Text(
                          //       Nutrition,
                          //       style: GoogleFonts.karla(
                          //         textStyle: TextStyle(
                          //           color: Color(0xFF8B48DF),
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 7,
                          //     ),
                          //     Text(
                          //       Nutrition2,
                          //       style: GoogleFonts.karla(
                          //         textStyle: TextStyle(
                          //           color: Color(0xFFE0323F),
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     ),
                          //     Text(
                          //       Nutrition3,
                          //       style: GoogleFonts.karla(
                          //         textStyle: TextStyle(
                          //           color: Color(0xFF8B48DF),
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     ),
                          //     Text(
                          //       Nutrition4,
                          //       style: GoogleFonts.karla(
                          //         textStyle: TextStyle(
                          //           color: Color(0xFFE0323F),
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Column(
                          //   children: [
                          //     Text(NutritionDate),
                          //     IconButton(
                          //       icon: Icon(Icons.delete),
                          //       onPressed: () {
                          //         // Add your delete action here
                          //         print('Delete button pressed');
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
                          //                     context.read<NutritionBloc>().add(
                          //                         DeleteNutrition(
                          //                             nutritionId:
                          //                                 nutritionId));
                          //                     print('Delete selected');
                          //                     Navigator.of(dialogContext)
                          //                         .pop(); // Use dialogContext here to close the dialog after confirming
                          //                   },
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
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
                          //     //                     context
                          //     //                         .read<NutritionBloc>()
                          //     //                         .add(DeleteNutrition(
                          //     //                             nutritionId:
                          //     //                                 nutritionId));
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
                          //     //         Color(0xFFFEB567), // Background color
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
                          //     //           BorderRadius.circular(20), // 5px radius
                          //     //     ),
                          //     //   ),
                          //     //   onPressed: () {
                          //     //     Navigator.push(
                          //     //       context,
                          //     //       MaterialPageRoute(
                          //     //         builder: (context) => BlocProvider(
                          //     //           create: (context) =>
                          //     //               NutritionFormBloc(),
                          //     //           child: NutritionForm(
                          //     //             nutritionId: nutritionId,
                          //     //             horseid: horseid!,
                          //     //             isSave: false,
                          //     //           ),
                          //     //         ),
                          //     //       ),
                          //     //     );
                          //     //   },
                          //     //   child: Text(
                          //     //     'See Attachments',
                          //     //     style: TextStyle(color: Colors.white),
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
