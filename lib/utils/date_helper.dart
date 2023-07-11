import 'package:intl/intl.dart';

String formatDate(String date) {
  if (date.isEmpty) {
    return '';
  }
  var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var inputDate = inputFormat.parse(date);
  var outputFormat = DateFormat('dd MMM yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

extension DateHelper on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day;
  }
}