import 'package:intl/intl.dart';

String formatDate(String date) {
  var d = DateFormat('yyyy-MM-dd').parse(date);
  return DateFormat('dd-MMM-yy').format(d);
}

String formatDateTime(String date) {
  DateTime d = DateTime.parse(date);
  return DateFormat('dd-MMM-yy HH:mm:ss').format(d);
}

String formatDateToDateString(String date) {
  DateFormat inputFormat = DateFormat("dd-MMM-yy");
  DateTime parsedDate = inputFormat.parse(date);

  // Format the parsed date to YYYY-MM-DD
  DateFormat outputFormat = DateFormat("yyyy-MM-dd");
  String formattedDate = outputFormat.format(parsedDate);
  return formattedDate;
}
String formatDateFromMillis(int dateInMillis) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(dateInMillis);
  return DateFormat.Hms().format(time);
}

DateTime parseTime(String dateTime) {
  return DateFormat('HH:mm:ss').parse(dateTime);
}

int getTimeInMillis(String dateTime) {
  DateTime d = DateFormat('HH:mm:ss').parse(dateTime);
  return d.millisecondsSinceEpoch;
}

String durationStringFromStartAndEndMillis(int startTimeEpoch, int endTimeEpoch) {
  DateTime startTime = DateTime.fromMillisecondsSinceEpoch(startTimeEpoch);
  DateTime endTime = DateTime.fromMillisecondsSinceEpoch(endTimeEpoch);
  //String
  Duration diff = endTime.difference(startTime);
  return
      "${diff.inHours}:${diff.inMinutes.remainder(60)}:${(diff.inSeconds.remainder(60))}";

}

