import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  static final Log _instance = Log._internal();

  Log._internal();

  static var logger = Logger(printer: PrettyPrinter());

  static void v(dynamic data) {
    if (kDebugMode) {
      logger.d(data);
    }
  }
}
