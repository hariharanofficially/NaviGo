import 'package:get_it/get_it.dart';

import 'api/api_service.dart';
import 'api/api_service_impl.dart';
import 'cache/cache_service.dart';
import 'cache/cache_service_impl.dart';
import 'db/db_service.dart';
import 'db/db_service_impl.dart';
import 'httpapi/httpapi_service.dart';
import 'httpapi/httpapi_service_impl.dart';
import 'scheduler/scheduler_service.dart';
import 'scheduler/scheduler_service_impl.dart';
import 'websocket/websocket_service.dart';
import 'websocket/websocket_service_impl.dart';


final getIt = GetIt.instance;

void initService() {
  getIt.registerLazySingleton<SchedulerService>(() => SchedulerServiceImpl());
  getIt.registerLazySingleton<WebsocketService>(() => WebsocketServiceImpl());
  getIt.registerLazySingleton<DbService>(() => DbServiceImpl());
  getIt.registerLazySingleton<ApiService>(() => ApiServiceImpl());
  getIt.registerLazySingleton<CacheService>(() => CacheServiceImpl());
  getIt.registerLazySingleton<HttpApiService>(() => HttpApiServiceImpl());
}

SchedulerService get schedulerService => getIt.get<SchedulerService>();
WebsocketService get websocketService => getIt.get<WebsocketService>();
DbService get dbService => getIt.get<DbService>();
ApiService get apiService => getIt.get<ApiService>();
CacheService get cacheService => getIt.get<CacheService>();
HttpApiService get httpApiService => getIt.get<HttpApiService>();
