// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/appreance_definition.dart';
// import '../../../utils/theme/Theme.dart';
import '../bloc/tracker_steps_bloc.dart';

void registerDevicePopupDialog(BuildContext buildContext) {
  // Logger logger = new Logger();
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController deviceIdController = TextEditingController();
  final TextEditingController deviceMacController = TextEditingController();

  showDialog(
    context: buildContext,
    builder: (BuildContext context) {
      // final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
      //final isDarkMode = themeMode == ThemeModeType.dark;
      // return BlocConsumer<TrackerStepsBloc, TrackerStepsState>(
      //     listener: (content, state) {},
      //     builder: (content, state) {
      return AlertDialog(
        scrollable: true,
        title: Text(
          'Register Device',
          style: TextStyle(
            //  color: isDarkMode ? Colors.white : Colors.black,
            fontSize: getTextSize14Value(buttonTextSize),
            fontFamily: 'Karla',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
        content: Row(
          children: [
            // Text on the left
            Container(
              width: 80, // Adjust the width as needed

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: 0.50,
                    child: Text(
                      'Device name',
                      style: TextStyle(
                        //    color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: getTextSize12Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 35), // Add vertical spacing
                  Opacity(
                    opacity: 0.50,
                    child: Text(
                      'Device ID',
                      style: TextStyle(
                        //    color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: getTextSize12Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),

                  SizedBox(height: 35), // Add vertical spacing
                  Opacity(
                    opacity: 0.50,
                    child: Text(
                      'Device Mac',
                      style: TextStyle(
                        //    color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: getTextSize12Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: TextFormField(
                          controller: deviceNameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Add vertical spacing
                      SizedBox(
                        height: 30,
                        child: TextFormField(
                          controller: deviceIdController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Add vertical spacing
                      SizedBox(
                        height: 30,
                        child: TextFormField(
                          controller: deviceMacController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF418DFF),
                      // Button's background color
                      foregroundColor: Colors.white,
                      // Button's text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text("Submit"),
                    onPressed: () {
                      buildContext.read<TrackerStepsBloc>().add(
                          TrackerStepsRegisterDeviceEvent(
                              name: deviceNameController.text,
                              macId: deviceMacController.text,
                              deviceId: deviceIdController.text));
                      // setState(() {
                      //   isRegisteringDevice = false;
                      // });
                      Navigator.of(context).pop();
                    }),
                SizedBox(width: 16), // Add spacing between buttons
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      // color:
                      //     isDarkMode ? Colors.white : Color(0xFF686868),
                      fontSize: getTextSize12Value(buttonTextSize),
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // setState(() {
                    //   isRegisteringDevice = false;
                    // });
                    // Your code
                  },
                ),
              ],
            ),
          ),
        ],
      );
      //    });
    },
  );
}
