// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/models/singup_model.dart';
import '../../../utils/constants/appreance_definition.dart';
// import '../../signin/bloc/signin_bloc.dart';
import '../bloc/singup_bloc.dart';

// ignore: must_be_immutable
class SingupWithEmail extends StatelessWidget {
  SingupWithEmail({Key? key}) : super(key: key);

  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  @override
  Widget build(BuildContext buildContext) {
    return BlocConsumer<SignupBloc, SignupState>(listener: (content, state) async{
      if (state is SignupSuccessState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignUp successful'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
        buildContext.goNamed(RoutePath.signin);
      } else if (state is SigninWithEmailFailedState) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          const SnackBar(
            content: Text('SignUp failed'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
      }
    }, builder: (content, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF8B48DF),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Register New Account',
            style: TextStyle(
              fontFamily: 'Karla',
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    controller: firstnameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                          fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                      suffixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    //validator: _validateusername,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    controller: lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(
                          fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                      suffixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    //validator: _validate,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      labelStyle: TextStyle(
                          fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                      suffixIcon: Icon(Icons.man),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: _validateusername,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                          fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                      suffixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: _validatepassword,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        onPressed: () {
                          buildContext.read<SignupBloc>().add(
                              SignupWithEmailEvent(
                                  signupModel: SignupModel(
                                      username: usernameController.text,
                                      password: passwordController.text,
                                      email: emailController.text,
                                      firstname: firstnameController.text,
                                      lastname: lastnameController.text)));
                        },
                        style: ElevatedButton.styleFrom(
                          // primary: Color(0xFF8B48DF),
                          backgroundColor: Color(0xFF8B48DF),
                          // onPrimary: Color(0xFF8B48DF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Text(
                          'Create Account',
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
                      width: 20,
                    ),
                    Container(
                      height: 50,
                      width: 149,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          buildContext
                              .read<SignupBloc>()
                              .add(SignupOptionsViewEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          // primary: Color(0xFF8B48DF),
                          // onPrimary: Color(0xFF8B48DF),
                          backgroundColor: Color(0xFF8B48DF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: getTextSize15Value(buttonTextSize),
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String? _validateusername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Name';
    }
    return null;
  }

  String? _validatepassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value ?? '');

    if (value == null || value.isEmpty) {
      return 'Enter Email';
    } else if (!emailValid) {
      return 'Enter Valid Email';
    }
    return null;
  }
}
