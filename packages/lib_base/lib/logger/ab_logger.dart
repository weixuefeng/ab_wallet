import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:developer' as developer;

class MyConsoleOutput extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(developer.log);
  }
}

class ABLogger {
  static final ABLogger _instance = ABLogger._internal();
  static final Logger logger = _createLogger();

  factory ABLogger() {
    return _instance;
  }

  ABLogger._internal();

  // 生成 logger 单例
  static Logger _createLogger() {
    return Logger(printer: PrettyPrinter());
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
