// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../utils/constants/appreance_definition.dart';
// import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/dashboard_button_expanded_widget.dart';
// import '../../common/widgets/navigation_widget.dart';
import '../../common/widgets/tracker_button_widget.dart';
// import '../../dashboard/widgets/dashboard_bottom_navigation_bar_widget.dart';
import '../bloc/participants_bloc.dart';
import '../widgets/participant_cart_widget.dart';

class ParticipantsView extends StatelessWidget {
  const ParticipantsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return BlocConsumer<ParticipantsBloc, ParticipantsState>(
        listener: (content, state) {},
        builder: (content, state) {
          return SingleChildScrollView(
            child: Center(
              child: Column(children: [
                // if (isPaired)
                // Container(
                //   padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // Expanded(
                //       //   flex: 1,
                //       //   child:
                //       GestureDetector(
                //           onTap: () =>
                //               {buildContext.goNamed(RoutePath.dashboard)},
                //           child: DashboardButtonExpandedWidget()),
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
                //           child: TrackerButtonWidget())
                //     ],
                //   ),
                // ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 20, bottom: 10),
                      child: Text(
                        'Participant List',
                        style: TextStyle(
                          //color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: getTextSize14Value(buttonTextSize),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (state is ParticipantsLoadingState)
                  SpinKitFadingCircle(
                    color: Colors.purple,
                    size: 50.0,
                  ),
                if (state is ParticipantsEmptyState)
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
                // if (state is ParticipantsLoadedState)
                //   Container(
                //     width: double.infinity,
                //     height: 500,
                //     margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                //     child: ListView.builder(
                //         itemCount: state.participants.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           return ParticipantCardWidget(
                //               participant: state.participants[index],
                //               type: 'dashboard');
                //         }),
                //   ),
                if (state is ParticipantsLoadedState)
                  state.participants.isEmpty
                      ? Container(
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
                        )
                      : Container(
                          width: double.infinity,
                          height: 500,
                          margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: ListView.builder(
                            itemCount: state.participants.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ParticipantCardWidget(
                                participant: state.participants[index],
                                type: 'dashboard',
                              );
                            },
                          ),
                        ),
              ]),
            ),
          );
        });
  }
}
