import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../../app/route/routes/route_path.dart';
import '../../../utils/constants/appreance_definition.dart';
// import 'package:EquineApp/common/Theme.dart';
// import 'package:EquineApp/dashboard/Tracker.dart';

class DashboardButtonExpandedWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String buttonTextSize = 'Medium';
  const DashboardButtonExpandedWidget(
      {super.key}); // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    // final isDarkMode = themeMode == ThemeModeType.dark;
    return Row(
      children: [
        // Back Icon inside a yellow circle
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD8A353),

            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        // Calendar Icon inside a yellow circle outside of the button
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
               color: Color(0xFFD8A353),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
          ),
        ), SizedBox(
                width: 15,
              ),
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
                    'assets/images/Dashboard.png', // Replace with the path to your image asset
                    width: 40, // Adjust the width of the image
                    height: 30, // Adjust the height of the image
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Dashboard',
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
