// import 'dart:io';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:logger/logger.dart';

void conveyBluetoothConnectionTakingTooLongDialog(BuildContext context) {
  // Logger logger = new Logger();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: 200),
        child: AlertDialog(
          alignment: Alignment.center,
          title: Text(
            'Pairing failed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
              'Bluetooth pair taking longer than expected. Please check if the device is online'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () async {
                //_nextStep();
                //await _getAllTrackerDevices();
                Navigator.of(context).pop();
              },
            ),
            // TextButton(
            //   child: Text('cancel'),
            //   onPressed: () {
            //     // Code to execute when Button 2 is pressed.
            //     Navigator.of(context).pop(); // Close the dialog.
            //   },
            // ),
          ],
        ),
      );
    },
  );
}
