import 'package:flutter/material.dart';

import '../../../utils/constants/appreance_definition.dart';

class MapLabelValueWidget extends StatelessWidget {
  final String buttonTextSize = 'Medium'; // Initialize with a default value
  final String label;
  final String value;
  final bool isPortrait;

  MapLabelValueWidget({
    super.key,
    required this.label,
    required this.value,
    required this.isPortrait,
  });

  double _getBottomPadding() {
    if (isPortrait) {
      return 5;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 0, _getBottomPadding()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Text(
                  '${label}',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey,
                fontSize: getTextSize12Value(buttonTextSize),
                fontFamily: 'Karla',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
                  '${value}',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey,
                fontSize: getTextSize12Value(buttonTextSize),
                fontFamily: 'Karla',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
