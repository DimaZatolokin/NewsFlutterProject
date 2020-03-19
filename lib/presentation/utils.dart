import 'package:intl/intl.dart';

const APP_DATE_FORMAT = "yyyy-MMMM-dd";
const SERVER_DATE_FORMAT = "yyyy-MM-dd";

class DateTimeUtils {
  static String getReadableDate(String serverDate) {
    var dateFormat = DateFormat(SERVER_DATE_FORMAT).parse(serverDate);
    return DateFormat(APP_DATE_FORMAT).format(dateFormat).toString();
  }
}
