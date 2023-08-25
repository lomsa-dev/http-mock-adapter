import 'package:logger/logger.dart';

getLogger(bool printLogs) {
  return Logger(
    level: printLogs ? Level.debug : Level.off,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );
}
