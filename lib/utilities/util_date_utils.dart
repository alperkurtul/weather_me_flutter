import 'package:intl/intl.dart';

class UTILDateUtils {
  static String utcTimeInMillisecondsAsFormattedString(
      [String? format, int? timezoneInMilliseconds]) {
    // Current GMT time
    if (format == null || format == '') {
      format = 'yyyy-MM-dd HH:mm:ss';
    }
    if (timezoneInMilliseconds == null) {
      timezoneInMilliseconds = 0;
    }
    final DateFormat _dateFormat = DateFormat(format);

    int timeInMilliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;

    timeInMilliseconds = timeInMilliseconds + timezoneInMilliseconds;

    return _dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds, isUtc: true));
  }

  static DateTime utcTimeAsDateTime() {
    // Current GMT time
    return DateTime.now().toUtc();
  }

  // Current GMT time
  static int get utcTimeInMilliseconds =>
      DateTime.now().toUtc().millisecondsSinceEpoch;
}
