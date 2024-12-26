import 'dart:typed_data';

import 'package:EquineApp/feature/subscripition/add_forms/Stable/bloc/add_stable_bloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Stable/list_stable.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Stable/view/add_stable.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:EquineApp/feature/header/app_bar.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_bloc.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_event.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_state.dart';
import 'package:EquineApp/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../../../data/models/stable_model.dart';
import '../../../../../../data/repo/repo.dart';
import '../../../../../common/widgets/ProfileImage.dart';
import '../../../../../common/widgets/custom_searchbar.dart';
import '../../../../../home/home_screen.dart';
import '../../../../../nav_bar/nav_bar.dart';
import '../../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../generate_qr/bloc/generate_qr_bloc.dart';
import '../../../../../generate_qr/view/generate_qr_view.dart';
import '../../../singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../singlestable_menu/view/singlestablemenu_view.dart';

class StableDashboard extends StatefulWidget {
  const StableDashboard({super.key});

  @override
  State<StableDashboard> createState() => _StableDashboardState();
}

class _StableDashboardState extends State<StableDashboard> {
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    context.read<StableBloc>().add(LoadStable());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StableBloc, StableState>(
      listener: (context, state) {
        if (state is StableError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: const NavigitionWidget(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                if (state is StableLoading)
                  Center(child: CircularProgressIndicator())
                else if (state is StableLoaded)
                  Column(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(
                                      0xFFE5E5FC), // Set the background color to blue
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set the border radius
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 10, 25,
                                    10), // Add some padding inside the blue box
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Stables',
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
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  AddStableBloc(),
                                              child: AddStableScreen(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            50, // Adjust width to fit the icon
                                        height:
                                            50, // Adjust height to fit the icon
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(139, 72, 223, 1),
                                          shape:
                                              BoxShape.circle, // Circular shape
                                          border: Border.all(
                                            color: const Color.fromARGB(255,
                                                211, 209, 209), // Grey border
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
                                    //       border: Border.all(
                                    //         // Add a grey border
                                    //         color: const Color.fromARGB(
                                    //             255,
                                    //             211,
                                    //             209,
                                    //             209), // Grey color for the outline
                                    //         width: 2.0, // Width of the outline
                                    //       ),
                                    //     ),
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 4.0, horizontal: 5),
                                    //       child: Text(
                                    //         textAlign: TextAlign.center,
                                    //         'Add Stables',
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
                                    //           create: (context) =>
                                    //               AddStableBloc(),
                                    //           child: AddStableScreen(),
                                    //         ),
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
                      // Align(
                      //     alignment: Alignment.centerRight,
                      //     child: CustomSearchBar(
                      //       width: 100,
                      //       height: 30,
                      //     )),
                      //SizedBox(height: 25),
                      state.stables.isEmpty
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
                              children: state.stables
                                  .map((StableName) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25.0),
                                        child:
                                            StableItem(StableName: StableName),
                                      ))
                                  .toList(),
                            )
                      // ...state.stables
                      //     .map((StableName) => Padding(
                      //           padding: const EdgeInsets.only(bottom: 25.0),
                      //           child: StableItem(StableName: StableName),
                      //         ))
                      //     .toList(),
                    ],
                  )
                else
                  Container(),
              ],
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

class StableItem extends StatelessWidget {
  final StableModel StableName;

  const StableItem({required this.StableName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                height: 70,
                width: 80,
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     width: 1,
                //     color: Color.fromRGBO(197, 192, 192, 1),
                //   ),
                //   borderRadius: BorderRadius.circular(35),
                // ),
                child: ProfileImage(
                  recordId: StableName.id.toString(),
                  tableName: 'Stable',
                  displayPane: 'profileImgs',
                )),
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
                            StableName.name,
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
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
                                      create: (context) => AddStableBloc(),
                                      child: AddStableScreen(
                                          stableId: StableName
                                              .id), // Pass the horse id
                                    ),
                                  ),
                                );
                                break;
                              case 'delete':
                                // Handle delete action
                                print('Delete selected');
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
                                            // Use the original context to access the HorseDashboardBloc
                                            context.read<StableBloc>().add(
                                                DeleteStable(
                                                    stableId: StableName.id));
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
                              case 'share':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                            create: (context) => QrBloc(),
                                            child: GenerateQr())));
                                // Handle share action
                                print('Share selected');
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
                                value: 'share',
                                child: Text('Share'),
                              ),
                            ];
                          },
                        ),
                        // Iconify(
                        //   moreHorizondal,
                        //   color: Color.fromRGBO(234, 146, 53, 1),
                        //   size: 28,
                        // ),
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
                            //   '270',
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
                            //   'Abudhabi',
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
        ),
      ],
    );
  }
}

// class ProfileWidget extends StatelessWidget {
//   final StableModel stable;
//   const ProfileWidget({required this.stable});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             //     appBar: AppBar(
//             //     //title: Text('Future Demo Page'),
//             // ),
//             body: FutureBuilder<Uint8List>(
//       future: uploadsRepo.getProfileImage(
//           recordId: stable.id.toString(),
//           tableName: "Stable",
//           displayPane: "profileImgs"),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return CircleAvatar(
//             radius: 50,
//             backgroundImage: MemoryImage(snapshot.data!),
//             backgroundColor: Colors
//                 .transparent, // Transparent background when image is present
//           );
//         } else if (snapshot.hasError) {
//           return CircleAvatar(
//             radius: 50,
//           );
//         }
//         return CircularProgressIndicator(); // Show a loading indicator
//       },
//     )));
//   }
// }