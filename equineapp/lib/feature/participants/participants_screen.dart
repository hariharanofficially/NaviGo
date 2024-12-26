import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/widgets/custom_app_bar_widget.dart';
import '../common/widgets/navigation_widget.dart';
import '../dashboard/widgets/dashboard_bottom_navigation_bar_widget.dart';
import 'bloc/participants_bloc.dart';
import 'view/participants_view.dart';

class ParticipantsScreen extends StatelessWidget {
  const ParticipantsScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParticipantsBloc>(
        create: (_) => ParticipantsBloc()..add(ParticipantsFetchEvent(id: id)),
        //create: (_) => {},
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //theme: Provider.of<ThemeProviderNotifier>(context).getThemeData(),
          title: 'NAVI GO',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Scaffold(
            //key: _scaffoldKey,
            endDrawer: const NavigitionWidget(),
            appBar: CustomAppBarWidget(),
            body: ParticipantsView(),
            bottomNavigationBar: DashboardBottomNavigationBarWidget(),
          ),
        ));
  }
}
