import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/service/service.dart';
@immutable
class TrackerBottomNavigationBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  Logger logger = new Logger();
  String buttonTextSize = 'Medium'; // Initialize with a default value

  redirectToGoNamed(BuildContext context) async {
    String planId = await cacheService.getString(name: 'planId');
    logger.d("Planid : " + planId);
    if (planId == "2" || planId == 2 || planId == "3" || planId == 3) {
      context.goNamed(RoutePath.singlestabledashboard);
    } else if (planId == 1 ||  planId == "1") {
      context.goNamed(RoutePath.eventorganizerdashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Theme(
      data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Color(0xFF210063),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
              labelMedium: const TextStyle(
                  color: Colors
                      .white))), // sets the inactive color of the `BottomNavigationBar`
      child: Stack(alignment: Alignment.topCenter, children: [
        Container(
          padding: EdgeInsets.zero,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            //iconSize: 24,
            onTap: (int index) {
              if (index == 0) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Bluetooth()),
                // );
                //context.goNamed(RoutePath.dashboard);singlestabledashboard
                //context.goNamed(RoutePath.singlestabledashboard);
                redirectToGoNamed(context);
              }
         /*     else if (index == 1) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Tracker()),
                // );
                //print('Home item pressed');
                context.goNamed(RoutePath.payment);
              }
              else if (index == 2) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: const Text('ADD')),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () => {
                                context.goNamed(RoutePath.people)
                              },
                              child: Container(
                                width: 200,
                                height: 65,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFFFFBFB),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2, color: Color(0xFF8B48DF)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x3385449A),
                                      blurRadius: 25,
                                      offset: Offset(0, 4),
                                      spreadRadius: 4,
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Image.asset(
                                      'assets/images/people.png', // Replace with the path to your image asset
                                      width: 30, // Adjust the width of the image
                                      height: 40, // Adjust the height of the image
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                   Text(
                                        'People',
                                        style: TextStyle(
                                          color: Color(0xFF8B48DF),
                                          fontSize: 12,
                                          fontFamily: 'Karla',
                                          fontWeight: FontWeight.w700,
                                          height: 0.35,
                                        ),
                                      ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () => {
                                context.goNamed(RoutePath.horse)
                              },
                              child: Container(
                                width: 200,
                                height: 65,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFFFFBFB),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2, color: Color(0xFF8B48DF)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x3385449A),
                                      blurRadius: 25,
                                      offset: Offset(0, 4),
                                      spreadRadius: 4,
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Image.asset(
                                      'assets/images/horse1.png', // Replace with the path to your image asset
                                      width: 30, // Adjust the width of the image
                                      height: 40, // Adjust the height of the image
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        'Horse',
                                        style: TextStyle(
                                          color: Color(0xFF8B48DF),
                                          fontSize: 12,
                                          fontFamily: 'Karla',
                                          fontWeight: FontWeight.w700,
                                          height: 0.35,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                        GestureDetector(
                          onTap: () => {
                            context.goNamed(RoutePath.stable)
                          },
                          child: Container(
                              width: 200,
                              height: 65,
                              decoration: ShapeDecoration(
                                color: Color(0xFFFFFBFB),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 2, color: Color(0xFF8B48DF)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x3385449A),
                                    blurRadius: 25,
                                    offset: Offset(0, 4),
                                    spreadRadius: 4,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Image.asset(
                                    'assets/images/stable.png', // Replace with the path to your image asset
                                    width: 30, // Adjust the width of the image
                                    height: 40, // Adjust the height of the image
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      'Stable',
                                      style: TextStyle(
                                        color: Color(0xFF8B48DF),
                                        fontSize: 12,
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w700,
                                        height: 0.35,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the alert dialog
                            },
                            child: const Text('close'),
                          ),
                        ],

                      );
                    }
                );}*/
              else if (index == 1) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Tracker()),
                // );
                //print('Home item pressed');
                context.goNamed(RoutePath.trackingstates);
              }
              else if (index == 2) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Trackingdata()),
                // );
                context.goNamed(RoutePath.liveTracking);
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: ImageIcon(
                      AssetImage(
                        "assets/images/bottombar2.png",
                      ),
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  label: ''),
             /* BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(top: 10),
                    // backgroundColor: Colors.white,
                    // color: Colors.white,
                    child: Icon(
                      Icons.credit_card,
                      size: 35.0, // Increase the size to 50.0
                      color: Colors.white, // Set the color to white
                    ),
                  ),
                  label: ''),*/
             /* BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(top: 10),
                    // backgroundColor: Colors.white,
                    // color: Colors.white,
                    child:Icon(
                      Icons.add,
                      size: 40.0, // Increase the size to 50.0
                      color: Colors.white, // Set the color to white
                    ),
                  ),
                  label: ''),*/
              BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(top: 10),
                    // backgroundColor: Colors.white,
                    // color: Colors.white,
                    child: ImageIcon(
                      AssetImage(
                        "assets/images/bottombar1.png",
                      ),
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: ImageIcon(
                      AssetImage("assets/images/bottombar3.png"),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  label: ''),
            ],
          ),
        ),
        // _buildAnimatedLine(_currentIndex),
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
