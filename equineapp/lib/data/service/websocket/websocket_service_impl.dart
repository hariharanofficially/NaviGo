import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

import '../../../app/config/server_config.dart';
import 'websocket_service.dart';

class WebsocketServiceImpl extends WebsocketService {
  Logger logger = new Logger();
  final stompClient = StompClient(
    config: StompConfig(
      url: ServerConfig.wsHostUrl,
      connectionTimeout: Duration(seconds: 10),
      //onConnect: onConnect,
      beforeConnect: () async {
       //logger.d("Websocket connecting ...");
        //await Future.delayed(const Duration(milliseconds: 200));
      },
      onWebSocketError: (dynamic error) => print(error.toString()),
      //stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
      //webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
    ),
  );

  StompClient getClient() {
    return stompClient;
  }
  Future<void> activate() async {
    if (!stompClient.connected) {
      logger.d("=== websocket not connected . Connecting ... ");
      stompClient.activate();
    }
  }

  Future<void> sendFeed(Map data) async {
    activate();
    String participantId = data["trackerFeed"]["participantId"];
    stompClient.send(
      destination: '/app/feed/${participantId}',
      body: json.encode(data),
    );
  }

  Future<void> deActivate() async {
    if (!stompClient.connected) {
      logger.d("=== websocket disconnecting ");
      stompClient.deactivate();
    }
  }
}
