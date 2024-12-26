import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

// import 'package:provider/provider.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../utils/constants/appreance_definition.dart';
// import '../../../utils/theme/Theme.dart';
import '../bloc/singup_bloc.dart';

class SignupOptionsView extends StatelessWidget {
  SignupOptionsView({Key? key}) : super(key: key);
  final Logger logger = Logger();
  final bool passToggle = true;

  @override
  Widget build(BuildContext buildContext) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeMode = Provider.of<ThemeProviderNotifier>(buildContext).themeMode;
    // final isDarkMode = themeMode == ThemeModeType.dark;

    return BlocConsumer<SignupBloc, SignupState>(
        listener: (content, state) async {
      if (state is SignupSuccessState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignUp successful'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
        buildContext.goNamed(RoutePath.signin);
      } else if (state is SignupWithGoogleBackendFailedState ||
          state is SignupWithFacebookBackendFailedState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignUp failed'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
      } else if (state is SignupWithGoogleFailedState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('Google Signin failed'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
      } else if (state is SignupWithFacebookFailedState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('Facebook SignUp failed'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
      }
    }, builder: (content, state) {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 100,
                height: 100,
              ),
              Text(
                'NAVI GO',
                style: TextStyle(
                  //color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: getTextSize48Value(buttonTextSize),
                  fontFamily: 'Nexa Bold',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 20,
              ),
              // mail button
              OutlinedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Signup_page()),
                  // ); // Handle button 1 action
                  buildContext
                      .read<SignupBloc>()
                      .add(SignupWithEmailViewEvent());
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 35),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                    child: Image(
                        image: AssetImage("assets/images/signup_mail.png"),
                        width: 25,
                        height: 25,
                        fit: BoxFit.scaleDown,
                        alignment: FractionalOffset.center),
                  ),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(330.0, 60.0), // Set the desired width and height
                  ),
                  // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //   RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  // ),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.yellow, // Change the border color here
                      width: 2.0, // Change the border width here
                    ),
                  ),

                  elevation: MaterialStateProperty.all<double>(
                      10.0), // Shadow elevation
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // Button background color
                  shadowColor: MaterialStateProperty.all<Color>(
                      Colors.grey), // Shadow color
                ),
                label: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      'Sign Up with Email ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getTextSize14Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                        height: 0.26,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // gmail button
              OutlinedButton.icon(
                onPressed: () async {
                  //await _validateAndSubmitForGoogle();
                  buildContext.read<SignupBloc>().add(SignupWithGoogleEvent());
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                    child: Image(
                        image: AssetImage("assets/images/signup_gmail.png"),
                        width: 25,
                        height: 25,
                        fit: BoxFit.scaleDown,
                        alignment: FractionalOffset.center),
                  ),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(330.0, 60.0), // Set the desired width and height
                  ),
                  // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //   RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  // ),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.yellow, // Change the border color here
                      width: 2.0, // Change the border width here
                    ),
                  ),

                  elevation: MaterialStateProperty.all<double>(
                      10.0), // Shadow elevation
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // Button background color
                  shadowColor: MaterialStateProperty.all<Color>(
                      Colors.grey), // Shadow color
                ),
                label: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      '    Sign Up with Google',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getTextSize14Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                        height: 0.26,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // facebook button
              OutlinedButton.icon(
                onPressed: () async {
                  //await _validateAndSubmitForFacebook();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SignupPage()),
                  // ); // Handle button 1 action
                  buildContext
                      .read<SignupBloc>()
                      .add(SignupWithFacebookEvent());
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                    child: Image(
                        image: AssetImage("assets/images/signup_facebook.png"),
                        width: 25,
                        height: 25,
                        fit: BoxFit.scaleDown,
                        alignment: FractionalOffset.center),
                  ),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(330.0, 60.0), // Set the desired width and height
                  ),
                  // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //   RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  // ),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.yellow, // Change the border color here
                      width: 2.0, // Change the border width here
                    ),
                  ),

                  elevation: MaterialStateProperty.all<double>(
                      10.0), // Shadow elevation
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // Button background color
                  shadowColor: MaterialStateProperty.all<Color>(
                      Colors.grey), // Shadow color
                ),
                label: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      '        Sign Up with Facebook',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getTextSize14Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                        height: 0.26,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 50,
              ),
              Text(
                'Already have an account?',
                style: TextStyle(
                  //color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: getTextSize16Value(buttonTextSize),
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.w700,
                  height: 0.35,
                ),
              ),
              SizedBox(
                height: 70,
                width: 170,
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 20, bottom: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Signin()),
                      // );
                      buildContext.goNamed(RoutePath.signin);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Customize the border radius here
                      ),
                      backgroundColor: Color((0xFF8B48DF)), // Background color
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getTextSize16Value(buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w700,
                            height: 0.30,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
