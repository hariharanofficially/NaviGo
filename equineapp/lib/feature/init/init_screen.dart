

import 'package:EquineApp/feature/init/view/init_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/init_bloc.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InitBloc>(
           create: (_) => InitBloc()..add(CheckLoginStatus()),
        child: Container(
            color: Colors.white,
            child: InitView()));
  }
}
