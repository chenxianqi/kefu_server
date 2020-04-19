class DateTimeUtil {
  static String dateTimeNowIso() => DateTime.now().toIso8601String();
  static int dateTimeNowMilli() => DateTime.now().millisecondsSinceEpoch;
}