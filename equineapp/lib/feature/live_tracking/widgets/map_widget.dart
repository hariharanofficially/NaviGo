// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../common/widgets/map_draw_triangle_widget.dart';

class MapWidget extends StatelessWidget {
  final String buttonTextSize = 'Medium'; // Initialize with a default value
  final MapController mapController;
  final LatLng initialLatLng;
  final LatLng lastLatLng;
  final List<LatLng> latlngList;
  final String horseName;
  final bool mapType;
  final String mapBoxAccesskey =
      "pk.eyJ1Ijoicm91c2VyYWplc2giLCJhIjoiY2xyZ2NmM2NoMGJjMTJqcXRmZHVkaWlkcyJ9.yFEQ81IPvieDXq4fx19YKQ";

  const MapWidget({
    required this.mapController,
    required this.initialLatLng,
    required this.lastLatLng,
    required this.latlngList,
    required this.horseName,
    required this.mapType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            //initialCenter: const LatLng(13.04995790696052, 80.21210342176465),
            initialCenter: lastLatLng,
            initialZoom: 17,
          ),
          children: [
            if (mapType)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.furtim.equineapp',
              ),
            if (!mapType)
              TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v11/tiles/{z}/{x}/{y}?access_token={mapBoxAccesskey}',
                  userAgentPackageName: 'com.furtim.equineapp',
                  additionalOptions: {
                    'mapBoxAccesskey': mapBoxAccesskey,
                  }),
            PolylineLayer(polylines: [
              Polyline(
                points: latlngList,
                strokeWidth: 6,
                color: Colors.blue,
                isDotted: true,
              ),
            ]),
            MarkerLayer(markers: [
              Marker(
                width: 10.0,
                height: 10.0,
                //point: LatLng(13.030417555763966, 80.2084140170165),
                point: initialLatLng,
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
                point: lastLatLng,
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
                        text: horseName,
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
              )
            ])
          ],
        ),
      ),
    );
  }
}
