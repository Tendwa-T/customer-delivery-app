import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Configured global logger instance.
///
/// In debug/profile mode (non-release), it prints all logs.
/// In release mode, it only prints error and fatal logs.
final Logger logger = Logger(
  filter: ProductionFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
  level: kReleaseMode ? Level.error : Level.all,
);
