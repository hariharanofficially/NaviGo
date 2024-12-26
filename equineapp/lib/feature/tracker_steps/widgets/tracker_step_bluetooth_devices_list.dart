// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/registered_device_model.dart';
import '../../../utils/constants/appreance_definition.dart';
import '../bloc/tracker_steps_bloc.dart';

// ignore: must_be_immutable
class TrackerStepBluetoothListWidget extends StatelessWidget {
  List<RegisteredDevice> registeredDevices;
  TrackerStepBluetoothListWidget({Key? key, required this.registeredDevices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackerStepsBloc, TrackerStepsState>(
        builder: (content, state) {
      return SingleChildScrollView(
        child: Container(
          width: double.infinity, // Set the width of the Card

          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          //color: Color(0xFF8B48DF),
          decoration: BoxDecoration(
            color: Color(0xFF8B48DF),
            //borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              const Divider(
                color:
                    Colors.white, // You can customize the color of the divider
                thickness: 5, // You can adjust the thickness of the divider
                indent: 120, // You can set the left indentation
                endIndent: 120, // You can set the right indentation
              ),
              SizedBox(
                height: 10,
              ),
              if (state is TrackerStepsPairingState)
                Text(
                  "Pairing please wait  ...",
                  style: TextStyle(color: Colors.white),
                ),
              if (state is TrackerStepsPairingState)
                SizedBox(
                  height: 20,
                ),
              Container(
                height: 300,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                //padding: const EdgeInsets.fromLTRB(0,0,10,0),
                child: ListView.builder(
                  itemCount: this.registeredDevices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      //color: Colors.white,
                      decoration: BoxDecoration(
                        //
                        color: Colors.white, //                <-- BoxDecoration
                      ),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/bluetooth.png',
                                    width: 35.0,
                                    height: 35.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(children: [
                                    Text(
                                      this.registeredDevices[index].deviceName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: getTextSize16Value(
                                              buttonTextSize)),
                                    ),
                                    if (this.registeredDevices[index].saved)
                                      Text(
                                        this
                                            .registeredDevices[index]
                                            .hrCensorId,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                  ]),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: <Widget>[
                                      if (!this
                                              .registeredDevices[index]
                                              .paired &&
                                          this.registeredDevices[index].online)
                                        ElevatedButton(
                                          child: Text('Pair'),
                                          onPressed: () async {
                                            print("pressed pair button");
                                            //_showpairdevices(context, index);
                                            // await _connectDevice(
                                            //     scannedDevices[index]
                                            //         .heartRateDeviceId);
                                            context
                                                .read<TrackerStepsBloc>()
                                                .add(
                                                    TrackerStepsPairDeviceEvent(
                                                        hrCensorId: this
                                                            .registeredDevices[
                                                                index]
                                                            .hrCensorId));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF134CC1),
                                            // Button's background color
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      if (!this.registeredDevices[index].online)
                                        ElevatedButton(
                                          child: Text('Offline',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: getTextSize12Value(
                                                      buttonTextSize))),
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4B4C4E),
                                            // Button's background color
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                //SizedBox(width: 70),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          //),
        ),
      );
    });
  }
}
