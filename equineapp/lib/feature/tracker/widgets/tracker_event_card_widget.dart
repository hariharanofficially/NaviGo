// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/models/participant_model.dart';
import '../../../utils/constants/appreance_definition.dart' as ad;

class TrackerEventWidget extends StatelessWidget {
  final ParticipantModel? participant;
  final bool isPaired;
  TrackerEventWidget({required this.participant, required this.isPaired});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
      onTap: () {
        if (isPaired) context.goNamed(RoutePath.liveTracking, extra: participant);
        //if (isPaired)
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Trackingdata()),
        // );
      },
      child: Container(
        width: 328.65,
        height: 107.32,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 328.65,
                height: 107.32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Rectangle.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (!isPaired)
              Container(
                width: 300,
                height: 100,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Device not connected",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ad.getTextSize14Value(ad.buttonTextSize),
                          fontFamily: 'Karla',
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const Bluetooth()),
                            // );
                            context.goNamed(RoutePath.trackingstates);
                          },
                          child: Text("Scan and Pair"))
                    ]),
              ),
            if (isPaired)
              Positioned(
                left: 20.84,
                top: 15.59,
                child: Container(
                  width: 150.71,
                height: 60.23,
                  child: Stack(
                    children: [
                      //if (participant?["horse"] != null)
                      Positioned(
                        left: 0.71,
                        top: 14.66,
                        child: Text(
                          participant?.horseName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ad.getTextSize16Value(ad.buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      //if (participant?["rider"] != null)
                      Positioned(
                        left: 0,
                        top: 37.23,
                        child: Text(
                          participant?.riderName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ad.getTextSize12Value(ad.buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      //if (participant?["trackerDevice"] != null)
                      Positioned(
                        left: 0.71,
                        top: 0,
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            //'ID: ' + participant!.hrSensorId ?? '',
                            'ID: ' + participant!.hrSensorId,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ad.getTextSize12Value(ad.buttonTextSize),
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isPaired)
              Positioned(
                left: 248.83,
                top: 12.42,
                child: Container(
                  width: 72.42,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            if (isPaired)
              Positioned(
                left: 20.97,
              top: 72.09,
                child: Container(
                width: 110.74,
                height: 20.56,
                  child: Stack(
                    children: [
                      //if (participant?["horse"] != null)
                      Positioned(
                        left: 0.01,
                        top: 3.02,
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            participant?.horseCountryOfBirth ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ad.getTextSize8Value(ad.buttonTextSize),
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 17.53,
                          height: 14.32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isPaired)
              Positioned(
                left: 255.04,
                top: 10.92,
                child: Text(
                  participant?.eventStartDate ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ad.getTextSize10Value(ad.buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (isPaired)
              Positioned(
                left: 190.68,
                top: 54.24,
                child: Container(
                  width: 66.08,
                  height: 35.14,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 12.14,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: participant?.avgHrRate ?? '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ad.getTextSize16Value(ad.buttonTextSize),
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' bpm',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: ad.getTextSize10Value(ad.buttonTextSize),
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0.95,
                        top: 0,
                        child: Text(
                          'Avg heart beat',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: ad.getTextSize10Value(ad.buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isPaired)
              Positioned(
                left: 270.76,
                top: 54.24,
                child: Container(
                  width: 50.58,
                  height: 35.14,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0.58,
                        top: 12.14,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: participant?.avgSpeed ?? '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ad.getTextSize16Value(ad.buttonTextSize),
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' Km/hr',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: ad.getTextSize10Value(ad.buttonTextSize),
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          'Avg speed',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: ad.getTextSize10Value(ad.buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
