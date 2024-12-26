import 'package:EquineApp/feature/my-requests/view/my_requests_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
// import 'package:EquineApp/Registerpage.dart';
import 'package:polar/polar.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/google/google_login.dart';
import '../../../utils/constants/appreance_definition.dart' as ad;
import '../../my-requests/bloc/my_requests_bloc.dart';

class NavigitionWidget extends StatefulWidget {
  const NavigitionWidget({super.key});

  @override
  State<NavigitionWidget> createState() => _NavigitionState();
}

class _NavigitionState extends State<NavigitionWidget> {
  void _closeDrawer(BuildContext context) {
    Navigator.of(context).pop(); // Close the drawer
  }

  String userName = "";
  String emailAddress = "";
  String profileUrl = "";
  bool isVersionVisible = false;
  final polar = Polar();
  Logger logger = Logger();
  bool isEnglish = true; // Track language selection
  @override
  void initState() {
    super.initState();
    _setInitData();
    _loadSelectedTextSize();
    //_setemailAddress();
  }

  _loadSelectedTextSize() async {
    var buttonSize =
        await cacheRepo.getString(name: "textsize"); //?? ad.textSizes.medium;
    if (buttonSize.isEmpty) {
      buttonSize = ad.textSizes.medium;
    }
    setState(() {
      ad.buttonTextSize = buttonSize;
    });
  }

  _saveSelectedTextSize(String textSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.d(prefs.getKeys());
    cacheRepo.setString(name: "textsize", value: textSize);
  }

  void _setInitData() async {
    // textSizeType = await getTextSizeType();
    // setState(() async {
    userName = await cacheRepo.getString(name: 'userName');
    if (userName.length > 20) {
      userName = userName.substring(0, 20) + "...";
    }
    profileUrl = await cacheRepo.getString(name: 'profileUrl'); //?? "";
    if (profileUrl.isEmpty) {
      profileUrl = "";
    }
    // emailAddress = await cacheRepo.getString(name: 'emailAddress'); //?? "";
    // if (emailAddress.isEmpty) {
    //   emailAddress = "";
    // }
    // });
  }

  // void _setemailAddress() async {
  //   setState(() async {
  //     emailAddress = await cacheRepo.getString(name: 'emailAddress'); //?? "";
  //     if (emailAddress.isEmpty) {
  //       emailAddress = "";
  //     }
  //   });
  // }

  Future<void> _resetFlags() async {
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    //final isDarkMode = themeMode == ThemeModeType.dark;
    //final bool isDarkMode = ThemeMode.dark;
    bool isDarkMode = false;
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Container(
                  child: Row(
                    children: [
                      if (profileUrl.isNotEmpty)
                        CircleAvatar(
                          //radius: 50,
                          backgroundImage: NetworkImage(profileUrl),
                        ),
                      if (profileUrl.isEmpty)
                        CircleAvatar(
                          backgroundColor: Colors
                              .purple, // Change the background color of the CircleAvatar
                          // radius: 50,
                          // backgroundImage:
                          //     NetworkImage("https://via.placeholder.com/35x35"),
                          child: Icon(
                            Icons.person,
                            color: Colors.white, // Set icon color to white
                          ),
                        ),
                      SizedBox(
                        width: 10,
                      ), // Add spacing between the icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                              color: Color(0xFF8B48DF),
                              fontSize:
                                  ad.getTextSize14Value(ad.buttonTextSize),
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          Opacity(
                            opacity: 0.50,
                            child: Text(
                              emailAddress,
                              style: TextStyle(
                                color: Color(0xFF8B48DF),
                                fontSize:
                                    ad.getTextSize10Value(ad.buttonTextSize),
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                otherAccountsPictures: [
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Color(0xFF8B48DF),
                    onPressed: () {
                      _closeDrawer(
                        context,
                      ); // Close the drawer when the close icon is tapped
                    },
                  ),
                ],
                decoration: BoxDecoration(
                  color: Color.fromARGB(238, 238, 249,
                      255), // Change the background color of the header
                ),
                accountEmail: null,
              ),
              //Divider(),
              ListTile(
                leading: ImageIcon(
                  AssetImage("assets/images/slide_instruct.png"),
                  color: Color(0xFF8B48DF),
                  size: 24,
                ),
                title: Text(
                  'Instruction',
                  style: TextStyle(
                    color: Color(0xFF8B48DF),
                    fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                onTap: () {
                  // Add your instructions action here
                },
              ),
              ListTile(
                leading: ImageIcon(
                  AssetImage("assets/images/slide_update.png"),
                  color: Color(0xFF8B48DF),
                  size: 24,
                ),
                title: Text(
                  'Update',
                  style: TextStyle(
                    color: Color(0xFF8B48DF),
                    fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                onTap: () {
                  // Add your updates action here
                },
              ),
              ListTile(
                leading: ImageIcon(
                  AssetImage("assets/images/myapproved.png"),
                  color: Color(0xFF8B48DF),
                  size: 24,
                ),
                title: Text(
                  'My Requests',
                  style: TextStyle(
                    color: Color(0xFF8B48DF),
                    fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => MyRequestsBloc(),
                                child: const MyRequest(),
                              )));
                  // Add your updates action here
                },
              ),
              ListTile(
                leading: ImageIcon(
                  AssetImage("assets/images/slide_version.png"),
                  color: Color(0xFF8B48DF),
                  size: 24,
                ),
                title: Text(
                  'Version',
                  style: TextStyle(
                    color: Color(0xFF8B48DF),
                    fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                subtitle: isVersionVisible
                    ? Text('1.0.0', style: TextStyle(color: Colors.white))
                    : null,
                onTap: () {
                  setState(() {
                    isVersionVisible = !isVersionVisible;
                  });
                },
                // subtitle: Text('1.0.0'),
              ),

              ExpansionTile(
                leading: ImageIcon(
                  AssetImage("assets/images/slide_settings.png"),
                  color: Color(0xFF8B48DF),
                  size: 24,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Color(0xFF8B48DF),
                    fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.brightness_medium,
                      color: Color(0xFF8B48DF),
                    ),
                    title: Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: Color(0xFF8B48DF),
                        fontWeight: FontWeight.w700,
                        fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                      ),
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        // Provider.of<ThemeProviderNotifier>(context, listen: false)
                        //     .toggleThemeMode();
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.text_fields,
                      color: Color(0xFF8B48DF),
                    ),
                    title: Text(
                      'Text Size',
                      style: TextStyle(
                        color: Color(0xFF8B48DF),
                        fontWeight: FontWeight.w700,
                        fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                      ),
                    ),
                    trailing: DropdownButton<String>(
                      value: ad
                          .buttonTextSize, // Ensure value reflects current selected size
                      items: [
                        DropdownMenuItem(
                          value: ad.textSizes.medium,
                          child: Text(
                            'Medium',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: ad.textSizes.large,
                          child: Text(
                            'Large',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _saveSelectedTextSize(newValue);
                          setState(() {
                            ad.buttonTextSize =
                                newValue; // Update the buttonTextSize correctly
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: isEnglish
                        ? Image.asset(
                            'assets/images/english_flag.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/arabic_flag.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                    title: Text(
                      'Language',
                      style: TextStyle(
                        color: Color(0xFF8B48DF),
                        fontWeight: FontWeight.w700,
                        fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                      ),
                    ),
                    trailing: DropdownButton<String>(
                      value: isEnglish ? 'English' : 'Arabic',
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                      ),
                      dropdownColor: Color(0xFF8B48DF),
                      onChanged: (String? newValue) {
                        setState(() {
                          isEnglish = newValue == 'English';
                          // Implement language change logic here if needed
                        });
                      },
                      items: <String>['English', 'Arabic']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: ImageIcon(
                  AssetImage("assets/images/subscripition.png"),
                  color: Color(0xFF8B48DF),
                  size: 30,
                ),
                title: Text(
                  'Subscription Plan',
                  style: TextStyle(
                    color: Color(0xFF8B48DF),
                    fontSize: ad.getTextSize13Value(ad.buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                onTap: () async {
                  await _resetFlags();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Signin()),
                  // );
                  context.goNamed(RoutePath.plan);
                  // Add your log out action here
                },
              ),
              // ListTile(
              //   title: Text(
              //     'ALL DATA',
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
              //     context.goNamed(RoutePath.postapi);
              //   },
              // ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Divider(
                          color: Colors
                              .grey, // You can customize the color of the divider
                          thickness:
                              3, // You can adjust the thickness of the divider
                          indent: 50, // You can set the left indentation
                          endIndent: 90, // You can set the right indentation
                        ),
                        ListTile(
                          leading: ImageIcon(
                            AssetImage("assets/images/slide_logout.png"),
                            color: Color(0xFF8B48DF),
                            size: 30,
                          ),
                          title: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Color(0xFF8B48DF),
                              fontSize:
                                  ad.getTextSize13Value(ad.buttonTextSize),
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          onTap: () async {
                            await _resetFlags();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Signin()),
                            // );
                            context.goNamed(RoutePath.signin);
                            // Add your log out action here
                          },
                        ),
                        ListTile(
                          leading: ImageIcon(
                            AssetImage("assets/images/slide_support.png"),
                            color: Color(0xFF8B48DF),
                            size: 30,
                          ),
                          title: Text(
                            'Contact support',
                            style: TextStyle(
                              color: Color(0xFF8B48DF),
                              fontSize:
                                  ad.getTextSize13Value(ad.buttonTextSize),
                              fontFamily: 'Kara',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          onTap: () {
                            // Add your contact support action here
                          },
                        ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}
