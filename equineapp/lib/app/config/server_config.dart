import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServerConfig {
  static String baseUrl = dotenv.env['AUTH_HOST_URL'] ?? "https://mindari.ae:7449/";

  static String get logLevel => dotenv.env['LOG_LEVEL'] ?? 'ERROR';

  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0';
  // static String get authHostUrl =>
  //     dotenv.env['AUTH_HOST_URL'] ?? '/tracker/mindari-auth';

  static String get authHostUrl =>
      dotenv.env['AUTH_HOST_URL'] ?? '/mindari-auth';

  static String get trackerHostUrl =>
      dotenv.env['TRACKER_HOST_URL'] ??
      'https://mindari.ae:7449/tracker/mindari-tracker';
  static String get wsHostUrl =>
      dotenv.env['WS_URL'] ?? 'ws://mindari.ae:7450/mindari-tracker/web/socket';

  static String get appCommunicationKey =>
      dotenv.env['APP_COMMUNICATION_KEY'] ?? 'Mindari@123';
}
