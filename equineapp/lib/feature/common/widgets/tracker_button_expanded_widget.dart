import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants/appreance_definition.dart';
// import 'package:EquineApp/common/Theme.dart';
// import 'package:EquineApp/dashboard/Tracker.dart';

class TrackerButtonExpandedWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String buttonTextSize = 'Medium';
  TrackerButtonExpandedWidget({super.key}); // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    // final isDarkMode = themeMode == ThemeModeType.dark;
    return Column(
      children: [
        
        Container(
          width: 180,
          height: 69,
          decoration: ShapeDecoration(
            color: const Color(0xFF8B48DF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Container(
                width: 58,
                height: 56,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Color(0xFF8B48DF)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/tracker.png', // Replace with the path to your image asset
                    width: 40, // Adjust the width of the image
                    height: 30, // Adjust the height of the image
                  ),
                ),
              ),
              Padding(
  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getTextSize18Value(buttonTextSize),
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w700,
                      height: 0.15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
