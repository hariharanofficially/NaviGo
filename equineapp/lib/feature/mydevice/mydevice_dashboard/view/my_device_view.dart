// import 'package:EquineApp/feature/mydevice/bloc/mydevice_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../data/models/registered_device_model.dart';
import '../../../../data/models/tracker_device_model.dart';
import '../../../../utils/constants/icons.dart';
import '../../../common/widgets/navigation_widget.dart';
import '../../../header/app_bar.dart';
import '../../../home/home_screen.dart';
import '../../../nav_bar/nav_bar.dart';
import '../../mydevice_form/bloc/mydevices_form_bloc.dart';
import '../../mydevice_form/view/mydevices_form_view.dart';
import '../bloc/mydevice_bloc.dart';

import '../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../nav_bar/Dashboard/view/Dashboard_view.dart';

class mydevice extends StatefulWidget {
  const mydevice({super.key});

  @override
  State<mydevice> createState() => _mydeviceState();
}

class _mydeviceState extends State<mydevice> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<MydeviceBloc>().add(LoadMydevice());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MydeviceBloc, MydeviceState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: const NavigitionWidget(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: state is MydeviceLoading
                ? Center(child: CircularProgressIndicator())
                : state is MydeviceLoaded
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
                                          'My Devices',
                                          style: GoogleFonts.karla(
                                            textStyle: TextStyle(
                                              color: Color(0xFF595BD4),
                                              // Change text color to white for contrast
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
                                                            MydevicesFormBloc(),
                                                        child: MydevicesForm()),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width:
                                                50, // Adjust width to fit the icon
                                            height:
                                                50, // Adjust height to fit the icon
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  139, 72, 223, 1),
                                              shape: BoxShape
                                                  .circle, // Circular shape
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255,
                                                    211,
                                                    209,
                                                    209), // Grey border
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          state.Mydevice.isEmpty
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
                                  children: state.Mydevice.map((mydevice) =>
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25.0),
                                        child: mydeviceitem(mydevice: mydevice),
                                      )).toList(),
                                )

                          //     ...state.Mydevice.map((mydevice) => Padding(
                          //           padding: const EdgeInsets.only(bottom: 25.0),
                          //           child: mydeviceitem(mydevice: mydevice),
                          //         )).toList(),
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

class mydeviceitem extends StatelessWidget {
  final RegisteredDevice mydevice;

  mydeviceitem({required this.mydevice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              // Container(
              //   height: 70,
              //   width: 80,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       width: 1,
              //       color: Color.fromRGBO(197, 192, 192, 1),
              //     ),
              //     borderRadius: BorderRadius.circular(35),
              //   ),
              //   // child: ProfileWidget(stable: StableName),
              // ),
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
                              mydevice.deviceName,
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
                                          create: (context) =>
                                              MydevicesFormBloc(),
                                          child: MydevicesForm(
                                              mydevices: mydevice.deviceId)),
                                    ),
                                  );
                                  break;
                                case 'delete':
                                  // Handle delete action
                                  print('Delete selected');
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
                              ];
                            },
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
          ),
        ],
      ),
    );
  }
}
