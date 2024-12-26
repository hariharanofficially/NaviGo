// ignore_for_file: unnecessary_import

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

void askEnableBluetoothPermissionDialog(BuildContext context) {
  Logger logger = new Logger();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: 200),
        child: AlertDialog(
          alignment: Alignment.center,
          title: Text(
            'Bluetooth Permission',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Permission to enable Bluetooth devices and pairing'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Allow'),
              onPressed: () async {
                //await _allowBluetooth();
                try {
                  if (Platform.isAndroid) {
                    await FlutterBluePlus.turnOn();
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  logger.e(e);
                  Navigator.of(context).pop();
                }
                //Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
          ],
        ),
      );
    },
  );
}
