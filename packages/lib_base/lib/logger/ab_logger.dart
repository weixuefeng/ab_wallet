import 'package:logger/logger.dart';

class ABLogger {
  static final ABLogger _instance = ABLogger._internal();
  static final Logger logger = _createLogger();

  factory ABLogger() {
    return _instance;
  }

  ABLogger._internal();

  // 生成 logger 单例
  static Logger _createLogger() {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  static void i(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    logger.i(message, time: time, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    logger.w(message, time: time, error: error, stackTrace: stackTrace);
  }

  static void d(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    logger.d(message, time: time, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    logger.e(message, time: time, error: error, stackTrace: stackTrace);
  }

  static void t(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    logger.t(message, time: time, error: error, stackTrace: stackTrace);
  }
}
