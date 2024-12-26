import 'package:flutter/material.dart';

import '../../../utils/constants/appreance_definition.dart';

class DataInfoCardWidget extends StatelessWidget {
  final String buttonTextSize = 'Medium'; // Initialize with a default value
  final String value;
  final String unit;
  final String type;
  final bool isPortrait;

  DataInfoCardWidget({
    super.key,
    required this.type,
    required this.unit,
    required this.value,
    required this.isPortrait,
  });

  double _getFigureTextSize() {
    if (isPortrait) {
      return 30;
    } else {
      return 26;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                if (type == 'HR')
                  Image.asset(
                    "assets/images/heartbeat.png",
                    width: 50,
                    height: 50,
                  ),
                if (type == 'SPEED')
                  Image.asset(
                    "assets/images/speed_gauge.jpg",
                    width: 50,
                    height: 50,
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  '${value}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: _getFigureTextSize(),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${unit}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getTextSize16Value(buttonTextSize),
                    fontFamily: 'Karla',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
