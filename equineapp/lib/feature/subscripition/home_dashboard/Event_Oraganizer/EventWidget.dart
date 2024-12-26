import 'package:EquineApp/feature/home/home_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../app/route/routes/route_path.dart';
import '../../../../data/models/event_model.dart';
import '../../../../data/models/roles.dart';
import '../../../../data/service/service.dart';

class EventWidgetList extends StatefulWidget {
  List<EventModel> events;
  RolesModel role;
  EventWidgetList({super.key, required this.events, required this.role});

  @override
  State<EventWidgetList> createState() => _EventWidgetListState();
}

class _EventWidgetListState extends State<EventWidgetList> {
  String userId = "8";
  @override
  void initState() {
    super.initState();
    // Start the async operation when the widget is initialized
    setUserId();
  }

  void setUserId() async {
    userId = await cacheService.getString(name: "userId");
    setState() {
      userId = "" + userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the events list is empty or null
    if (widget.events.isEmpty) {
      return Center(
        child: CircularProgressIndicator(), // Show loading spinner
      );
    }
    return FadeInLeft(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10.0),
            //   child: Container(
            //     height: 155,
            //     decoration: BoxDecoration(
            //       color: Color.fromRGBO(254, 185, 65, 0.9),
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           spreadRadius: 3,
            //           blurRadius: 5,
            //           offset: Offset(0, 3), // changes position of shadow
            //         ),
            //       ],
            //     ),
            //     child:   Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            //       child: Column(
            //         children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Row(
            //
            //                 children: [
            //                   Text(
            //                     'Recent Activity',style: GoogleFonts.karla(
            //                     textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            //                   ),
            //                   ),
            //                   SizedBox(width: 15,),
            //
            //                 ],
            //
            //               ),
            //
            //               CircleAvatar(
            //                 backgroundColor: Colors.red,
            //                 radius: 16,
            //                 child: Icon(Icons.arrow_forward,color: Color.fromRGBO(254, 185, 65, 0.9),),
            //                 //Text
            //               ),
            //             ],
            //           ),
            //           SizedBox(height: 15),
            //           Column(
            //             children: [
            //               Row(
            //                 children: [
            //                   CircleAvatar(
            //                     backgroundColor: Colors.white,
            //                     radius: 10,
            //                     //Text
            //                   ),
            //                   SizedBox(width: 12,),
            //                   Text(
            //                     'Login on 24.5.2024',style: GoogleFonts.karla(
            //                     textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
            //                   ),
            //                   ),
            //
            //
            //                 ],
            //               ),
            //               SizedBox(height: 8),
            //               Row(
            //                 children: [
            //                   CircleAvatar(
            //                     backgroundColor: Colors.white,
            //                     radius: 10,
            //                     //Text
            //                   ),
            //                   SizedBox(width: 12,),
            //                   Text(
            //                     'Added Horses ',style: GoogleFonts.karla(
            //                     textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
            //                   ),
            //                   ),
            //
            //
            //                 ],
            //               ),
            //               SizedBox(height: 8),
            //               Row(
            //                 children: [
            //                   CircleAvatar(
            //                     backgroundColor: Colors.white,
            //                     radius: 10,
            //                     //Text
            //                   ),
            //                   SizedBox(width: 12,),
            //                   Text(
            //                     'Trainer login recently',style: GoogleFonts.karla(
            //                     textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
            //                   ),
            //                   ),
            //
            //
            //                 ],
            //               ),
            //
            //
            //             ],
            //
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10,),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text(
                'Added Events Details',
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                //color: Color(0xFFF6ADAD),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.events
                      .map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: eventContainer(
                              context, event, widget.role, userId),
                        ),
                      )
                      .toList(),
                  // eventContainer('Live'),
                  // eventContainer('Completed'),
                  // eventContainer('Upcoming'),
                ],
              ),
            ),
            SizedBox(height: 20),
            // GestureDetector (onTap: () {
            //    Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) => HomeScreen(),
            //                       ),
            //                     );
            // },
            //   child: Center( child: Image.asset(
            //       'assets/images/tracker_horse.png', // Replace with your image path
            //       width: 200,
            //       height: 200,
            //       fit: BoxFit.cover,
            //     ),),
            // )
          ],
        ),
      ),
    );
  }
}

String _getShowName(String name) {
  if (name.length > 18) {
    name = name.substring(0, 18) + "...";
  }
  return name;
}

Color _getColorCode(String startDate, String endDate) {
  DateTime sd = DateFormat('yyyy-MM-dd').parse(startDate);
  DateTime ed = DateFormat('yyyy-MM-dd').parse(endDate);
  DateTime today = DateTime.now();
  if (sd.isBefore(today) && ed.isAfter(today)) {
    return Colors.red;
  }
  if (sd.isAfter(today)) {
    return Color.fromRGBO(184, 184, 184, 1);
  }
  //(status=='Live')?Colors.red:(status=='Upcoming')?Color.fromRGBO(184, 184, 184, 1):Colors.white,
  return Colors.white;
}

Color _getTextColorCode(String startDate, String endDate) {
  DateTime sd = DateFormat('yyyy-MM-dd').parse(startDate);
  DateTime ed = DateFormat('yyyy-MM-dd').parse(endDate);
  DateTime today = DateTime.now();
  if (sd.isBefore(today) && ed.isAfter(today)) {
    return Colors.white;
  }
  if (sd.isAfter(today)) {
    return Colors.black;
  }
  //(status=='Live')?Colors.red:(status=='Upcoming')?Color.fromRGBO(184, 184, 184, 1):Colors.white,
  return Colors.red;
}

String _getEventStatus(String startDate, String endDate) {
  DateTime sd = DateFormat('yyyy-MM-dd').parse(startDate);
  DateTime ed = DateFormat('yyyy-MM-dd').parse(endDate);
  DateTime today = DateTime.now();
  if (sd.isBefore(today) && ed.isAfter(today)) {
    return "Live";
  }
  if (sd.isAfter(today)) {
    return "Upcoming";
  }
  //(status=='Live')?Colors.red:(status=='Upcoming')?Color.fromRGBO(184, 184, 184, 1):Colors.white,
  return "Finished";
}

Widget eventContainer(
    BuildContext context, EventModel event, RolesModel role, String userId) {
  var status = "Live";
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: GestureDetector(
        onTap: () {
          context.goNamed(RoutePath.participants,
              pathParameters: {"id": event.id.toString()});
          // if (userId == "8") {
          //   context.goNamed(RoutePath.participants,
          //       pathParameters: {"id": event.id.toString()});
          // }
          // else if (role.name == "trainer") {
          //   context.goNamed(RoutePath.tracker);
          // } else {
          //   context.goNamed(RoutePath.participants,
          //       pathParameters: {"id": event.id.toString()});
          // }
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              color: Color(0xff8B48DF),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.startdate,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      _getShowName(event.name),
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      event.raceType,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      color: _getColorCode(event.startdate,
                          event.endDate ?? DateTime.now().toString()),
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 5),
                    child: Text(
                      textAlign: TextAlign.center,
                      _getEventStatus(event.startdate,
                          event.endDate ?? DateTime.now().toString()),
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: _getTextColorCode(
                                event.startdate,
                                event.endDate ??
                                    DateTime.now()
                                        .toString()), //(status=='Live')?Colors.white:(status=='Upcoming')?Colors.black:Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}
