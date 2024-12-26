import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/route/routes/route_path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {context.goNamed(RoutePath.dashboard)},
                child: Container(
                  width: 140,
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
                  child: Row(children: [
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/images/Dashboard.png', // Replace with the path to your image asset
                      width: 30, // Adjust the width of the image
                      height: 40, // Adjust the height of the image
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Color(0xFF8B48DF),
                          fontSize: 12,
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.w700,
                          height: 0.35,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () => {context.goNamed(RoutePath.tracker)},
                child: Container(
                  width: 140,
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
                  child: Row(children: [
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/images/tracker.png', // Replace with the path to your image asset
                      width: 40, // Adjust the width of the image
                      height: 40, // Adjust the height of the image
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        'Tracker',
                        style: TextStyle(
                          color: Color(0xFF8B48DF),
                          // fontSize: getTextSize12Value(buttonTextSize),
                          fontSize: 12,
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.w700,
                          height: 0.35,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              // SizedBox(
              //   height: 150.0,
              //   width: 175.0,
              //   child: IconButton(
              //     padding: EdgeInsets.all(0.0),
              //     icon: Image.asset('assets/images/dash.png'),
              //     iconSize: 10,
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => HomeDashboard()),
              //       );
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 150.0,
              //   width: 175.0,
              //   child: IconButton(
              //     padding: EdgeInsets.all(0.0),
              //     icon: Image.asset('assets/images/track.png'),
              //     iconSize: 10,
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => Dashboard()),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
