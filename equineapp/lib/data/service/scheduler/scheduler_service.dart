import 'package:latlong2/latlong.dart';
abstract class SchedulerService {
  Future<void> startScheduler();
  List<LatLng> getRoutePoints();
}