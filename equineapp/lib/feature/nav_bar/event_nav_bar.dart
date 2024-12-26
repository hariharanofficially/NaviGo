// import 'dart:io';
// import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/events_dashboard/bloc/events_dashboard_bloc.dart';
// import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/events_dashboard/view/events_dashboard_view.dart';
// import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/bloc/event_oraganizer_bloc.dart';
// import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/view/event_organizer_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../app/route/routes/route_path.dart';
// import '../subscripition/manage_dashboard/event_menu/bloc/event_menu_bloc.dart';
// import '../subscripition/manage_dashboard/event_menu/view/event_menu_view.dart';

// // import '../../Subscription_plan/Menu/events_dashboard.dart';
// // import '../../Subscription_plan/My_Plan/Event_Oraganizer/event_organizer.dart';

// class EventNavBar extends StatelessWidget {
//   final int pageIndex;
//   // final Function(int) onTap;

//   const EventNavBar({
//     super.key,
//     required this.pageIndex,
//     // required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: 16,
//         right: 16,
//         bottom: Platform.isAndroid ? 16 : 0,
//       ),
//       child: BottomAppBar(
//         elevation: 0.0,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             height: 60,
//             color: Color.fromRGBO(254, 149, 38, 0.7),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 navItem(
//                   Icons.home_filled,
//                   pageIndex == 3,
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => BlocProvider(
//                                 create: (context) => EventsOrganizerBloc(),
//                                 child: EventsOrganizerDashboard())));
//                   },
//                 ),
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.white, // Button background color
//                     shape: BoxShape.circle, // Makes the button circular
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       context.goNamed(RoutePath.tracker);
//                     },
//                     child: Center(
//                       child: Image.asset(
//                         'assets/images/Racing.png', // Path to your asset
//                         width: 35,
//                         height: 35,
//                       ),
//                     ),
//                   ),
//                 ),
//                 navItem(Icons.space_dashboard_rounded, pageIndex == 2,
//                     onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BlocProvider(
//                           create: (context) => EventMenuBloc(),
//                           child: EventMenu(),
//                         ),
//                       ));
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Icon(
//           icon,
//           color: selected ? Colors.white : Colors.white,
//           size: 30,
//         ),
//       ),
//     );
//   }
// }
