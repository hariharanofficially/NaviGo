import 'package:EquineApp/feature/tracker/widgets/tracker_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:provider/provider.dart';

// import '../../utils/theme/Theme.dart';
import '../common/widgets/custom_app_bar_widget.dart';
import '../common/widgets/navigation_widget.dart';
import 'bloc/tracker_bloc.dart';
import 'view/tracker_view.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //ThemeData? themeData = Provider.of<ThemeProviderNotifier>(context).getThemeData();
    return BlocProvider<TrackerBloc>(
        create: (_) => TrackerBloc()..add(TrackerParticipantsFetchEvent()),
        //create: (_) => {},
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            //theme: ThemeProviderNotifier().getThemeData(),
            title: 'NAVI GO',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: Scaffold(
                //key: _scaffoldKey,
                endDrawer: const NavigitionWidget(),
                appBar: CustomAppBarWidget(),
                body: TrackerView(),
                bottomNavigationBar: TrackerBottomNavigationBarWidget())));
  }
}
