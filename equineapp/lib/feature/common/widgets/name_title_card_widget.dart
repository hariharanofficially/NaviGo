import 'package:flutter/material.dart';

import '../../../utils/constants/appreance_definition.dart';

class TitleCardWidget extends StatelessWidget {
  final String buttonTextSize = 'Medium'; // Initialize with a default value
  final String deviceName;
  final String deviceId;
  final String riderName;

  TitleCardWidget({
    required this.deviceName,
    required this.deviceId,
    required this.riderName,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF8B48DF),
      elevation: 4,
      borderOnForeground: false,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
      //shadowColor: Color(0xFF8B48DF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      // outer card
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              // inner first card
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      //'${currentParticipant?['trackerDevice']?['trackerDeviceId']}',
                      '${deviceName}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: getTextSize18Value(buttonTextSize),
                        fontWeight: FontWeight.w700,
                        //fontFamily: 'Helvitica',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      //'ID : ${currentParticipant?['trackerDevice']?['heartRateCensorId']}',
                      'ID : ${deviceId}',
                      style: TextStyle(
                        fontSize: getTextSize14Value(buttonTextSize),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  //'${currentParticipant?['rider']?['name']}',
                  '${riderName}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: getTextSize14Value(buttonTextSize),
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
