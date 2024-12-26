// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines/timelines.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/models/participant_model.dart';
import '../../../data/models/registered_device_model.dart';
import '../../../utils/constants/appreance_definition.dart';
import '../../tracker/widgets/tracker_bottom_navigation_widget.dart';

// ignore: must_be_immutable
class TrackerStepGoliveView extends StatelessWidget {
  RegisteredDevice connectedDevice;
  ParticipantModel? participant;
  TrackerStepGoliveView(
      {Key? key, required this.connectedDevice, required this.participant})
      : super(key: key);
  final List<String> _processes = ['Bluetooth', 'Location', 'Tracking'];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:
            //SingleChildScrollView(
            //child:
            SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 75,
                alignment: Alignment.topCenter,
                child: Timeline.tileBuilder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  theme: TimelineThemeData(
                    direction: Axis.horizontal,
                    connectorTheme:
                        ConnectorThemeData(space: 8.0, thickness: 2.0),
                  ),
                  builder: TimelineTileBuilder.connected(
                    connectionDirection: ConnectionDirection.before,
                    itemCount: _processes.length,
                    itemExtentBuilder: (_, __) {
                      return (MediaQuery.of(context).size.width - 120) /
                          _processes.length;
                    },
                    oppositeContentsBuilder: (context, index) {
                      return Container();
                    },
                    contentsBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          _processes[index],
                          style: TextStyle(
                            color: Color(0xFF3DA3F4),
                            fontSize: getTextSize12Value(buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w800,
                            height: 0.62,
                          ),
                        ),
                      );
                    },
                    indicatorBuilder: (_, index) {
                      double indicatorSize = 30.0; // Set the desired size here

                      String formattedNumber =
                          (index + 1).toString().padLeft(2, '0');

                      if (index <= 2) {
                        return DotIndicator(
                          size: indicatorSize,
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              formattedNumber,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        return DotIndicator(
                          //borderWidth: 4.0,
                          size: indicatorSize,
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              formattedNumber,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                    connectorBuilder: (_, index, type) {
                      if (index > 0) {
                        return SolidLineConnector(
                          color: Colors.blue,
                        );
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '   Tracker info',
                        style: TextStyle(
                          //color: isDarkMode ? Colors.white : Color(0xFF140137),
                          fontSize: getTextSize14Value(buttonTextSize),
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Adding a Card
                    Card(
                      color: Color(0xFF8B48DF),
                      // Set the width and height of the Card to your desired size
                      elevation: 4, // Adjust the elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Adjust the border radius as needed
                      ),
                      child: Container(
                        width: double.infinity, // Adjust the width as needed
                        height: 70, // Adjust the height as needed
                        padding: EdgeInsets.all(16), // Add padding for spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content to the left
                          children: [
                            Text(
                              'Polar ID ' + participant!.trackerDeviceId,
                              style: TextStyle(
                                color: Color(0xFFFDF8FF),
                                fontSize: getTextSize14Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                                height:
                                    8), // Add spacing between title and content
                            Opacity(
                              opacity: 0.50,
                              child: Text(
                                'ID : ' + participant!.hrSensorId,
                                style: TextStyle(
                                  color: Color(0xFFFDF8FF),
                                  fontSize: getTextSize10Value(buttonTextSize),
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // Adding a Card
                    Card(
                      color: Color(0xFFF7F7F7),
                      // Set the width and height of the Card to your desired size
                      elevation: 4, // Adjust the elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Adjust the border radius as needed
                      ),
                      child: Container(
                        width: double.infinity, // Adjust the width as needed
                        height: 100, // Adjust the height as needed
                        padding: EdgeInsets.all(16), // Add padding for spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content to the left
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Opacity(
                                  opacity: 0.50,
                                  child: Text(
                                    'Horse Detail',
                                    style: TextStyle(
                                      // color: isDarkMode
                                      //     ? Colors.black
                                      //     : Color(0xFF140137),
                                      fontSize:
                                          getTextSize12Value(buttonTextSize),
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              participant!.horseName,
                              style: TextStyle(
                                color: Color(0xFF140137),
                                fontSize: getTextSize16Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),

                            SizedBox(
                                height:
                                    8), // Add spacing between title and content
                            Text(
                              //'Id: ${participant!.horseId?.toString()}',
                              'Id: ${participant!.horseId}',
                              style: TextStyle(
                                color: Color(0xFF140137),
                                fontSize: getTextSize10Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // Adding a Card
                    Card(
                      color: Color(0xFFF7F7F7),
                      // Set the width and height of the Card to your desired size
                      elevation: 4, // Adjust the elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Adjust the border radius as needed
                      ),
                      child: Container(
                        width: double.infinity, // Adjust the width as needed
                        height: 125, // Adjust the height as needed
                        padding: EdgeInsets.all(16), // Add padding for spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content to the left
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Opacity(
                                opacity: 0.50,
                                child: Opacity(
                                  opacity: 0.50,
                                  child: Text(
                                    'Rider Detail',
                                    style: TextStyle(
                                      // color: isDarkMode
                                      //     ? Colors.black
                                      //     : Color(0xFF140137),
                                      fontSize:
                                          getTextSize12Value(buttonTextSize),
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              participant!.riderName,
                              style: TextStyle(
                                color: Color(0xFF140137),
                                fontSize: getTextSize16Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                                height:
                                    8), // Add spacing between title and content
                            Text(
                              'Id: ${participant!.riderId.toString()}', //participant!.riderId?.toString()
                              style: TextStyle(
                                color: Color(0xFF140137),
                                fontSize: getTextSize10Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity, // Set the desired width for the button
              // height: 160, // Set the desired height for the button
              child: ElevatedButton(
                onPressed: () {
                  // if (_processIndex == _processes.length - 2) {
                  //   _enableGps();
                  //   // return 'Enable GPS'; // Change the button label to move to Location
                  // } else if (_processIndex == _processes.length - 1) {
                  //   // _showDialog(context);
                  //   _nextStep();
                  //   // return 'Go Live'; // Change the button label to move to Tracking
                  // } else {
                  //   setState(() {
                  //     isRegisteringDevice = true;
                  //   });
                  //   _registerpopup();
                  // }
                  context.goNamed(RoutePath.liveTracking, extra: participant);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF8B48DF), // Button's background color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(
                            0.0)), // Adjust the radius as needed
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 5,
                      width: 101,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    // Add a divider
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 4.0, // Adjust the elevation as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the radius as needed
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(25, 16, 25, 16),
                          // Add padding for spacing inside the card
                          child: Text(
                            'Go Live',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF8B48DF),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ), // Use the Card as the first child
                    SizedBox(height: 10)
                  ],
                ),
              ),
            ),
            TrackerBottomNavigationBarWidget()
          ],
        ));
  }
}
