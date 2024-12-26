import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:EquineApp/feature/SwitchTenant/bloc/switchtenant_bloc.dart';
import 'package:EquineApp/feature/SwitchTenant/view/switchtenant_view.dart';
import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_bloc.dart';
import 'package:EquineApp/feature/generate_qr/view/generate_qr_view.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:polar/polar.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/google/google_login.dart';
import '../../ScanQr/bloc/scanqrcode_bloc.dart';
import '../../ScanQr/view/scanqrcode_view.dart';
import '../../../utils/constants/appreance_definition.dart' as ad;

class SharecodePopup extends StatelessWidget {
  final bool showGenerateOnly;
  final bool showlogin;

  const SharecodePopup({
    Key? key,
    required this.showGenerateOnly,
    required this.showlogin,
  }) : super(key: key);

  Future<void> _resetFlags() async {
    final polar = Polar();
    Logger logger = Logger();
    try {
      await polar.disconnectFromDevice(
          await cacheRepo.getString(name: 'myHeartRateCensorId'));
    } catch (e) {
      logger.d(e.toString());
    }
    if (cacheRepo.getString(name: 'loginType') == 'google') {
      await GoogleLoginApiService.signOut();
    }
    if (cacheRepo.getString(name: 'loginType') == 'facebook') {
      await FacebookAuth.instance.logOut();
    }
    await cacheRepo.clear();
    cacheRepo.setBoolean(name: 'isLoggedIn', value: false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      // title: Container(
      //   width: 113, // Set the width to 113px
      //   height: 20, // Set the height to 47px
      //   child: const Text(
      //     '',
      //     style: TextStyle(
      //       fontFamily: 'Karla',
      //       fontSize: 18, // Set the font size to 40px
      //       //fontWeight: FontWeight.w400, // Set font weight to 400
      //       height: 46.76 / 40, // Line-height calculation
      //       color: Colors.black, // Set the text color to black
      //     ),
      //     textAlign: TextAlign.center, // Align text to the left
      //   ),
      // ),
      actions: [
        if (!showGenerateOnly) ...[
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/Share.png',
                  width: 30, // Reduced image width
                  height: 30, // Reduced image height
                ),
              ),
              Container(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE9526),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (context) => QrBloc(),
                                child: GenerateQr())));
                    //Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Share Code',
                    style: TextStyle(
                      color: Color(0xFF2B0956),
                      fontFamily: 'Karla',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 23.38 / 20, // Line-height calculation
                    ),
                    textAlign: TextAlign.left, // Align text to the left
                  ),
                ),
              ),
            ],
          ),
        ],
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/switch.png',
                width: 30, // Reduced image width
                height: 30, // Reduced image height
              ),
            ),
            Container(
              width: 180,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE9526),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                              create: (context) => SwitchtenantBloc(),
                              child: Switchtenant())));
                  //Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Switch Tenants',
                  style: TextStyle(
                    color: Color(0xFF2B0956),
                    fontFamily: 'Karla',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 23.38 / 20, // Line-height calculation
                  ),
                  textAlign: TextAlign.left, // Align text to the left
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/qrcode.png',
                width: 30, // Reduced image width
                height: 30, // Reduced image height
              ),
            ),
            Container(
              width: 180,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE9526),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                              create: (context) => QRScannerBloc(),
                              child: Scanqrcode())));

                  //Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Scan QR',
                  style: TextStyle(
                    color: Color(0xFF2B0956),
                    fontFamily: 'Karla',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 23.38 / 20, // Line-height calculation
                  ),
                  textAlign: TextAlign.left, // Align text to the left
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        if (!showlogin) ...[
          Row(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/slide_logout.png',
                  color: Color(0xFFD8A353),
                  width: 30, // Reduced image width
                  height: 30, // Reduced image height
                ),
              ),
              Container(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE9526),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  onPressed: () async {
                    await _resetFlags();
                    context.goNamed(RoutePath.signin);
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFF2B0956),
                      fontFamily: 'Karla',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 23.38 / 20, // Line-height calculation
                    ),
                    textAlign: TextAlign.left, // Align text to the left
                  ),
                ),
              ),
            ],
          ),
          // ListTile(
          //   leading: ImageIcon(
          //     AssetImage("assets/images/slide_logout.png"),
          //     color: Color(0xFF8B48DF),
          //     size: 30,
          //   ),
          //   title: Text(
          //     'Log Out',
          //     style: TextStyle(
          //       color: Color(0xFF8B48DF),
          //       fontSize: ad.getTextSize13Value(ad.buttonTextSize),
          //       fontFamily: 'Karla',
          //       fontWeight: FontWeight.w700,
          //       height: 0,
          //     ),
          //   ),
          //   onTap: () async {
          //     await _resetFlags();
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => Signin()),
          //     // );
          //     context.goNamed(RoutePath.signin);
          //     // Add your log out action here
          //   },
          // ),
        ],
      ],
    );
  }
}
