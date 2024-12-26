import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../utils/constants/appreance_definition.dart';
// import 'package:EquineApp/common/Theme.dart';
// import 'package:EquineApp/dashboard/Tracker.dart';

// ignore: must_be_immutable
class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  CustomAppBarWidget({super.key}); // Initialize with a default value
  String buttonTextSize = 'Medium';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    // final isDarkMode = themeMode == ThemeModeType.dark;
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            context.goNamed(RoutePath.tracker);
          },
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
      title: Center(
        child: Text(
          'NAVI GO',
          style: TextStyle(
            //color: isDarkMode ? Colors.white : Colors.black,
            fontSize: getTextSize20Value(buttonTextSize),
            fontFamily: 'Nexa Bold',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ),
      // backgroundColor: isDarkMode
      //     ? Colors.black
      //     : Colors.white, // Set app bar color based on theme
      // iconTheme: IconThemeData(
      //   color: isDarkMode ? Colors.white : Colors.black,
      // ),
      centerTitle: true, // Center the title horizontally
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
