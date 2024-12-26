import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/service/service.dart';

@immutable
class DashboardBottomNavigationBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  Logger logger = new Logger();
  final String buttonTextSize = 'Medium';
  Future<String>? _futureData;

  DashboardBottomNavigationBarWidget({
    super.key,
  }); // Initialize with a default value

  @override
  void initState() {
    _futureData = fetchData();
  }

  Future<String> fetchData() async {
    String planId = await cacheService.getString(name: 'planId');
    return planId;
  }
  redirectToGoNamed(BuildContext context) async {
    String planId = await cacheService.getString(name: 'planId');
    logger.d("Planid : " + planId);
    if (planId == "2" || planId == 2 || planId == "3" || planId == 3) {
      logger.d("navigating to singlestable dashboard");
      context.goNamed(RoutePath.singlestabledashboard);
    } else if (planId == "1" || planId == 1) {
      logger.d("navigating to event dashboard");
      context.goNamed(RoutePath.eventorganizerdashboard);
    }
  }

  @override
  Widget build(BuildContext context)  {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Theme(
      data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: const Color(0xFF210063),
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: Colors.white,
        textTheme: Theme.of(context)
            .textTheme
            .copyWith(bodySmall: const TextStyle(color: Colors.white)),
      ),
      // sets the inactive color of the `BottomNavigationBar`
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              //iconSize: 24,
              //currentIndex: _currentIndex,
              onTap: (int index) {
                // Handle tap events here
                redirectToGoNamed(context);
                // if (index == 0) {
                //   context.goNamed(RoutePath.home);
                // } else if (index == 1) {
                //   context.goNamed(RoutePath.dashboard);
                // }
                // if (_futureData == 2 || _futureData == 3) {
                //   context.goNamed(RoutePath.singlestabledashboard);
                // } else if (_futureData == 1) {
                //   context.goNamed(RoutePath.eventorganizerdashboard);
                // }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: const ImageIcon(
                      AssetImage(
                        "assets/images/bottombar2.png",
                      ),
                      color: Colors.white,
                      size: 25,
                    ),
                    // child: Icon(Icons.home, color: Colors.white, size: 25)
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.only(top: 10),
                    // child: ImageIcon(
                    //   AssetImage("assets/images/bottombar3.png"),
                    //   color: Colors.white,
                    //   size: 30,
                    // ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  label: '',
                ),
              ],
            ),
          ),
          // _buildAnimatedLine(_currentIndex),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
