import 'dart:async';
// import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';

//import 'package:EquineApp/common/WebSocket.dart';
//import 'package:EquineApp/common/DBService.dart';
import 'package:background_location/background_location.dart';
import 'package:cron/cron.dart';
import 'package:geolocator/geolocator.dart';
//import 'Env.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:polar/polar.dart';

import '../../models/api_response.dart';
import '../../models/transaction.dart';
import '../../repo/repo.dart';
import '../service.dart';
import 'scheduler_service.dart';

class SchedulerServiceImpl extends SchedulerService {
  static final polar = Polar();
  StreamSubscription<Position>? _geoStream = null;
  StreamSubscription<PolarStreamingData<PolarHrSample>>? _polarStream = null;
  StreamSubscription<PolarDeviceInfo>? _polarScanListener;
  var logger = Logger();

  static List<LatLng> latlng = [];
  bool dbToWsPush = false;
  double currentLat = 0;
  double currentLong = 0;
  double currentSpeed = 0;

  double currentLatFromGeoStream = 0;
  double currentLongFromGeoStream = 0;
  double currentSpeedFromGeoStream = 0;

  String currentHr = "";
  double trackDistance = 0;
  int hrValue = 0;
  String currentSpeedInKm = "";

  dynamic backgroundLocationService;

  Future<void> startScheduler() async {
    //logger.d("cron started ");
    final cron = Cron();
    //_initialize_background_location();
    if (backgroundLocationService == null) {
      await BackgroundLocation.startLocationService();
      executeLocationCron();
    }

    try {

      cron.schedule(Schedule.parse('*/2 * * * * *'), () async {
        await executeCron();
      });

      //await Future.delayed(Duration(seconds: 20));
    } on ScheduleParseException {
      // "ScheduleParseException" is thrown if cron parsing is failed.
      await cron.close();
    }
  }

  void _initialize_background_location() async {
    await BackgroundLocation.setAndroidNotification(
      title: 'EquineAppLocationBackground',
      message: 'EquineAppLocationBackground in progress',
      icon: '@mipmap/ic_launcher',
    );

    executeLocationCron();
  }

  Future<void> executeLocationCron() async {
    //await BackgroundLocation.startLocationService();

    backgroundLocationService =
        BackgroundLocation.getLocationUpdates((location) {
     // logger.d('This is current Location ' + location.toMap().toString());
      currentLat = location.latitude ?? 0;
      currentLong = location.longitude ?? 0;
      currentSpeed = location.speed ?? 0;
    });

    //await BackgroundLocation.stopLocationService();
  }

  Future<void> executeCron() async {
    bool isLoggedIn = await cacheRepo.getBoolean(name: "isLoggedIn");
    bool runEnabled = await cacheRepo.getBoolean(name: "isRunEnabled");
    bool shareEnabled = await cacheRepo.getBoolean(name: "isShareEnabled");

    bool polarStreamStarted =
        await cacheRepo.getBoolean(name: "polarStreamStarted");
    bool geoStreamStarted =
        await cacheRepo.getBoolean(name: "geoStreamStarted");
    // logger.d("=== run enabled" + runEnabled.toString());
    // logger.d("=== share enabled" + shareEnabled.toString());
    //
    // // BackgroundLocation.getLocationUpdates((location) {
    //   print('=== This is location update Location ' + location.toMap().toString());
    // });

    // Location location = await BackgroundLocation().getCurrentLocation().then((location) {
    //   print('=== This is current Location ' + location.toMap().toString());
    // });

    // call validate token call to make sure the session is still active.
    if (isLoggedIn) {
      try {
        ApiResponse response = await authRepo.postValidate();
        if (response.statusCode == 200) {
          //logger.d("validation success");
        } else {
          logger.d("validation failed");
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    if (isLoggedIn) {
    if (runEnabled) {
      logger.d("START TRACKING");

      if (backgroundLocationService == null) {
        await BackgroundLocation.startLocationService();
        executeLocationCron();
      }
      _initiate_bluetooth_search();
      _streamWhenReady();
      _getSpeed();
      _sendDataViaWS(await prepareDataToSend());
    } else {
      //logger.d("STOP TRACKING");
      _polarStream?.cancel();
      _polarStream = null;
      _geoStream?.cancel();
      _geoStream = null;
      pushFromDb();
      websocketService.deActivate();
      await await BackgroundLocation.stopLocationService();
      backgroundLocationService = null;
      cacheRepo.setBoolean(name: 'polarStreamStarted', value: false);
      cacheRepo.setBoolean(name: 'geoStreamStarted', value: false);
      latlng.clear();
      }
    }
  }

  void _initiate_bluetooth_search() async {
    if (_polarScanListener == null) {
      _polarScanListener =
          polar.searchForDevice().listen((PolarDeviceInfo deviceInfo) {
        logger.d("======== found device ${deviceInfo.deviceId}");
      });
    }
  }

  void _streamWhenReady() async {
    String identifier = await cacheRepo.getString(name: "myHeartRateCensorId");

    if (identifier.isNotEmpty) {
      //identifier != null &&
      var availabletypes = null;

      try {
        availabletypes =
            await polar.getAvailableOnlineStreamDataTypes(identifier);
        logger.d('available types: $availabletypes');
        if (hrValue == 0) {
          polar.connectToDevice(identifier);
        }

        if (availabletypes != null &&
            availabletypes.contains(PolarDataType.hr) &&
            _polarStream == null) {
          _polarStream ??= polar.startHrStreaming(identifier).listen((e) {
            hrValue = e.samples[0].hr;
            cacheRepo.setBoolean(name: 'polarStreamStarted', value: true);
            logger.d('Heart rate: $hrValue');
            currentHr = hrValue.toString();
          });
        }
      } catch (e) {
        logger.e(e);
        //await polar.disconnectFromDevice(identifier);
        _polarStream?.cancel();
        _polarStream = null;
        polar.connectToDevice(identifier);
      }
    }
  }

  void _getSpeed() async {
    var positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 2,
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );

    double lat = currentLat;
    double longi = currentLong;
    double speedInMps = currentSpeed;

    _geoStream ??= positionStream.listen((position) async {
      //Position? position = await Geolocator.getCurrentPosition();
      cacheService.setBoolean(name: 'geoStreamStarted', value: true);
      if (position.latitude == 0 || position.longitude == 0) {
        //position.latitude == null || position.longitude == null
        logger.d("position not null ..  data from geolocator");
        currentLatFromGeoStream = position.latitude;
        currentLongFromGeoStream = position.longitude;
        currentSpeedFromGeoStream = position.speed;
      }
    });

// &&
    // currentLatFromGeoStream != null &&
    // currentLongFromGeoStream != null
    if (currentLatFromGeoStream != 0 && currentLongFromGeoStream != 0) {
      lat = currentLatFromGeoStream;
      longi = currentLongFromGeoStream;
      speedInMps = currentSpeedFromGeoStream;
    }

    //double distance = 0;
    //double trackDistance = prefs.getDouble('trackDistance') ?? 0;
    LatLng lastLatLng = LatLng(lat, longi);
    var speedInKmpH = speedInMps * 3.6;
    currentSpeedInKm = speedInKmpH.toStringAsFixed(1);

    if (latlng.isEmpty) {
      latlng.add(LatLng(lat, longi));
      trackDistance = 0;
      //prefs.setDouble('trackDistance', trackDistance);
      //prefs.setString('speedvalue', currentSpeedInKm);
      if (lat != 0 && longi != 0) {
        currentLat = lat;
        currentLong = longi;
        // prefs.setString('currentlat', lat.toString());
        // prefs.setString('currentlong', longi.toString());
      }
    }

    if (latlng.isNotEmpty) {
      lastLatLng = latlng.last;
      double distance = Geolocator.distanceBetween(
          lastLatLng.latitude, lastLatLng.longitude, lat, longi);

      if (distance > 0 && distance < 2000) {
        distance = distance / 1000;
        //prefs.setDouble('trackDistance', trackDistance + distance);
        trackDistance = trackDistance + distance;
        latlng.add(LatLng(lat, longi));

        logger.d("speed : $currentSpeed");
        logger.d("latlong : $lat $longi");
        var progress = speedInKmpH.round();
        //prefs.setString('speedvalue', currentSpeedInKm);
        if (lat != 0 && longi != 0) {
          currentLat = lat;
          currentLong = longi;
          // prefs.setString('currentlat', lat.toString());
          // prefs.setString('currentlong', longi.toString());
        }
      }
    }
  }

  List<LatLng> getRoutePoints() {
    if (latlng.isNotEmpty) {
      return latlng;
    } else {
      List<LatLng> t_latlng = [];
      t_latlng.add(LatLng(currentLat, currentLong));
      return t_latlng;
    }
  }

  Future<LatLng> getLastKnownLatLng() async {
    Position? position = await Geolocator.getLastKnownPosition();
    return LatLng(
        position?.latitude ?? currentLat, position?.longitude ?? currentLong);
  }

  Future<Transaction> prepareDataToSend() async {
    Position? position = await Geolocator.getLastKnownPosition();
    logger.d("preparing to send ");

    String formattedDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
    int trackerid = await cacheRepo.getInt(name: "myTrackerId");
    String eventid = await cacheRepo.getString(name: "eventid");
    String participantid = await cacheRepo.getString(name: "participantid");
    logger.d("trackerid : " + trackerid.toString());
    logger.d("eventid : " + eventid);
    logger.d("participantid : " + participantid);
    // participantid = '20';
    // eventid = '67';

    Transaction transaction = new Transaction(id: 0,
        trackerdeviceid: trackerid.toString(),
        eventId: eventid,
        participantid: participantid,
        time: formattedDate,
        speed: currentSpeedInKm,
        hr: currentHr,
        latitude: currentLat.toString(),
        logitude: currentLong.toString(),
        distance: trackDistance.toString());

    Map data = {};
    data["trackerFeed"] = transaction.toMap();
    // Map data1 = {
    //   "trackerFeed": {
    //     "trackerDeviceId": prefs.getInt('myTrackerId'),
    //     "eventId": prefs.getString('eventid'),
    //     "participantId": prefs.getString('participantid'),
    //     "dateTime": formattedDate,
    //     "latitude": prefs.getString('currentlat'),
    //     "longitude": prefs.getString('currentlong'),
    //     // "latitude": position?.latitude,
    //     // "longitude": position?.longitude,
    //     "heartRate": prefs.getInt('hrvalue') ?? 0,
    //     "speed": prefs.getString('speedvalue') ?? 0,
    //     "distance": prefs.getDouble('trackDistance') ?? 0,
    //   }
    // };
    return transaction;
  }

  Future<void> _sendDataViaApi(Transaction transaction) async {
    logger.d(" OLD :: data to be sent to backend ===");
    try {
      Map data = {};
      data["trackerFeed"] = transaction.toMap();
      logger.d(data);
      ApiResponse response = await trackerRepo.postTrackerFeed(data: data);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.data.toString());
      } else {
        var data = jsonDecode(response.data.toString());
        logger.d(data);
        logger.e('tracker feed failed');
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void _sendDataViaWS(Transaction transaction) async {
    bool shareEnabled = await cacheRepo.getBoolean(name: "isShareEnabled");
    logger.d("SEND DATA");

    bool isInternetConnectionExists = await checkInternetConnectivity();
    if (isInternetConnectionExists && shareEnabled) {
      Map data = {};
      data["trackerFeed"] = transaction.toMap();
      logger.d(data);
      logger.d("-==== data to be sent to backend ===");
      websocketService.sendFeed(data);
    } else {
      logger.d("-==== data saved to db ===");
      // String formattedDate =
      // DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
      // Transaction tran = new Transaction(id: 0,
      //     trackerdeviceid: data['trackerFeed']['trackerDeviceId'].toString(),
      //     eventId: data['trackerFeed']['eventId'].toString(),
      //     participantid: data['trackerFeed']['participantId'].toString(),
      //     time: formattedDate,
      //     speed: data['trackerFeed']['speed'].toString(),
      //     hr: data['trackerFeed']['heartRate'].toString(),
      //     latitude: data['trackerFeed']['latitude'].toString(),
      //     logitude: data['trackerFeed']['longitude'].toString(),
      //     distance: data['trackerFeed']['distance'].toString());
      dbService.insert(transaction);
    }
  }

  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      logger.e('not connected');
      return false;
    }
  }

  Future<void> pushFromDb() async {
    dbToWsPush = true;
    bool isInternetConnectionExists = await checkInternetConnectivity();
    if (isInternetConnectionExists) {
      logger.d("==== pushFromDbToWs - triggered ===");
      List<Transaction> list = [];
      list = await dbService.get(10);
      while (list.isNotEmpty) {
        if (list.isNotEmpty) {
          for (Transaction t in list) {
            //await sendFeedViaWS(prepareDataFromDb(l));
            await _sendDataViaApi(t);
            await dbService.delete(t.id);
          }
        }
        list = await dbService.get(10);
      }
      logger.d("==== pushFromDbToWs - sent all to WS ===");
      dbToWsPush = false;
    } else {
      dbToWsPush = false;
    }
  }

  // Map prepareDataFromDb(Map map)  {
  //   DateTime datetime = DateTime.fromMillisecondsSinceEpoch(map["timeinepoch"]);
  //   String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(datetime);
  //   Map data = {
  //     "trackerFeed": {
  //       "trackerDeviceId": map["trackerdeviceid"],
  //       "eventId": map["eventid"],
  //       "participantId": map["participantid"],
  //       "dateTime": formattedDate,
  //       "latitude": map["latitude"],
  //       "longitude": map["longitude"],
  //       "heartRate": map["hr"],
  //       "speed": map["speed"],
  //       "distance": map["distance"],
  //     }
  //   };
  //   return data;
  // }
}
