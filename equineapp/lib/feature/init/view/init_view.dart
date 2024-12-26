import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../bloc/init_bloc.dart';

class InitView extends StatelessWidget {
  const InitView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InitBloc, InitState>(
      listener: (context, state) {
        if (state is InitSuccess) {
          Timer(const Duration(seconds: 3), () {
            GoRouter.of(context).goNamed(state.route);
          });
        } else if (state is InitFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is InitLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset('assets/images/tracker.json'),
            ),
          );
        }
    
        // You can also add a fallback state or UI here if needed
        return Scaffold(
          body: Center(
            child: Lottie.asset('assets/images/tracker.json'),
          ),
        );
      },
    );
  }
}
