// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

import '../../../app/route/routes/route_path.dart';
import '../../../data/models/participant_model.dart';
import '../../../data/models/tracker_feed_data.dart';
import '../../../utils/constants/appreance_definition.dart';
import '../../../utils/mixins/convert_date_format.dart';
import '../../common/widgets/avg_data_info_card_widget.dart';
import '../../common/widgets/data_info_card_widget.dart';
import '../../common/widgets/label_value_unit_widget.dart';
import '../../common/widgets/label_value_widget.dart';
// import '../../static_tracking/widgets/map_with_feed_marker_widget.dart';
import '../../common/widgets/name_title_card_widget.dart';
import '../bloc/live_tracking_bloc.dart';
import '../widgets/map_widget.dart';

// ignore: must_be_immutable
class LiveTrackingView extends StatelessWidget {
  Logger logger = new Logger();
  bool generalMapType = true;
  bool fullScreen = false;
  MapController _mapctl = MapController();
  List<TrackerFeedData> feedEntryList = [];
  List<LatLng> latlng = [];
  LatLng initialLatLng = LatLng(12.9010, 80.2279);
  LatLng lastLatLng = LatLng(12.9010, 80.2279);
  int feedOrgLength = 0;

  bool isRunEnabled = false;
  bool isShareEnabled = false;
  bool isTrackingStarted = false;
  late int trackingStartTime;
  late int trackingEndTime;
  String duration = "00:00:00";
  LiveTrackingView({
    super.key,
    required this.participant,
  });

  ParticipantModel participant;

  @override
  Widget build(BuildContext buildContext) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
    ]);
    return BlocConsumer<LiveTrackingBloc, LiveTrackingState>(
        listener: (content, state) {
      if (state is LiveTrackingMapViewChangedState) {
        this.generalMapType = state.mapView;
      } else if (state is LiveTrackingMapFullScreenChangedState) {
        this.fullScreen = state.fullScreen;
      } else if (state is LiveTrackingStartedState) {
        this.isRunEnabled = true;
        this.isTrackingStarted = true;
        this.trackingStartTime = state.startTime;
      } else if (state is LiveTrackingEndedState) {
        this.isRunEnabled = false;
        this.trackingEndTime = state.endTime;
      } else if (state is LiveTrackingShareEnabledState) {
        this.isShareEnabled = true;
      } else if (state is LiveTrackingShareDisabledState) {
        this.isShareEnabled = false;
      } else if (state is LiveTrackerRefreshDataLoadedState) {
        this.participant = state.participant!;
        this.latlng = state.latlng;
        this.initialLatLng = this.latlng[0];
        this.lastLatLng=this.latlng[this.latlng.length-1];
         this.duration = durationStringFromStartAndEndMillis(
            trackingStartTime, DateTime.now().millisecondsSinceEpoch);
      }
    }, builder: (content, state) {
      return Scaffold(
        appBar: AppBar(
            title: Text(participant.horseName),
            backgroundColor: Color(0xFF8B48DF),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              // You can use any icon you prefer
              onPressed: () {
                buildContext.goNamed(RoutePath.tracker);
              },
            ),
            actions: [
              IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.refresh),
                // You can use any icon you prefer
                onPressed: () {
                  buildContext
                      .read<LiveTrackingBloc>()
                      .add(LiveTrackerRefreshEvent()); // This will navigate back
                },
              ),
            ] // Change app bar color to purple
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              onPressed: () {
                buildContext
                    .read<LiveTrackingBloc>()
                    .add(LiveTrackingMapViewChangeEvent());
              },
              child: Stack(children: [
                if (!generalMapType) Icon(Icons.map),
                if (generalMapType) Icon(Icons.map_outlined),
              ])),
          SizedBox(height: 10),
          FloatingActionButton(
              onPressed: () {
                buildContext
                    .read<LiveTrackingBloc>()
                    .add(LiveTrackingMapFullScreenEvent());
              },
              child: Stack(children: [
                if (!fullScreen) Icon(Icons.fullscreen),
                if (fullScreen) Icon(Icons.fit_screen),
              ])),
        ]),
        body: OrientationBuilder(
          builder: (context, orientation) {
            {
              return Column(
                children: [
                  if (!fullScreen)
                    Container(
                      height: 400,
                      child: Column(children: [
                        TitleCardWidget(
                            deviceName: participant.trackerDeviceId,
                            deviceId: participant.hrSensorId,
                            riderName: participant.horseName),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 160,
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: LabelValueUnitWidget(
                                            label: 'Distance',
                                            value: participant.distance,
                                            unit: ' km',
                                            isPortrait: true),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelValueUnitWidget(
                                            label: 'Duration',
                                            //value: participant.duration,
                                            value: duration,
                                            unit: ' s',
                                            isPortrait: true),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: SizedBox(
                                    height: 160,
                                    child: Card(
                                      elevation: 4,
                                      //borderOnForeground: false,
                                      margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                      //shadowColor: Color(0xFF8B48DF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Column(children: [
                                        if (!isRunEnabled && !isTrackingStarted)
                                          LabelValueWidget(
                                              label: 'Start time',
                                              value: '-',
                                              isPortrait: true),
                                        if (!isRunEnabled && !isTrackingStarted)
                                          LabelValueWidget(
                                              label: 'End time',
                                              value: '-',
                                              isPortrait: true),

                                        if (isTrackingStarted)
                                          LabelValueWidget(
                                              label: 'Start time',
                                              value: formatDateFromMillis(
                                                  trackingStartTime),
                                              isPortrait: true),
                                        if (isRunEnabled && isTrackingStarted)
                                          LabelValueWidget(
                                              label: 'End time',
                                              value: '-',
                                              isPortrait: true),
                                        if (!isRunEnabled && isTrackingStarted)
                                          LabelValueWidget(
                                              label: 'End time',
                                              value: formatDateFromMillis(
                                                  trackingEndTime),
                                              isPortrait: true),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 2,
                                          indent: 50,
                                          endIndent: 50,
                                        ),
                                        // TrackingButton(isRunEnabled: isRunEnabled,
                                        //     startTrackingFunc: _startTracking,
                                        //     stopTrackingFunc: _stopTracking ),
                                        if (isRunEnabled)
                                          Container(
                                            //width: double.infinity,
                                            height: 35,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                buildContext
                                                    .read<LiveTrackingBloc>()
                                                    .add(
                                                        LiveTrackerStopEvent());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFF8B48DF)
                                                  //primary: Color(0xFF8B48DF),
                                                  // Change the button's background color
                                                  ),
                                              child: Text(
                                                'Stop Tracking',
                                                style: TextStyle(
                                                  fontSize: getTextSize16Value(
                                                      buttonTextSize),
                                                  // Change the text size
                                                  color: Colors
                                                      .white, // Change the text color
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (!isRunEnabled)
                                          Container(
                                            //width: double.infinity,
                                            height: 35,

                                            child: ElevatedButton(
                                              onPressed: () {
                                                buildContext
                                                    .read<LiveTrackingBloc>()
                                                    .add(
                                                        LiveTrackerStartEvent());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFF8B48DF)
                                                  //  primary: Color(0xFF8B48DF),
                                                  // Change the button's background color
                                                  ),
                                              child: Text(
                                                'Start Tracking',
                                                style: TextStyle(
                                                  fontSize: getTextSize16Value(
                                                      buttonTextSize),
                                                  // Change the text size
                                                  color: Colors
                                                      .white, // Change the text color
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        Container(
                                          width: double.infinity,
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Data Sharing",
                                                  // textAlign: TextAlign.center,
                                                  style: (TextStyle(
                                                    color: Color(0xFF8B48DF),
                                                    fontSize:
                                                        getTextSize12Value(
                                                            buttonTextSize),
                                                  ))),
                                              SizedBox(
                                                width: 50,
                                                height: 35,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Switch.adaptive(
                                                    // This bool value toggles the switch.
                                                    value: isShareEnabled,
                                                    activeColor: Colors.green,
                                                    onChanged: (bool value) {
                                                      // This is called when the user toggles the switch.
                                                      if (isShareEnabled) {
                                                        buildContext
                                                            .read<
                                                                LiveTrackingBloc>()
                                                            .add(
                                                                LiveTrackerUnShareEvent());
                                                      } else {
                                                        buildContext
                                                            .read<
                                                                LiveTrackingBloc>()
                                                            .add(
                                                                LiveTrackerShareEvent());
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    )))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                            elevation: 4,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Container(
                                //width: 400,
                                height: 150,
                                child: Row(children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(children: [
                                        DataInfoCardWidget(
                                            type: 'SPEED',
                                            unit: 'km/h',
                                            value: participant.speed,
                                            //value: '999.9',
                                            isPortrait: true),
                                        // DataInfo(type: 'SPEED', unit: 'km/h', value: '99.9', isPortrait: true),
                                        AvgDataInfoCardWidget(
                                            type: 'SPEED',
                                            unit: 'km/h',
                                            value: participant.avgSpeed,
                                            isPortrait: true)
                                      ])),
                                  SizedBox(
                                    height: 120,
                                    child: VerticalDivider(
                                      thickness: 1,
                                      width: 5,
                                      indent: 5,
                                      endIndent: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Column(children: [
                                        DataInfoCardWidget(
                                            type: 'HR',
                                            unit: 'bpm',
                                            value: participant.hrRate,
                                            isPortrait: true),
                                        AvgDataInfoCardWidget(
                                            type: 'HR',
                                            unit: 'bpm',
                                            value: participant.avgHrRate,
                                            isPortrait: true)
                                        //DataAvgInfo(type: 'HR', unit: 'bpm', value: '999.99', isPortrait: true)
                                      ])),
                                ]))),
                      ]),
                    ),

                  //Second Row (FlutterMap)
                  Expanded(
                    flex: 2,
                    child: MapWidget(
                        mapController: _mapctl,
                        initialLatLng: initialLatLng,
                        lastLatLng: lastLatLng,
                        latlngList: latlng,
                        horseName: participant.startNumber,
                        mapType: generalMapType),
                  ),
                ],
              );
            }
          },
        ),
      );
    });
  }
}
