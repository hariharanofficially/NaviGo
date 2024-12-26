import 'package:flutter/material.dart';

import '../../../utils/constants/appreance_definition.dart';

// ignore: must_be_immutable
class AvgDataInfoCardWidget extends StatelessWidget {
  String buttonTextSize = 'Medium'; // Initialize with a default value
  final String value;
  final String unit;
  final String type;
  final bool isPortrait;

  AvgDataInfoCardWidget({
    super.key,
    required this.type,
    required this.unit,
    required this.value,
    required this.isPortrait,
  });

  String _getLabel() {
    if (type == 'HR') {
      return 'Avg. Heart Beat';
    } else {
      return 'Avg. Speed';
    }
  }

  Color _getCardColor() {
    if (type == 'HR') {
      return const Color(0x5548BADF);
    } else {
      return const Color(0x55DF48A2);
    }
  }

  Color _getDividerColor() {
    if (type == 'HR') {
      return const Color(0xFF48BADF);
    } else {
      return const Color(0xFFDF48A2);
    }
  }

  double _getFigureTextSize() {
    if (isPortrait) {
      return 20;
    } else {
      return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 100,
      // height: 126,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: _getCardColor(), // Set card color
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              _getLabel(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black54,
                fontSize: getTextSize10Value(buttonTextSize),
                fontFamily: 'Karla',
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: VerticalDivider(
              thickness: 1,
              width: 20,
              color: _getDividerColor(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.start,
              //textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                    '${value} ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    //color: Colors.grey,
                    fontSize: _getFigureTextSize(),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                    '${unit}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: getTextSize12Value(buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //),
    );
  }
}
