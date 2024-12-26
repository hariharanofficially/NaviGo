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
import '../../common/widgets/avg_data_info_card_widget.dart';
import '../../common/widgets/data_info_card_widget.dart';
import '../../common/widgets/label_value_unit_widget.dart';
import '../../common/widgets/label_value_widget.dart';
import '../bloc/static_tracking_bloc.dart';
import '../widgets/map_with_feed_marker_widget.dart';

// ignore: must_be_immutable
class StaticTrackingView extends StatelessWidget {
  final Logger logger = new Logger();
  bool generalMapType = true;
  bool fullScreen = false;
  MapController _mapctl = MapController();
  List<TrackerFeedData> feedEntryList = [];
  List<LatLng> latlng = [];
  LatLng initialLatLng = LatLng(12.9010, 80.2279);
  LatLng lastLatLng = LatLng(12.9010, 80.2279);
  int feedOrgLength = 0;

  StaticTrackingView({
    super.key,
    required this.participant,
  });

  late final ParticipantModel participant;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocConsumer<StaticTrackingBloc, StaticTrackingState>(
        listener: (content, state) {
      if (state is StaticTrackingMapViewChangedState) {
        this.generalMapType = state.mapView;
      }

      if (state is StaticTrackingMapFullScreenChangedState) {
        this.fullScreen = state.fullScreen;
      }
          if(state is StaticTrackingParticipantUpdatedState) {
            this.participant = state.participant;
          }
      if (state is StaticTrackingTrackerFeedLoadedState) {
        List<TrackerFeedData> feedsOrg = state.feedDataList;
        List<TrackerFeedData> feeds = [];
        logger.d("== STATIC = FEEDS : " + feedsOrg.length.toString());
        if (feedOrgLength == 0) {
          if (feedsOrg.length > 500) {
            int skipCount = (feedsOrg.length / 500).round();
            int skip = skipCount;
            int count = feedsOrg.length;
            while (count > 0) {
              feeds.addAll(feedsOrg.skip(skipCount).take(1));
              skipCount += skip;
              count -= skip;
            }
          } else {
            feeds.addAll(feedsOrg);
          }
        } else {
          //int recordsAdded = feedsOrg.length - feedOrgLength;
          feeds.addAll(feedsOrg.sublist(feedOrgLength - 1));
        }

        feedOrgLength = feedsOrg.length;
        feedsOrg.clear();
        logger.d("== STATIC = FEEDS 2 : " + feeds.length.toString());
        //latlng = [];
        for (var feed in feeds) {
          if (feed.latlng.latitude != 0 && feed.latlng.longitude != 0) {
            //feed.latlng.latitude != null && feed.latlng.longitude != null
            feedEntryList.add(feed);
            latlng.add(LatLng(feed.latlng.latitude, feed.latlng.longitude));
          }
        }
        if (latlng.length > 0) {
          var lastFeed = feeds.last;
          logger.d(lastFeed);
          initialLatLng = latlng.first;
          lastLatLng = latlng.last;
          double zoom = _mapctl.camera.zoom;
          _mapctl.move(lastLatLng, zoom);
        }
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
              //Navigator.of(context).pop(); // This will navigate back
              context.goNamed(RoutePath.participants,
                  pathParameters: {"id": participant.eventId.toString()});
            },
          ), // Change app bar color to purple
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              onPressed: () {
                context
                    .read<StaticTrackingBloc>()
                    .add(StaticTrackingMapViewChangeEvent());
              },
              child: Stack(children: [
                if (!generalMapType) Icon(Icons.map),
                if (generalMapType) Icon(Icons.map_outlined),
              ])),
          SizedBox(height: 10),
          FloatingActionButton(
              onPressed: () {
                context
                    .read<StaticTrackingBloc>()
                    .add(StaticTrackingMapFullScreenEvent());
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
                      height: 370,
                      child: Column(children: [
                        // if (currentParticipant['trackerDevice'] == null)
                        //   TitleCard(deviceName: '',
                        //       deviceId: '',
                        //       riderName: ''),
                        // if (currentParticipant['trackerDevice'] != null)
                        //   TitleCard(deviceName: '${currentParticipant?['trackerDevice']?['trackerDeviceId']}',
                        //       deviceId: '${currentParticipant?['trackerDevice']?['heartRateCensorId']}',
                        //       riderName: '${currentParticipant?['rider']?['name']}'),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 180,
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
                                            value: participant.duration,
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
                                    height: 180,
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
                                        // if (!isRunEnabled)
                                        //   LabelValueWidget(label: 'Start time', value: '-', isPortrait: true),
                                        // if (!isRunEnabled)
                                        //   LabelValueWidget(label: 'End time', value: '-', isPortrait: true),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Text(
                                            participant.riderName,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF8B48DF),
                                              fontSize: getTextSize14Value(
                                                  buttonTextSize),
                                              // fontSize: getTextSize14(textSizeType),
                                              fontFamily: 'Karla',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF8B48DF),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.all(5),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          //margin: EdgeInsets.all(10),
                                          child: Text.rich(
                                            textAlign: TextAlign.center,
                                            TextSpan(
                                              text: participant.startNumber,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: getTextSize12Value(
                                                    buttonTextSize),
                                                fontFamily: 'Karla',
                                                fontWeight: FontWeight.w800,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 2,
                                          indent: 50,
                                          endIndent: 50,
                                        ),
                                        //if (isRunEnabled)
                                        LabelValueWidget(
                                            label: 'Start time',
                                            value: participant.departureTime,
                                            isPortrait: true),
                                        //if (isRunEnabled)
                                        LabelValueWidget(
                                            label: 'End time',
                                            value: participant.arrivalTime,
                                            isPortrait: true),
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
                                            //value: '999.99',
                                            isPortrait: true),
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
                                      ])),
                                ]))),
                      ]),
                    ),

                  //Second Row (FlutterMap)
                  //if (state is StaticTrackingTrackerShowMapState)
                  Expanded(
                    //flex: 2,
                    child: MapWithFeedMarkerWidget(
                        mapController: _mapctl,
                        initialLatLng: initialLatLng,
                        lastLatLng: lastLatLng,
                        latlngList: latlng,
                        feedEntryList: feedEntryList,
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
