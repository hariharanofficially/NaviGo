
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/participant_model.dart';
import 'bloc/live_tracking_bloc.dart';
import 'view/live_tracking_view.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({
    super.key,
    required this.participant,
  });

  final ParticipantModel participant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LiveTrackingBloc>(
        create: (_) => LiveTrackingBloc()..add(LiveTrackingInitialEvent(participant: participant)),
        //create: (_) => {},
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: LiveTrackingView(participant: participant)));
  }
}
