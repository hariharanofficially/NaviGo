import 'dart:async';

// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stomp_dart_client/stomp.dart';

// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/models/participant_model.dart';
import '../../../utils/constants/appreance_definition.dart';

// ignore: must_be_immutable
class ParticipantCardWidget extends StatelessWidget {
  final Logger logger = Logger();
  final ParticipantModel participant;
  final String type;
  ParticipantCardWidget({required this.participant, required this.type});

  final String buttonTextSize = 'Medium'; // Initialize with a default value
  late StompClient stompClient;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     summary = widget.participant["participantSummary"];
  //   });
  //   if (_isLive()) {
  //     stompClient = StompClient(
  //       config: StompConfig(
  //         url: 'ws://mindari.ae:7450/mindari-tracker/web/socket',
  //         connectionTimeout: Duration(seconds: 10),
  //         onConnect: _subscribeForEvent,
  //         beforeConnect: () async {
  //           print('waiting to connect...');
  //           //await Future.delayed(const Duration(milliseconds: 200));
  //           print('connecting...');
  //         },
  //         onWebSocketError: (dynamic error) => print(error.toString()),
  //         //stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
  //         //webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  //       ),
  //     );
  //     _activateWS();
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   stompClient.deactivate();
  //   super.dispose();
  // }

  bool _isLive() {
    String rideDate = participant.rideDate;
    DateTime currentDate = DateTime.now();
    String currentDateStr = DateFormat('yyyy-MM-dd').format(currentDate);
    //print(" === dates ${rideDate} and ${currentDateStr}");
    if (rideDate == currentDateStr) {
      return true;
    } else {
      return false;
    }
  }

  double _purplePanelSize() {
    if (_isLive()) {
      return 175;
    } else {
      return 130;
    }
  }

  double _whitePanelSize() {
    if (_isLive()) {
      return 95;
    } else {
      return 50;
    }
  }

  String _getValue(String type) {
    //var summary = participant['participantSummary'];
    // if (summary == null) {
    //   return "0";
    // }
    double value = 0;
    if (type == 'HR') {
      return participant.hrRate;
    } else if (type == 'AVG_HR') {
      return participant.avgHrRate;
    } else if (type == 'SPEED') {
      return participant.speed;
    } else if (type == 'AVG_SPEED') {
      return participant.avgSpeed;
    } else if (type == 'DISTANCE') {
      return participant.distance;
    }
    return value.toStringAsFixed(1);
  }

  String _getShowName() {
    String name = "";
    if (type == "dashboard") {
      name = participant.riderName;
    } else {
      name = participant.eventName;
    }
    if (name.length > 32) {
      name = name.substring(0, 32) + "...";
    }
    return name;
  }

  Future<void> _activateWS() async {
    if (!stompClient.connected) {
      logger.d("=== websocket not connected . Connecting ... ");
      stompClient.activate();
      logger.d("=== websocket connected ");
    }
  }

  // void _subscribeForEvent(StompFrame frame) async {
  //   //await _activateWS();
  //   String participantId = widget.participant['id'].toString();
  //   stompClient.subscribe(
  //     destination: '/topic/dashboard/participant/${participantId}',
  //     callback: (frame) {
  //       dynamic result = json.decode(frame.body!);
  //       print("== result from frame ");
  //       print(result);
  //       setState(() {
  //         summary = result['participantSummary'];
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => StaticTrackingData(widget.participant)),
        // );
        context.goNamed(RoutePath.staticTracking, extra: participant);
      },
      child: Container(
        width: double.infinity,
        height: _purplePanelSize(),
        margin: EdgeInsets.fromLTRB(0, 0, 5, 10),
        decoration: BoxDecoration(
          color: Color(0xFF8B48DF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
                height: 70,
                child: Row(children: [
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Container(
                                  //height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.30),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(10),
                                  child: Text.rich(
                                    TextSpan(
                                      text: participant.eventStartDate,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            getTextSize10Value(buttonTextSize),
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w800,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_isLive())
                                  Container(
                                    width: 15,
                                    height: 15,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                              ]),
                              Container(
                                alignment: Alignment.center,
                                child: Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                    text: participant.horseName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          getTextSize12Value(buttonTextSize),
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.w800,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                                  //margin: EdgeInsets.all(10),
                                  child: Text.rich(
                                    //textAlign: TextAlign.center,
                                    TextSpan(
                                      text: _getShowName(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            getTextSize14Value(buttonTextSize),
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w800,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                )
                              ])
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: participant.startNumber,
                          style: TextStyle(
                            color: Color(0xFF8B48DF),
                            fontSize: getTextSize12Value(buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  )
                ])),
            Container(
                height: _whitePanelSize(),
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_isLive())
                              DataInfo(
                                  type: 'SPEED',
                                  unit: 'km/h',
                                  value: _getValue('AVG_SPEED')),
                            if (_isLive())
                              DataInfo(
                                  type: 'SPEED',
                                  unit: 'km/h',
                                  value: _getValue('SPEED')),
                            if (_isLive())
                              CustomCard(
                                title: 'Avg. \nSpeed',
                                unit: 'km/h',
                                value: _getValue('AVG_SPEED'),
                                cardColor: Color(0xFFFAE4F1),
                              )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        child: VerticalDivider(
                          thickness: 1,
                          width: 2,
                          indent: 2,
                          endIndent: 2,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isLive())
                            DataInfo(
                              type: 'HR',
                              unit: 'bpm',
                              value: _getValue('AVG_HR'),
                            ),
                          if (_isLive())
                            DataInfo(
                              type: 'HR',
                              unit: 'bpm',
                              value: _getValue('HR'),
                            ),
                          if (_isLive())
                            CustomCard(
                              title: 'Avg. \nHeart Beat',
                              unit: 'bpm',
                              value: _getValue('AVG_HR'),
                              cardColor: Color(0xFFE5F8FE),
                            )
                        ],
                      )),
                      SizedBox(
                        height: 25,
                        child: VerticalDivider(
                          thickness: 1,
                          width: 2,
                          indent: 2,
                          endIndent: 2,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DataInfo(
                              type: 'DISTANCE',
                              unit: 'km',
                              value: _getValue('DISTANCE')),
                        ],
                      ))
                    ]))
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final buttonTextSize = 'Medium'; // Initialize with a default value
  final String title;
  final Color cardColor;
  final String value;
  final String unit;

  CustomCard({
    required this.title,
    required this.unit,
    required this.value,
    required this.cardColor,
  });
  double _getFigureTextSize() {
    return 14;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100, // Adjust the width as needed
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: cardColor, // Use the specified color for the card
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: 0.50,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),
          ),
          // SizedBox(
          //   height: 20,
          //   child: Container(
          //     width: 1,
          //     height: 0.99,
          //     decoration: ShapeDecoration(
          //       color: Color(0xFF85449A),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5)),
          //     ),
          //   ),
          // ),
          //SizedBox(width: 20), // Adjust the spacing as needed
          Expanded(
            child: Column(
              children: [
                Text(
                  '${value}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: _getFigureTextSize(),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${unit}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    //color: Colors.grey,
                    fontSize: getTextSize10Value(buttonTextSize),
                    fontFamily: 'Karla',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DataInfo extends StatelessWidget {
  final String buttonTextSize = 'Medium'; // Initialize with a default value

  final String value;
  final String unit;
  final String type;

  DataInfo({
    required this.type,
    required this.unit,
    required this.value,
  });

  double _getFigureTextSize() {
    return 18;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (type == 'HR')
                    Image.asset(
                      "assets/images/heartbeat.png",
                      width: 30,
                      height: 30,
                    ),
                  if (type == 'SPEED')
                    Image.asset(
                      "assets/images/speed_gauge.jpg",
                      width: 30,
                      height: 30,
                    ),
                  if (type == 'DISTANCE')
                    Image.asset(
                      "assets/images/distance.png",
                      width: 30,
                      height: 30,
                    ),
                ]),
          ),
          Expanded(
              flex: 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${value}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: _getFigureTextSize(),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${unit}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //color: Colors.grey,
                        fontSize: getTextSize10Value(buttonTextSize),
                        fontFamily: 'Karla',
                      ),
                    ),
                  ]))
        ],
      ),
    );
  }
}
