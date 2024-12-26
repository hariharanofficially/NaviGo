// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';

// import '../../../all_api/TrackDevice/track_device_information.dart';
// import '../../../feature/common/widgets/navigation_widget.dart';
// import '../../../feature/header/app_bar.dart';
// import '../../../feature/nav_bar/nav_bar.dart';
// import '../../../utils/constants/icons.dart';
// import '../../Menu/singlestable_menu.dart';
// import '../Event_Oraganizer/EventWidget.dart';



// class MultiStableDashboard extends StatefulWidget {
//   const MultiStableDashboard({super.key});

//   @override
//   State<MultiStableDashboard> createState() => _MultiStableDashboardState();
// }

// class _MultiStableDashboardState extends State<MultiStableDashboard> {

//   int selectedTab = 0;



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       endDrawer: const NavigitionWidget(),
//       body:

//       SingleChildScrollView(
//         child: Container(

//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10,),

//                 //stable
//                 FadeInUp(
//                   duration: Duration(milliseconds: 1000),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10.0),
//                     child: Container(
//                       height: 115,
//                       decoration: BoxDecoration(
//                         color: Color(0xffFDD9A3),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                             offset: Offset(0, 3), // changes position of shadow
//                           ),
//                         ],
//                       ),
//                       child:   Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(

//                                   children: [
//                                     Text(
//                                       'Stables',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),
//                                     SizedBox(width: 15,),
//                                     Icon(
//                                       Icons.add_circle_outline_outlined,
//                                       color: Color.fromRGBO(234, 146, 53, 1),
//                                       size: 22,
//                                     ),
//                                   ],

//                                 ),

//                                 Iconify(
//                                   moreHorizondal,
//                                   color: Color.fromRGBO(234, 146, 53, 1),
//                                   size: 28,
//                                 )
//                               ],
//                             ),
//                             SizedBox(height: 5,),

//                             Column(
//                               //mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   textAlign: TextAlign.left,
//                                   'Al - Maghaweer Stables',style: GoogleFonts.karla(
//                                   textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
//                                 ),
//                                 ),
//                                 Text(
//                                   textAlign: TextAlign.left,
//                                   'MSM Stables',style: GoogleFonts.karla(
//                                   textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
//                                 ),
//                                 ),
//                               ],
//                             ),

//                             Align(
//                               alignment: Alignment.bottomRight,
//                               child: Text(
//                                 textAlign: TextAlign.right,
//                                 'Tap to view more',style: GoogleFonts.karla(
//                                 textStyle: TextStyle( color: Color.fromRGBO(234, 146, 53, 1), fontSize: 13, fontWeight: FontWeight.w400),
//                               ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 //Horses
//                 FadeInUp(
//                   duration: Duration(milliseconds: 1000),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 20.0),
//                     child: Container(
//                       height: 160,
//                       decoration: BoxDecoration(
//                         color: Color.fromRGBO(208, 231, 249, 1),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                             offset: Offset(0, 3), // changes position of shadow
//                           ),
//                         ],
//                       ),
//                       child:   Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 15),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(

//                                   children: [
//                                     Text(
//                                       'Horses',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),
//                                     SizedBox(width: 15,),
//                                     Icon(
//                                       Icons.add_circle_outline_outlined,
//                                       color: Color.fromRGBO(139, 72, 223, 0.5),
//                                       size: 22,
//                                     ),
//                                   ],

//                                 ),

//                                 Iconify(
//                                   moreHorizondal,
//                                   color: Color.fromRGBO(139, 72, 223, 1),
//                                   size: 28,
//                                 )
//                               ],
//                             ),
//                             SizedBox(height: 15),
//                             Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       radius: 10,
//                                       //Text
//                                     ),
//                                     SizedBox(width: 12,),
//                                     Text(
//                                       'Antico Oriente',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),


//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       radius: 10,
//                                       //Text
//                                     ),
//                                     SizedBox(width: 12,),
//                                     Text(
//                                       'Gadjette Teoulere',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),


//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       radius: 10,
//                                       //Text
//                                     ),
//                                     SizedBox(width: 12,),
//                                     Text(
//                                       'Shardell Nikayla',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),


//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: Text(
//                                     textAlign: TextAlign.right,
//                                     'Total Horses - 20/30',style: GoogleFonts.karla(
//                                     textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
//                                   ),
//                                   ),
//                                 ),

//                               ],

//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 //riders
//                 FadeInUp(
//                   duration: Duration(milliseconds: 1000),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10.0),
//                     child: Container(
//                       height: 140,
//                       decoration: BoxDecoration(
//                         color: Color.fromRGBO(217, 217, 217, 1),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                             offset: Offset(0, 3), // changes position of shadow
//                           ),
//                         ],
//                       ),
//                       child:   Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 15),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(

//                                   children: [
//                                     Text(
//                                       'Riders',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),
//                                     SizedBox(width: 15,),
//                                     Icon(
//                                       Icons.add_circle_outline_outlined,
//                                       color: Color.fromRGBO(139, 72, 223, 0.5),
//                                       size: 22,
//                                     ),
//                                   ],

//                                 ),

//                                 Iconify(
//                                   moreHorizondal,
//                                   color: Color.fromRGBO(139, 72, 223, 1),
//                                   size: 28,
//                                 )
//                               ],
//                             ),
//                             SizedBox(height: 15),
//                             Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       radius: 10,
//                                       //Text
//                                     ),
//                                     SizedBox(width: 12,),
//                                     Text(
//                                       'Antico Oriente',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),


//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       radius: 10,
//                                       //Text
//                                     ),
//                                     SizedBox(width: 12,),
//                                     Text(
//                                       'Gadjette Teoulere',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),


//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       radius: 10,
//                                       //Text
//                                     ),
//                                     SizedBox(width: 12,),
//                                     Text(
//                                       'Shardell Nikayla',style: GoogleFonts.karla(
//                                       textStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
//                                     ),
//                                     ),


//                                   ],
//                                 ),
//                                 SizedBox(height: 8),


//                               ],

//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 //events
//                 SizedBox(height: 10,),

//                 EventWidgetList()

//               ],


//             ),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(top: 80),
//         height: 64,
//         width: 64,
//         child: FloatingActionButton(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackDeviceInfoScreen())),
//             shape: RoundedRectangleBorder(
//               side: const BorderSide(width: 1.5,  color:Color.fromRGBO(254, 149, 38, 0.7),),
//               borderRadius: BorderRadius.circular(100),
//             ),
//             child:Image.asset('assets/images/Racing.png')
//         ),
//       ),
//       bottomNavigationBar: NavBar(
//         pageIndex: selectedTab,
//         onTap: (index) {

//           if (index == 1) {

//             showGeneralDialog(
//               context: context,
//               barrierColor: Colors.transparent,
//               barrierDismissible: true,
//               barrierLabel: 'Label',
//               pageBuilder: (_, __, ___) {
//                 return Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Container(
//                     height: 90,
//                     margin: EdgeInsets.only(bottom: 90, left: 80),
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(251, 241, 241, 1),
//                       border: Border.all(color: Colors.grey, width: 1),
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                           offset: Offset(0, 3), // changes position of shadow
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [

//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 6.0, horizontal: 15),
//                           child: Text(
//                             'Add Stables',
//                             style: GoogleFonts.karla(
//                               textStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   decoration: TextDecoration.none
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 6.0, horizontal: 15),
//                           child: Text(
//                             'Add Horses',
//                             style: GoogleFonts.karla(
//                               textStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   decoration: TextDecoration.none
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 6.0, horizontal: 15),
//                           child: Text(
//                             'Add Riders',
//                             style: GoogleFonts.karla(
//                               textStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   decoration: TextDecoration.none
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );

//             //Navigator.push(context, MaterialPageRoute(builder: (context)=>PopoverExample()));
//           }
//           else if(index==0){
//             print('zero index');
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>SingeleStableMenu()));
//           }

//         },
//       ),
//     );
//   }
// }

// class TabPage extends StatelessWidget {
//   final int tab;

//   const TabPage({Key? key, required this.tab}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Tab $tab')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Tab $tab'),

//           ],
//         ),
//       ),
//     );
//   }
// }


