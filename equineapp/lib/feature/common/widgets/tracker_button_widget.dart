import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:EquineApp/common/Theme.dart';
// import 'package:EquineApp/dashboard/Tracker.dart';

class TrackerButtonWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String buttonTextSize = 'Medium';
  TrackerButtonWidget({super.key}); // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    // final isDarkMode = themeMode == ThemeModeType.dark;
    return Column(
      children: [
        
        Container(
          width: 69,
          height: 69,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Color(0xFF8B48DF)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/tracker.png', // Replace with the path to your image asset
              width: 40, // Adjust the width of the image
              height: 40, // Adjust the height of the image
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
