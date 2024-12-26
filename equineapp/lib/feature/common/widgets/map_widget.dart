// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../../../data/models/tracker_feed_data.dart';
import 'map_draw_triangle_widget.dart';
import 'map_label_value_widget.dart';

class MapWidget extends StatefulWidget {
  final MapController mapController;
  final latlong.LatLng initialLatLng;
  final latlong.LatLng lastLatLng;
  final List<latlong.LatLng> latlngList;
  final List<TrackerFeedData> feedEntryList;
  final String horseName;
  final bool mapType;

  MapWidget({
    required this.mapController,
    required this.initialLatLng,
    required this.lastLatLng,
    required this.latlngList,
    required this.feedEntryList,
    required this.horseName,
    required this.mapType,
  });

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  String buttonTextSize = 'Medium'; // Initialize with a default value
  bool locationSelected = false;
  late TrackerFeedData selectedFeedEntry;

  String mapBoxAccesskey =
      "pk.eyJ1Ijoicm91c2VyYWplc2giLCJhIjoiY2xyZ2NmM2NoMGJjMTJqcXRmZHVkaWlkcyJ9.yFEQ81IPvieDXq4fx19YKQ";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            //initialCenter: const LatLng(13.04995790696052, 80.21210342176465),
            initialCenter: widget.lastLatLng,
            initialZoom: 16,
          ),
          children: [
            if (widget.mapType)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.furtim.EquineApp',
              ),
            if (!widget.mapType)
              TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v11/tiles/{z}/{x}/{y}?access_token={mapBoxAccesskey}',
                  userAgentPackageName: 'com.furtim.EquineApp',
                  additionalOptions: {
                    'mapBoxAccesskey': mapBoxAccesskey,
                  }),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: widget.latlngList,
                  strokeWidth: 6,
                  color: Colors.blue,
                  isDotted: true,
                ),
              ],
            ),
            MarkerLayer(markers: [
              ...widget.feedEntryList
                  .map((point) => Marker(
                        width: 20.0,
                        height: 20.0,
                        point: point.latlng,
                        child: Container(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                locationSelected = true;
                                selectedFeedEntry = point;
                              });
                            },
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              Marker(
                width: 10.0,
                height: 10.0,
                //point: LatLng(13.030417555763966, 80.2084140170165),
                point: widget.initialLatLng,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Border color (black)
                      width: 2.0, // Border width
                    ),
                    color: Colors.white, // Fill color (white)
                  ),
                ),
              ),
              Marker(
                width: 50.0,
                height: 40.0,
                rotate: true,
                point: widget.lastLatLng,
                child: Column(children: [
                  Container(
                    // width: 50,
                    // height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF8B48DF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(5),
                    //margin:EdgeInsets.fromLTRB(0, 10, 0, 0),
                    //margin: EdgeInsets.all(10),
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: widget.horseName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  CustomPaint(size: Size(10, 10), painter: DrawTriangle()),
                ]),
              ),
              if (locationSelected)
                Marker(
                  width: 170.0,
                  height: 220.0,
                  rotate: true,
                  point: selectedFeedEntry.latlng,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
                    child: Column(children: [
                      Container(
                          width: 170,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(5),
                          //margin: EdgeInsets.all(10),
                          child: Column(children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    locationSelected = false;
                                  });
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                  size: 15.0,
                                ),
                              ),
                            ),
                            MapLabelValueWidget(
                                label: 'HeartBeat',
                                value: selectedFeedEntry.heartRate + ' bpm',
                                isPortrait: true),
                            MapLabelValueWidget(
                                label: 'Speed',
                                value: selectedFeedEntry.speed + ' km/h',
                                isPortrait: true),
                            MapLabelValueWidget(
                                label: 'Time',
                                value: DateFormat.Hms()
                                    .format(selectedFeedEntry.dateTime),
                                isPortrait: true),
                          ])),
                      CustomPaint(
                          size: Size(10, 10), painter: DrawTriangleForMap()),
                    ]),
                  ),
                ),
            ])
          ],
        ),
      ),
    );
  }
}
