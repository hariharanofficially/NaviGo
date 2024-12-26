import 'package:stomp_dart_client/stomp.dart';
abstract class WebsocketService {
  StompClient getClient();
  Future<void> activate();
  Future<void> deActivate();
  Future<void> sendFeed(Map data);
}