import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

// import 'package:provider/provider.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../utils/constants/appreance_definition.dart';
// import '../../../utils/theme/Theme.dart';
import '../bloc/signin_bloc.dart';
import 'signin_forgetpassword.dart';

// ignore: must_be_immutable
class SigninView extends StatelessWidget {
  SigninView({Key? key}) : super(key: key);
  final Logger logger = Logger();
  bool passToggle = true;
  final _formfield = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();

  @override
  Widget build(BuildContext buildContext) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeMode = Provider.of<ThemeProviderNotifier>(buildContext).themeMode;
    // final isDarkMode = themeMode == ThemeModeType.dark;

    return BlocConsumer<SigninBloc, SigninState>(listener: (content, state) async {
      if (state is SigninPasswordShowState) {
        this.passToggle = state.showPasswordIcon;
      } else if (state is SigninSuccessState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignIn successful'),
          ),
        );
        // Wait briefly for the user to see the message
      await Future.delayed(Duration(seconds: 2));
        buildContext.goNamed(RoutePath.home);
      } else if (state is SigninSuccessEventState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignIn successful'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
        buildContext.goNamed(RoutePath.eventorganizerdashboard);
      } else if (state is SigninSuccessStableState) {
      
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignIn successful'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
        buildContext.goNamed(RoutePath.singlestabledashboard);
      } else if (state is SigninSuccessNoTenantState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignIn successful'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
        buildContext.goNamed(RoutePath.plan);
      } else if (state is SigninWithGoogleBackendFailedState ||
          state is SigninWithFacebookBackendFailedState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignIn failed'),
          ),
        );
      } else if (state is SigninWithGoogleFailedState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('Google Signin failed'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
      } else if (state is SigninWithFacebookFailedState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('Facebook Signin failed'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
      }
    }, builder: (content, state) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: _formfield,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
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
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.bold,
                              fontSize: getTextSize24Value(buttonTextSize),
                              color: Color(0xFF8B48DF)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                            fontSize: getTextSize20Value(buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.w100,
                            color: Color(0xFF8B48DF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Username";
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: passToggle,
                    keyboardType: TextInputType.emailAddress,
                    controller: passcontroller,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          fontSize: getTextSize20Value(buttonTextSize),
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.w100,
                          color: Color(0xFF8B48DF)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      suffix: InkWell(
                        onTap: () {
                          buildContext
                              .read<SigninBloc>()
                              .add(SigninPasswordShowEvent());
                        },
                        child: Icon(passToggle
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      } /*else if (passcontroller.text.length < 6) {
                        return "Password Should be more than 6 characters";
                      }*/
                    },
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              buildContext,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                      create: (context) => SigninBloc(),
                                      child: ForgetPassword())),
                            );
                          },
                          child: Text('Forgot Password ?'))),
                  if (state is SigninFailedState)
                    const SizedBox(
                      height: 20,
                    ),
                  if (state is SigninFailedState)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),

                  Container(
                    width: 149,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formfield.currentState!.validate()) {
                          //if (emailcontroller != null) {
                          if (emailcontroller != Null) {
                            buildContext.read<SigninBloc>().add(
                                SigninSubmitEvent(
                                    username: emailcontroller.text,
                                    password: passcontroller.text));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8B48DF),
                        foregroundColor: Color(0xFF8B48DF),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(
                        //       10.0)), // Adjust the radius as needed
                        // ),
                      ),
                      child: state is SigninSubmittingState
                          ? CircularProgressIndicator(
                              color: Colors.blue,
                            )
                          : Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'Karla',
                                fontSize: getTextSize15Value(buttonTextSize),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  OutlinedButton.icon(
                    onPressed: () async {
                      // await _validateAndSubmitGoogle();
                      buildContext
                          .read<SigninBloc>()
                          .add(SigninWithGoogleEvent());
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 35),
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
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                          color: Colors.yellow, // Change the border color here
                          width: 2.0, // Change the border width here
                        ),
                      ),
                      // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0))),

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
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text(
                          'Login with Google',
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
                      //  await _validateAndSubmitFacebook();
                      buildContext
                          .read<SigninBloc>()
                          .add(SigninWithFacebookEvent());
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                        child: Image(
                            image:
                                AssetImage("assets/images/signup_facebook.png"),
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
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                          color: Colors.yellow, // Change the border color here
                          width: 2.0, // Change the border width here
                        ),
                      ),
                      // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0))),
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
                          'Login with Facebook',
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
                    height: 40,
                  ),
                  TextButton(
                    child: Text(
                      'Create New Account ?',
                      style: TextStyle(
                        color: Color(0xFF8B48DF),
                        fontSize: getTextSize18Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w700,
                        height: 0.35,
                      ),
                    ),
                    onPressed: () {
                      buildContext.goNamed(RoutePath.signup);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
