import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

// import 'package:country_codes/country_codes.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/models/event_model.dart';
import '../../../utils/constants/appreance_definition.dart';
import '../../../utils/mixins/country_code.dart';

@immutable
class EventCardWidget extends StatelessWidget {
  final Logger logger = Logger();
  final String buttonTextSize = 'Medium'; // Initialize with a default value
  final EventModel event;
  EventCardWidget({required this.event});

  String _fomateToDate(String dateStr) {
    logger.d(dateStr);
    var d = DateFormat('yyyy-MM-dd').parse(dateStr);
    return DateFormat('dd-MMM-yy').format(d);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
      onTap: () {
        context.goNamed(RoutePath.participants,
            pathParameters: {"id": event.id.toString()});
      },
      child: Container(
        width: double.infinity,
        height: 100,
        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Rectangle.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              //height: 70,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                            text: _fomateToDate(event.startdate),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getTextSize10Value(buttonTextSize),
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w800,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: 140,
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Row(children: [
                            CountryFlag.fromCountryCode(
                              getAlpha2CountryCode(event.countryiso),
                              //'IN',
                              //key: Key.
                              height: 10,
                              width: 15,
                              //borderRadius: 8,
                            ),
                            SizedBox(width: 10),
                            Text.rich(
                              textAlign: TextAlign.end,
                              TextSpan(
                                text: event.locationname,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w800,
                                  height: 0,
                                ),
                              ),
                            ),
                          ]))
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
                            text: event.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getTextSize14Value(buttonTextSize),
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w800,
                              height: 0,
                            ),
                          )),
                        )
                      ]),
                  Row(
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          //margin: EdgeInsets.all(10),
                          child: Text.rich(
                            //textAlign: TextAlign.center,
                            TextSpan(
                              text: event.shortname,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getTextSize14Value(buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                          ),
                        )
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
