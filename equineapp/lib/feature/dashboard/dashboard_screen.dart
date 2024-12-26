import 'package:EquineApp/feature/dashboard/widgets/dashboard_bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/widgets/custom_app_bar_widget.dart';
import '../common/widgets/navigation_widget.dart';
import 'bloc/dashboard_bloc.dart';
import 'view/dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
        create: (_) => DashboardBloc()..add(DashboardInitialEvent()),
        //create: (_) => {},
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //theme: Provider.of<ThemeProviderNotifier>(context).getThemeData(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          title: 'NAVI GO',
          home: Scaffold(
            endDrawer: const NavigitionWidget(),
            appBar: CustomAppBarWidget(),
            body: DashboardView(),
            bottomNavigationBar: DashboardBottomNavigationBarWidget(),
          ),
        ));
  }
}
