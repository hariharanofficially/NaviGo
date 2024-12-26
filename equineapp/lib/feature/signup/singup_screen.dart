import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/singup_bloc.dart';
import 'view/signup_view.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
        create: (_) => SignupBloc()..add(SignupInitialEvent()),
        //create: (_) => {},
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            //theme: ThemeProviderNotifier().getThemeData(),
            title: 'NAVI GO',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: Scaffold(body: SignupView())));
  }
}
