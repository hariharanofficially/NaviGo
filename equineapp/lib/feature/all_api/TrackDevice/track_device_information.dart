import 'dart:async';

import 'package:EquineApp/feature/all_api/TrackDevice/bloc/TDI_bloc.dart';
import 'package:EquineApp/feature/all_api/TrackDevice/bloc/TDI_event.dart';
import 'package:EquineApp/feature/all_api/TrackDevice/bloc/TDI_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/route/routes/route_path.dart';
import '../../common/FormCustomWidget/textform_field.dart';

class TrackDeviceInfoScreen extends StatefulWidget {
  @override
  _TrackDeviceInfoScreenState createState() => _TrackDeviceInfoScreenState();
}

class _TrackDeviceInfoScreenState extends State<TrackDeviceInfoScreen>
    with SingleTickerProviderStateMixin {
  bool isPassword(String input) =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$')
          .hasMatch(input);
  final trackerform = GlobalKey<FormState>();

  final trackDeviceIdcontroller = TextEditingController();
  final devicemacIdcontroller = TextEditingController();
  final heartRateSensoridcontroller = TextEditingController();
  final gpsSignalcontroller = TextEditingController();
  final censorVoltagecontroller = TextEditingController();
  final deviceVoltagecontroller = TextEditingController();
  final timerZonecontroller = TextEditingController();
  final dayLightcontroller = TextEditingController();
  final userIdcontroller = TextEditingController();
  final userDeviceIdcontroller = TextEditingController();

  bool _isLoading = false;
  bool _passwordvisible = true;
  String _userName = '';
  String _userEmail = '';
  String _password = '';
  String? _phoneNumber = '';
  String verificationID = "";
  bool isMatched = false;
  bool isPhno = false;
  bool isUser = false;
  String apiError = '';

  Future<void> _trySubmitForm() async {
    final bool? isValid = trackerform.currentState?.validate();
    if (isValid == true) {
      context.read<TrackDeviceInfoBloc>().add(SubmitForm());
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool isEmail(String input) => (RegExp(r'\S+@\S+\.\S+').hasMatch(input));
  bool isapierr = false;

  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
  int tabIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackDeviceInfoBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Icon(Icons.arrow_back_ios),
          title: Row(
            children: [
              SizedBox(width: 20),
              Text(
                'Tracker Device Information',
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Required Information',
                  style: GoogleFonts.karla(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: trackerform,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        hintText: 'Tracker Device ID',
                        controller: trackDeviceIdcontroller,
                        labelText: 'Tracker Device ID',
                      ),
                      CustomTextFormField(
                        hintText: 'Device Mac ID',
                        controller: devicemacIdcontroller,
                        labelText: 'Device Mac ID',
                      ),
                      CustomTextFormField(
                        hintText: 'Heart rate sensor ID',
                        controller: heartRateSensoridcontroller,
                        labelText: 'Heart rate sensor ID',
                      ),
                      CustomTextFormField(
                        hintText: 'Gps signal strength ',
                        controller: gpsSignalcontroller,
                        labelText: 'Gps signal strength',
                      ),
                      CustomTextFormField(
                        hintText: 'Censor voltage',
                        controller: censorVoltagecontroller,
                        labelText: 'Censor voltage',
                      ),
                      CustomTextFormField(
                        hintText: 'Device voltage',
                        controller: deviceVoltagecontroller,
                        labelText: 'Device voltage',
                      ),
                      CustomTextFormField(
                        hintText: 'Times Zone',
                        controller: timerZonecontroller,
                        labelText: 'Times Zone',
                      ),
                      CustomTextFormField(
                        hintText: 'Day light saving minutes',
                        controller: dayLightcontroller,
                        labelText: 'Day light saving minutes',
                      ),
                      CustomTextFormField(
                        hintText: 'User ID',
                        controller: userIdcontroller,
                        labelText: 'User ID',
                      ),
                      CustomTextFormField(
                        hintText: 'User Device ID',
                        controller: userDeviceIdcontroller,
                        labelText: 'User Device ID',
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom))
              ],
            ),
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomAppBar(
            color: Color.fromRGBO(139, 72, 223, 1),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Color.fromRGBO(139, 72, 223, 1),
              ),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 270,
                  child:
                      BlocConsumer<TrackDeviceInfoBloc, TrackDeviceInfoState>(
                    listener: (context, state) {
                      if (state is TrackDeviceInfoSuccess) {
                        context.goNamed(RoutePath.tracker);
                      } else if (state is TrackDeviceInfoFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is TrackDeviceInfoLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          _trySubmitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Add Tracker Information',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(33, 150, 243, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// class TrackDeviceInfoScreen extends StatefulWidget {
//   @override
//   _TrackDeviceInfoScreenState createState() => _TrackDeviceInfoScreenState();
// }

// class _TrackDeviceInfoScreenState extends State<TrackDeviceInfoScreen>
//     with SingleTickerProviderStateMixin {
//   bool isPassword(String input) =>
//       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$')
//           .hasMatch(input);
//   final trackerform = GlobalKey<FormState>();

//   final trackDeviceIdcontroller = TextEditingController();
//   final devicemacIdcontroller = TextEditingController();
//   final heartRateSensoridcontroller = TextEditingController();
//   final gpsSignalcontroller = TextEditingController();
//   final censorVoltagecontroller = TextEditingController();
//   final deviceVoltagecontroller = TextEditingController();
//   final timerZonecontroller = TextEditingController();
//   final dayLightcontroller = TextEditingController();
//   final userIdcontroller = TextEditingController();
//   final userDeviceIdcontroller = TextEditingController();

//   bool _isLoading = false;
//   bool _passwordvisible = true;
//   String _userName = '';
//   String _userEmail = '';
//   String _password = '';
//   String? _phoneNumber = '';
//   String verificationID = "";
//   bool isMatched = false;
//   bool isPhno = false;
//   bool isUser = false;
//   String apiError = '';

//   Future<void> _trySubmitForm() async {
//     final bool? isValid = trackerform.currentState?.validate();
//     context.goNamed(RoutePath.tracker);
//     if (isValid == true) {
//       setState(() {
//         _isLoading = true;
//       });
//     }
//   }

//   bool isNumeric(String s) {
//     if (s == null) {
//       return false;
//     }
//     return double.tryParse(s) != null;
//   }

//   bool isEmail(String input) => (RegExp(r'\S+@\S+\.\S+').hasMatch(input));
//   bool isapierr = false;

//   bool isPhone(String input) =>
//       RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
//           .hasMatch(input);
//   int tabIndex = 0;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     FocusManager.instance.primaryFocus?.unfocus();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: Icon(Icons.arrow_back_ios),
//         title: Row(
//           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SizedBox(
//               width: 20,
//             ),
//             Text(
//               'Tracker Device Information',
//               style: GoogleFonts.karla(
//                 textStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         reverse: true,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Required Information',
//                 style: GoogleFonts.karla(
//                   textStyle: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Form(
//                 key: trackerform,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     //Tracker Device ID
//                     CustomTextFormField(
//                         hintText: 'Tracker Device ID',
//                         controller: trackDeviceIdcontroller),
//                     //device Mac ID
//                     CustomTextFormField(
//                         hintText: 'Device Mac ID',
//                         controller: devicemacIdcontroller),
//                     //Heart rate sensor iD
//                     CustomTextFormField(
//                         hintText: 'Heart rate sensor iD',
//                         controller: heartRateSensoridcontroller),

//                     //Gps signal strength
//                     CustomTextFormField(
//                         hintText: 'Gps signal strength ',
//                         controller: gpsSignalcontroller),

//                     //Censor voltage
//                     CustomTextFormField(
//                         hintText: 'Censor voltage',
//                         controller: censorVoltagecontroller),

//                     //Device voltage
//                     CustomTextFormField(
//                         hintText: 'Device voltage',
//                         controller: deviceVoltagecontroller),

//                     //times Zone
//                     CustomTextFormField(
//                         hintText: 'Times Zone',
//                         controller: timerZonecontroller),

//                     //Day light saving minutes
//                     CustomTextFormField(
//                         hintText: 'Day light saving minutes',
//                         controller: dayLightcontroller),

//                     //User ID
//                     CustomTextFormField(
//                         hintText: 'User ID', controller: userIdcontroller),
//                     //user Device ID
//                     CustomTextFormField(
//                         hintText: 'User Device ID',
//                         controller: userDeviceIdcontroller),
//                   ],
//                 ),
//               ),
//               Padding(
//                   padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom))
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
//         child: BottomAppBar(
//           color: Color.fromRGBO(139, 72, 223, 1),
//           child: Container(
//             height: 100,
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(139, 72, 223, 1),
//             ),
//             child: Center(
//               child: SizedBox(
//                 height: 50,
//                 width: 270,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _trySubmitForm();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                   ),
//                   child: Text(
//                     'Add Tracker Information',
//                     style: GoogleFonts.karla(
//                       textStyle: TextStyle(
//                           color: Color.fromRGBO(33, 150, 243, 1),
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
