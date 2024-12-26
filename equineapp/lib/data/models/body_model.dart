import 'package:intl/intl.dart';

class BodyModel {
  final int id;
  final String weight;
  final String measuredDatetime;

  BodyModel({
    required this.id,
    required this.weight,
    required this.measuredDatetime,
  });

  factory BodyModel.fromJson(Map<String, dynamic> json) {
    return BodyModel(
      id: json['id'],
      weight: json['weight'] != null
          ? json['weight'].toString()
          : '0', // Provide a default if null
      measuredDatetime:
          json['measuredDatetime'] ?? '', // Provide a default if null
    );
  }
  String getFormattedDate() {
    try {
      if (measuredDatetime.isEmpty)
        return ''; // Return an empty string if `measuredDatetime` is empty
      DateTime parsedDate = DateTime.parse(measuredDatetime);
      return DateFormat("dd-MMM-yy").format(parsedDate);
    } catch (e) {
      // Log the error if needed, and return an empty string or a default formatted date
      return 'Invalid Date';
    }
  }
}
