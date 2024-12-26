// import '../../common/widgets/custom_app_bar_widget.dart';
// import '../../common/widgets/navigation_widget.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tracker_steps_bloc.dart';
import 'tracker_step_bluetooth_view.dart';
import 'tracker_step_golive_view.dart';
import 'tracker_steps_gps_view.dart';

class TrackerStepsView extends StatelessWidget {
  const TrackerStepsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: HorizontalTimelineWithAnimation(),
    );
  }
}

class HorizontalTimelineWithAnimation extends StatefulWidget {
  @override
  _HorizontalTimelineWithAnimationState createState() =>
      _HorizontalTimelineWithAnimationState();
}

class _HorizontalTimelineWithAnimationState
    extends State<HorizontalTimelineWithAnimation> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocConsumer<TrackerStepsBloc, TrackerStepsState>(
        listener: (content, state) {},
        buildWhen: (previous, current) =>
            previous != current &&
            (current is TrackerStepBluetoothViewState ||
                current is TrackerStepGpsViewState ||
                current is TrackerStepGoliveViewState),
        builder: (content, state) {
          if (state is TrackerStepBluetoothViewState) {
            return TrackerStepBluetoothView(
                registeredDevices: state.registeredDevices,
                connectedDevice: state.connectedDevice,
                isPaired: state.isPaired);
          } else if (state is TrackerStepGpsViewState) {
            return TrackerStepGpsView(connectedDevice: state.connectedDevice);
          } else if (state is TrackerStepGoliveViewState) {
            return TrackerStepGoliveView(
                connectedDevice: state.connectedDevice,
                participant: state.participant);
          } else {
            return Scaffold(
                //    body: Container(child: Text("this is test"))
                );
          }
        });
  }
}
