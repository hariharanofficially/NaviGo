import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/signin_bloc.dart';
import 'view/signin_view.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SigninBloc>(
        create: (_) => SigninBloc()..add(SigninInitialEvent()),
        //create: (_) => {},
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            //theme: ThemeProviderNotifier().getThemeData(),
            title: 'NAVI GO',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: Scaffold(body: SigninView())));
  }
}
