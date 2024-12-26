import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../utils/constants/appreance_definition.dart';
// import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/custom_searchbar.dart';
import '../../common/widgets/dashboard_button_expanded_widget.dart';
// import '../../common/widgets/navigation_widget.dart';
import '../../common/widgets/tracker_button_widget.dart';
import '../bloc/dashboard_bloc.dart';
// import '../widgets/dashboard_bottom_navigation_bar_widget.dart';
import '../widgets/event_card_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocConsumer<DashboardBloc, DashboardState>(
        listener: (content, state) {},
        builder: (content, state) {
          return SingleChildScrollView(
            child: Center(
              child: Column(children: [
                SizedBox(height: 5),
                CustomSearchBar(
                  width: 320,
                  height: 40,
                ),
                SizedBox(height: 10),
                // if (isPaired)
                Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   flex: 4,
                      //  child: GestureDetector(
                      GestureDetector(
                          onTap: () => {
                                //Navigator.push(
                                buildContext.goNamed(RoutePath.dashboard)
                                //),
                              },
                          child: DashboardButtonExpandedWidget()),
                      // ),
                      // SizedBox(
                      //   width: 30,
                      // ),
                      //Expanded(
                      //  flex: 1,
                      //child:
                      GestureDetector(
                          onTap: () {
                            buildContext.goNamed(RoutePath.tracker);
                          },
                          child: TrackerButtonWidget()),
                      // ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                      child: Text(
                        'Event List',
                        style: TextStyle(
                          //color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: getTextSize14Value(buttonTextSize),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (state is DashboardEventsLoadingState)
                  SpinKitFadingCircle(
                    color: Colors.purple,
                    size: 50.0,
                  ),
                if (state is DashboardEventsEmptyState)
                  Container(
                    width: double.infinity,
                    height: 500,
                    margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Text(
                      'No records to show',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: isDarkMode ? Colors.white : Colors.purple,
                        fontSize: getTextSize14Value(buttonTextSize),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (state is DashboardEventsLoadedState)
                  Container(
                      width: double.infinity,
                      height: 500,
                      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: ListView.builder(
                          itemCount: state.events.length,
                          // Number of containers
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child:
                                  EventCardWidget(event: state.events[index]),
                            );
                          }))
              ]),
            ),
          );
        });
  }
}
