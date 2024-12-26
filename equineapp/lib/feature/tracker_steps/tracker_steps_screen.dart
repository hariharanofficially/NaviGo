import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/widgets/custom_app_bar_widget.dart';
import '../common/widgets/navigation_widget.dart';
import 'bloc/tracker_steps_bloc.dart';
import 'view/tracker_steps_view.dart';

class TrackerStepsScreen extends StatelessWidget {
  const TrackerStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrackerStepsBloc>(
        create: (_) => TrackerStepsBloc()..add(TrackerStepsInitialEvent()),
        //create: (_) => {},
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //theme: Provider.of<ThemeProviderNotifier>(context).getThemeData(),
          title: 'NaviGo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Scaffold(
            endDrawer: const NavigitionWidget(),
            appBar: CustomAppBarWidget(),
            body: TrackerStepsView(),
          ),
        ));
  }
}
