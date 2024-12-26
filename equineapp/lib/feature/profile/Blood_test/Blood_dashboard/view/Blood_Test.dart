import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../../data/models/bloodtest_element.dart';
import '../../../../../data/models/bloodtest_result.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../utils/mixins/convert_date_format.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../Blood_Form copy/bloc/blood_form_view_bloc.dart';
import '../../Blood_Form copy/view/Blood_form_view_view.dart';
import '../../Blood_Form/bloc/blood_form_bloc.dart';
import '../../Blood_Form/view/Blood_form_view.dart';
import '../bloc/blood_bloc.dart';

class BloodTest extends StatefulWidget {
  final HorseModel horse;

  const BloodTest({
    super.key,
    required this.horse,
  });

  @override
  State<BloodTest> createState() => _BloodTestState();
}

class _BloodTestState extends State<BloodTest> {
  int selectedTab = 0;
  List<BloodTestResult> testResults = [];
  List<String> bloodTestDates = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    context
        .read<BloodBloc>()
        .add(LoadBlood(horseId: widget.horse.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BloodBloc, BloodState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is BloodLoaded) {
          testResults = state.blood;
          bloodTestDates = testResults
              .map((obj) =>
                  formatDate(obj.testDateTime)) // Format date to 'yyyy-MM-dd'
              .toSet() // Convert to a set to remove duplicates
              .toList();
          loading = false;
        } else if (state is BloodLoading) {
          loading = true;
        } else if (state is BloodTestDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Blood Test Result deleted Successfully")),
          );
          context
              .read<BloodBloc>()
              .add(LoadBlood(horseId: widget.horse.id.toString()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
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
                                            'BloodTest',
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
                                                            BloodFormBloc(),
                                                        child: BloodForm(
                                                          horse: widget.horse,
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
                          testResults.isEmpty
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
                                  children: bloodTestDates.map((date) {
                                  final filteredResults = testResults
                                      .where((obj) =>
                                          formatDate(obj.testDateTime) == date)
                                      .toList();
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 25.0),
                                    child: BloodCardNew(
                                      result: filteredResults
                                          .first, // Adjust this logic as needed
                                      testDate: date,
                                      horse: widget.horse,
                                    ),
                                  );
                                }).toList())
                          // ...state.Blood.map(
                          //   (bloodData) => Padding(
                          //     padding: const EdgeInsets.only(bottom: 25.0),
                          //     child: BloodCard(
                          //       Blood: bloodData["Blood"] ?? "",
                          //       Blood2: bloodData["Blood2"] ?? "",
                          //     ),
                          //   ),
                          // ).toList(),
                        ],
                      )
                //: Container(),
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

class BloodCard extends StatelessWidget {
  final BloodTestResult result;

  const BloodCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Row(
            children: [
              //SizedBox(width: 15),
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
                                result.elementCategory,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              Text(
                                result.elementName +
                                    " : " +
                                    result.result.toString(),
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
                          Column(
                            children: [
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
                              //   onPressed: () {},
                              //   child: Text(
                              //     'See Result',
                              //     style: TextStyle(color: Colors.white),
                              //   ),
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
                              //   onPressed: () {},
                              //   child: Text(
                              //     'See Result',
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
              Column(
                children: [
                  Text(formatDate(result.testDateTime)),
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
                                  print('Delete selected');
                                  context.read<BloodBloc>().add(DeleteBloodTest(
                                      id: result.id.toString()));
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
                  //                     print('Delete selected');
                  //                     context.read<BloodBloc>().add(
                  //                         DeleteBloodTest(
                  //                             id: result.id.toString()));
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
                  //       // PopupMenuItem<String>(
                  //       //   value: 'edit',
                  //       //   child: Text('Edit'),
                  //       // ),
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
          SizedBox(
            height: 5,
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

class BloodCardNew extends StatelessWidget {
  final BloodTestResult result;
  final String testDate;
  final HorseModel horse;

  const BloodCardNew(
      {super.key,
      required this.result,
      required this.horse,
      required this.testDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => BloodFormViewBloc(),
                    child: BloodFormView(
                      horse: horse,
                      testDate: formatDateToDateString(testDate),
                    ),
                  )),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              //SizedBox(width: 15),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Test Date : " + testDate,
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      color: Color(0xFF8B48DF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Test Purpose : " + result.typeName,
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
                                                    BloodFormBloc(),
                                                child: BloodForm(
                                                  horse: horse,
                                                  bloodId: result.id,
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
                                              print('Delete selected');
                                              context.read<BloodBloc>().add(
                                                  DeleteBloodTest(
                                                      id: result.id
                                                          .toString()));
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
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
