// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:timelines/timelines.dart';

import '../../../data/models/registered_device_model.dart';
import '../../../utils/constants/appreance_definition.dart';
import '../../tracker/widgets/tracker_bottom_navigation_widget.dart';
import '../bloc/tracker_steps_bloc.dart';

// ignore: must_be_immutable
class TrackerStepGpsView extends StatelessWidget {
  RegisteredDevice connectedDevice;

  TrackerStepGpsView({Key? key, required this.connectedDevice})
      : super(key: key);
  final List<String> _processes = ['Bluetooth', 'Location', 'Tracking'];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocConsumer<TrackerStepsBloc, TrackerStepsState>(
        listener: (content, state) {},
        builder: (content, state) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body:
                  //SingleChildScrollView(
                  //child:
                  SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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
                          itemCount: 3,
                          itemExtentBuilder: (_, __) {
                            return (MediaQuery.of(context).size.width - 120) /
                                3;
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
                                  fontSize: getTextSize11Value(buttonTextSize),
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w800,
                                  height: 0.62,
                                ),
                              ),
                            );
                          },
                          indicatorBuilder: (_, index) {
                            double indicatorSize =
                                30.0; // Set the desired size here

                            String formattedNumber =
                                (index + 1).toString().padLeft(2, '0');

                            if (index <= 1) {
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
                              return OutlinedDotIndicator(
                                borderWidth: 4.0,
                                size: indicatorSize,
                                color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    formattedNumber,
                                    style: TextStyle(color: Colors.blue),
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
                    SizedBox(height: 70),
                    // if (_processIndex != 0)
                    //   SizedBox(
                    //     height: 100,
                    //   ),
                    // if (_processIndex == 0)
                    SizedBox(
                      height: 30,
                    ),
                    //if (!connectedDevice.paired && _processIndex == 0)
                    Center(
                      child: RippleAnimation(
                        child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: SizedBox(
                                width: 60,
                                height: 60,
                                child: ClipOval(
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/location.png'))))),
                        color: Color.fromARGB(255, 192, 207, 236),
                        delay: const Duration(milliseconds: 100),
                        repeat: true,
                        minRadius: 80,
                        ripplesCount: 6,
                        duration: const Duration(milliseconds: 4000),
                      ),
                    ),

                    SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    // Set the desired width for the button
                    // height: 160, // Set the desired height for the button
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<TrackerStepsBloc>()
                            .add(TrackerStepsEnableGpsEvent());
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
                                  'Enable GPS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF8B48DF),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
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
        });
  }
}
