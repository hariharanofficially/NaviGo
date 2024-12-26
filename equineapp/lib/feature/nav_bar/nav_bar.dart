import 'dart:io';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/bloc/single_stable_bloc.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Single_stable/view/single_stable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/service/service.dart';
import '../subscripition/home_dashboard/Event_Oraganizer/bloc/event_oraganizer_bloc.dart';
import '../subscripition/home_dashboard/Event_Oraganizer/view/event_organizer_view.dart';
import '../subscripition/manage_dashboard/event_menu/bloc/event_menu_bloc.dart';
import '../subscripition/manage_dashboard/event_menu/view/event_menu_view.dart';
import '../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../../../../app/route/routes/route_path.dart';
// import '../../Subscription_plan/Menu/singlestable_menu.dart';
// import '../../Subscription_plan/My_Plan/Single_stable/single_stable.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  // final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    // required this.onTap,
  });

  Future<void> _navigateHomeBasedOnPlan(BuildContext context) async {
    // Mocking the cache service for example purposes.
    // Replace this with the actual cache service call.
    final planId = await cacheService.getString(name: 'planId');

    if (planId == '1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => EventsOrganizerBloc(),
            child: EventsOrganizerDashboard(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SingleStableDashboardBloc(),
            child: SingleStableDashboard(),
          ),
        ),
      );
    }
  }

  Future<void> _navigatemanageBasedOnPlan(BuildContext context) async {
    // Mocking the cache service for example purposes.
    // Replace this with the actual cache service call.
    final planId = await cacheService.getString(name: 'planId');

    if (planId == '1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => EventMenuBloc(),
            child: EventMenu(),
          ),
        ),
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => SingleStableMenuBloc(),
                  child: SingeleStableMenu())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: Platform.isAndroid ? 16 : 0,
      ),
      child: BottomAppBar(
        elevation: 0.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            color: Color.fromRGBO(254, 149, 38, 0.7),
            child: Row(
              children: [
                navItem(
                  Icons.home_filled,
                  pageIndex == 3,
                  onTap: () {
                    _navigateHomeBasedOnPlan(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => BlocProvider(
                    //           create: (context) => SingleStableDashboardBloc(),
                    //           child: SingleStableDashboard())),
                    // );
                  },
                ), // Circular Button in the center
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white, // Button background color
                    shape: BoxShape.circle, // Makes the button circular
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      context.goNamed(RoutePath.tracker);
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/images/Racing.png', // Path to your asset
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                ),
                navItem(
                  Icons.space_dashboard_rounded,
                  pageIndex == 2,
                  onTap: () {
                    _navigatemanageBasedOnPlan(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => BlocProvider(
                    //             create: (context) => SingleStableMenuBloc(),
                    //             child: SingeleStableMenu())));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
