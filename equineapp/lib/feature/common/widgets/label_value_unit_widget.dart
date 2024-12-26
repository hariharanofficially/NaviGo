import 'package:flutter/material.dart';

import '../../../utils/constants/appreance_definition.dart';

class LabelValueUnitWidget extends StatelessWidget {
  final String buttonTextSize = 'Medium'; // Initialize with a default value
  final String label;
  final String value;
  final String unit;
  final bool isPortrait;

  LabelValueUnitWidget({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.isPortrait,
  });

  double _getFigureTextSize() {
    if (isPortrait) {
      return 24;
    } else {
      return 20;
    }
  }

  int _getFigureFlex() {
    if (isPortrait) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(
                    '${label}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getTextSize14Value(buttonTextSize),
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            flex: _getFigureFlex(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.start,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                      '${value}',
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
                    fontSize: getTextSize14Value(buttonTextSize),
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
