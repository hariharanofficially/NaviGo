import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

import 'app/config/server_config.dart';
import 'app/my_app.dart';
import 'data/repo/repo.dart';
import 'data/service/service.dart';

void main()  {
  runZonedGuarded(() async {

    if (kReleaseMode) {
      await dotenv.load(fileName: "assets/config/.env.prod");
    } else {
      await dotenv.load(fileName: "assets/config/.env.dev");
    }

    if (ServerConfig.logLevel == 'WARN') {
      Logger.level = Level.warning;
    } else if (ServerConfig.logLevel == 'ERROR') {
      Logger.level = Level.error;
    } else {
      Logger.level = Level.debug;
    }

    initService();
    initRepo();

    apiService.init(baseUrl: ServerConfig.baseUrl);

    Bloc.observer = TalkerBlocObserver();

    runApp(const MyApp());
    schedulerService.startScheduler();
  }, (error, stack) {
    debugPrint("Error: $error");
  });
}
