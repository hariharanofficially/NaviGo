// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/registered_device_model.dart';
import '../../../utils/constants/appreance_definition.dart';
import '../bloc/tracker_steps_bloc.dart';

// ignore: must_be_immutable
class TrackerStepBluetoothConnectedWidget extends StatelessWidget {
  RegisteredDevice connectedDevice;
  TrackerStepBluetoothConnectedWidget({Key? key, required this.connectedDevice})
      : super(key: key);
  int batteryLevel = 100;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackerStepsBloc, TrackerStepsState>(
        listener: (context, state) {
      if (state is TrackerStepsBatteryValueState) {
        this.batteryLevel = state.batteryLevel;
      }
    }, builder: (content, state) {
      return SingleChildScrollView(
          child: Container(
              width: double.infinity, // Set the width of the Card

              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              //color: Color(0xFF8B48DF),
              decoration: BoxDecoration(
                color: Color(0xFF8B48DF),

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                //borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.white,
                  // You can customize the color of the divider
                  thickness: 5,
                  // You can adjust the thickness of the divider
                  indent: 120,
                  // You can set the left indentation
                  endIndent: 120, // You can set the right indentation
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 150,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          flex: 2,
                          child: Column(children: [
                            Text(
                              "DEVICE NAME",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getTextSize14Value(buttonTextSize),
                                fontFamily: 'Karla',
                                // fontWeight: FontWeight.w700,
                                // height: 0,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              connectedDevice.deviceName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getTextSize18Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                // height: 0,
                              ),
                            )
                          ])),
                      Expanded(
                          flex: 1,
                          child: Column(children: [
                            Text(
                              "BATTERY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getTextSize16Value(buttonTextSize),
                                fontFamily: 'Karla',
                                // fontWeight: FontWeight.w700,
                                // height: 0,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '' + batteryLevel.toString() + '%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getTextSize18Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                // height: 0,
                              ),
                            )
                          ]))
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('Remove Pair'),
                          onPressed: () async {
                            print("pressed pair button");
                            //_showpairdevices(context, index);
                            //_showUnpairdevices(context);
                            context.read<TrackerStepsBloc>().add(
                                TrackerStepsUnPairDeviceEvent(
                                    hrCensorId: connectedDevice.hrCensorId));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                  0xFFC11344), // Button's background color
                              foregroundColor: Colors.white),
                        )
                      ],
                    ),
                  ]),
                )
              ])));
    });
  }
}
