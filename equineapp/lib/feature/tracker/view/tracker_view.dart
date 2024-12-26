import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

// import 'package:provider/provider.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/models/participant_model.dart';
import '../../../utils/constants/appreance_definition.dart';
// import '../../../utils/theme/Theme.dart';
// import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/dashboard_button_widget.dart';
// import '../../common/widgets/navigation_widget.dart';
import '../../common/widgets/tracker_button_expanded_widget.dart';
import '../../participants/widgets/participant_cart_widget.dart';
import '../bloc/tracker_bloc.dart';
// import '../widgets/tracker_bottom_navigation_widget.dart';
import '../widgets/tracker_event_card_widget.dart';
import '../../common/widgets/custom_searchbar.dart';

class TrackerView extends StatelessWidget {
  TrackerView({Key? key}) : super(key: key);
  ParticipantModel? participantModel;

  @override
  Widget build(BuildContext buildContext) {
    bool showRecent = false;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocConsumer<TrackerBloc, TrackerState>(
        listener: (content, state) {},
        builder: (content, state) {
          return SingleChildScrollView(
            child: Center(
              child: Column(children: [ SizedBox(height: 5),
                //  CustomSearchBar(width: 320, height: 40,),
                //  SizedBox(height: 8),
                // // if (isPaired)
                // Container(
                //   padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // Expanded(
                //       //   flex: 1,
                //       //   child:
                //       GestureDetector(
                //               onTap: () => {
                //                 buildContext.goNamed(RoutePath.dashboard)
                //               },
                //           child: DashboardButtonWidget()),
                //       //),
                //       // SizedBox(
                //       //   width: 30,
                //       // ),
                //       // Expanded(
                //       //   flex: 3,
                //       //   child:
                //       GestureDetector(
                //           onTap: () {
                //             buildContext.goNamed(RoutePath.tracker);
                //           },
                //           child: TrackerButtonExpandedWidget()),
                //     ],
                //   ),
                // ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 20, bottom: 10),
                      child: Text(
                        'Status',
                        style: TextStyle(
                          //color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: getTextSize14Value(buttonTextSize),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                if (state is TrackerParticipantsLoadingState)
                  SpinKitFadingCircle(
                    color: Colors.purple,
                    size: 50.0,
                  ),
                if (state is TrackerParticipantLoadedState)
                  TrackerEventWidget(
                      participant: state.currentParticipant,
                      isPaired: state.isPaired),

                if (showRecent == true)
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                      child: Text(
                        'Recent',
                        style: TextStyle(
                          //color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: getTextSize14Value(buttonTextSize),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (showRecent == true && state is TrackerParticipantsLoadingState)
                  SpinKitFadingCircle(
                    color: Colors.purple,
                    size: 50.0,
                  ),
                if (showRecent == true && state is TrackerParticipantLoadedState &&
                    state.eventParticipants.isEmpty)
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

                if (showRecent == true && state is TrackerParticipantLoadedState)
                  Container(
                    width: double.infinity,
                    height: 400,
                    margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: ListView.builder(
                        itemCount: state.eventParticipants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ParticipantCardWidget(
                              participant: state.eventParticipants[index],
                              type: 'tracker');
                        }),
                  ),
              ]),
            ),
              );
        });
  }
}
