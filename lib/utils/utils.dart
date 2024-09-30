import 'package:intl/intl.dart';

class Utils {
  /// A utility function to modify the API date to local client date.
  static String dateFormatter(String? date) {
    if (date == null) {
      return 'Can\'t format the date';
    }

    //Input Pattern
    DateFormat inputFormat = DateFormat("yyyy-M-d"); // Input pattern
    DateTime parsedInputDate = inputFormat.parse(date);

    //Output Pattern
    DateFormat outputFormat = DateFormat("yyyy-MMM-dd");
    String formattedDate = outputFormat.format(parsedInputDate);

    return formattedDate;
  }

  //Api Date format
  static DateFormat apiDateFormatter() {
    return DateFormat('yyyy-M-d');
  }
}
