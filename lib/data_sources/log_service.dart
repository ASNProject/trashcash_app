import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LogService {
  static Logger? _logger;

  static void _checkIsInitiated() {
    if (_logger == null) {
      throw Exception('LogService is not initited yet!');
    }
  }

  static void init({bool usePrettyPrinter = false}) {
    _logger = Logger(printer: usePrettyPrinter ? PrettyPrinter() : null);
  }

  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _checkIsInitiated();
    if (kDebugMode) {
      _logger?.d(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _checkIsInitiated();
    if (kDebugMode) {
      _logger?.i(message, error: error, stackTrace: stackTrace);
    }
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _checkIsInitiated();
    if (kDebugMode) {
      _logger?.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void warning(
      dynamic message, [
        dynamic error,
        StackTrace? stackTrace,
      ]) {
    _checkIsInitiated();
    if (kDebugMode) {
      _logger?.w(message, error: error, stackTrace: stackTrace);
    }
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _checkIsInitiated();
    if (kDebugMode) {
      _logger?.wtf(message, error: error, stackTrace: stackTrace);
    }
  }

  static void verbose(
      dynamic message, [
        dynamic error,
        StackTrace? stackTrace,
      ]) {
    _checkIsInitiated();
    if (kDebugMode) {
      _logger?.v(message, error: error, stackTrace: stackTrace);
    }
  }
}
