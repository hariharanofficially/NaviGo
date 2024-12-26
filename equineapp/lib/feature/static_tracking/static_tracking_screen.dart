
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/participant_model.dart';
import 'bloc/static_tracking_bloc.dart';
import 'view/static_tracking_view.dart';

class StaticTrackingScreen extends StatelessWidget {
  const StaticTrackingScreen({
    super.key,
    required this.participant,
  });

  final ParticipantModel participant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StaticTrackingBloc>(
        create: (_) => StaticTrackingBloc()..add(StaticTrackingInitialEvent(participant: participant)),
        //create: (_) => {},
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: StaticTrackingView(participant: participant)));
  }
}
