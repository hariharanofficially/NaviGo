import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polar/polar.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/participant_model.dart';
import '../../../data/models/registered_device_model.dart';
// import '../../../data/repo/cache/cache_repo.dart';
import '../../../data/repo/repo.dart';

part 'tracker_steps_event.dart';
part 'tracker_steps_state.dart';

class TrackerStepsBloc extends Bloc<TrackerStepsEvent, TrackerStepsState> {
  Logger logger = new Logger();
  StreamSubscription<PolarDeviceInfo>? _polarScanListener;
  StreamSubscription<PolarDeviceInfo>? _polarDeviceConnectingListener;
  StreamSubscription<PolarDeviceInfo>? _polarDeviceConnectedListener;
  StreamSubscription<PolarDeviceDisconnectedEvent>?
      _polarDeviceDisconnectedListener;
  StreamSubscription<PolarBatteryLevelEvent>? _polarBatteryListener;

  StreamSubscription<BluetoothAdapterState>? _bluetoothAdapterStateSubscription;
  late List<RegisteredDevice> registeredDevices;
  late RegisteredDevice connectedDevice;
  late ParticipantModel? participant;
  late String userId;
  late bool isPaired;
  late String hrCensorId;
  bool _batteryTestPassed = false;
  static const dummyIdentifier = 'CA123456';
  final polar = Polar();

  TrackerStepsBloc() : super(TrackerStepsInitialState()) {
    on<TrackerStepsInitialEvent>((event, emit) async {
      userId = await cacheRepo.getString(name: 'userId');
      int batterValue = await cacheRepo.getInt(name: "batteryLevel");
      logger.d(batterValue);
      cacheRepo.setBoolean(name: "bluetoothasked", value: false);
      isPaired = await cacheRepo.getBoolean(name: "isPaired");
      connectedDevice = RegisteredDevice.initObject();

      List<RegisteredDevice> registeredDeviceList =
          await getRegisteredDeviceList(userId);
      _checkIsBlueToothEnabled(event, emit);
      emit(TrackerStepBluetoothViewState(
          registeredDevices: registeredDeviceList,
          connectedDevice: connectedDevice,
          isPaired: isPaired));
    });

    on<TrackerStepsBluetoothEnabledEvent>((event, emit) {
      logger.d("Bluetooth enabled");
      cacheRepo.setBoolean(name: "bluetoothasked", value: false);
      _checkForBlueToothPermissions(event, emit);
    });

    on<TrackerStepsBluetoothDisabledEvent>((event, emit) async {
      logger.d("Bluetooth not enabled");
      connectedDevice.paired = false;
      bool blueToothAsked = await cacheRepo.getBoolean(name: "bluetoothasked");
      if (!blueToothAsked) {
        cacheRepo.setBoolean(name: "bluetoothasked", value: true);
        emit(TrackerStepsShowBluetoothEnableDialogState());
      }
    });
    on<TrackerStepsPairDeviceEvent>((event, emit) async {
      await _pairAndConnectToDevice(event, emit);
    });
    on<TrackerStepsUnPairDeviceEvent>((event, emit) async {
      await _unpairAndConnectToDevice(event, emit);
    });
    on<TrackerStepsRegisteredDevicesUpdatedEvent>((event, emit) async {
      emit(TrackerStepsRegisteredDevicesUpdatedState(
          registeredDevices: event.registeredDevices));
    });
    on<TrackerStepsPairingEvent>((event, emit) async {
      emit(TrackerStepsPairingState());
    });
    on<TrackerStepsPairedEvent>((event, emit) async {
      emit(TrackerStepsPairedState());
      emit(TrackerStepGpsViewState(connectedDevice: this.connectedDevice));
    });
    on<TrackerStepsUnPairedEvent>((event, emit) async {
      emit(TrackerStepsUnPairedState(
          registeredDevices: event.registeredDevices,
          isPaired: event.isPaired));
    });

    // GPS enable event
    on<TrackerStepsEnableGpsEvent>((event, emit) async {
      await _checkForGpsPermissions(event, emit);
    });

    //tracker device add / popup
    on<TrackerStepsRegisterDeviceButtonEvent>((event, emit) {
      emit(TrackerStepsRegisterDevicePopupState());
    });
    on<TrackerStepsRegisterDeviceEvent>((event, emit) async {
      await _addNewTrackerDevice(event, emit);
    });
  }

  FutureOr<void> _checkIsBlueToothEnabled(
    TrackerStepsInitialEvent event,
    Emitter<TrackerStepsState> emit,
  ) async {
    _bluetoothAdapterStateSubscription?.cancel();
    _bluetoothAdapterStateSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        add(TrackerStepsBluetoothEnabledEvent());
      } else {
        add(TrackerStepsBluetoothDisabledEvent());
      }
    });
  }

  @override
  Future<void> close() async {
    _polarScanListener?.cancel();
    _polarDeviceConnectingListener?.cancel();
    _polarDeviceConnectedListener?.cancel();
    _polarDeviceDisconnectedListener?.cancel();
    _polarBatteryListener?.cancel();
    _bluetoothAdapterStateSubscription?.cancel();
    _polarBatteryListener?.cancel();
    super.close();
  }

  FutureOr<void> _checkForBlueToothPermissions(
    TrackerStepsBluetoothEnabledEvent event,
    Emitter<TrackerStepsState> emit,
  ) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      var androidApiVersion = androidInfo.version.sdkInt;
      if (androidApiVersion > 30) {
        //_blutoothDebugMessage += "=== inside permission check for > 30\n";
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();

        if (statuses[Permission.bluetoothScan] == PermissionStatus.granted &&
            statuses[Permission.bluetoothConnect] == PermissionStatus.granted) {
          //await _performBlActivities();
          await _listenToPolarDevices(event, emit);
        }
      } else {
        try {
          await polar.connectToDevice(dummyIdentifier,
              requestPermissions: true);
        } catch (e) {
          logger.e(e.toString());
        }
        await _listenToPolarDevices(event, emit);
      }
    } else if (Platform.isIOS) {
      var status = await Permission.bluetooth.isPermanentlyDenied;

      if (status == true) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          openAppSettings();
        });
        //
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();

        await _listenToPolarDevices(event, emit);

        // if (statuses[Permission.bluetoothScan] == PermissionStatus.granted &&
        //     statuses[Permission.bluetoothConnect] == PermissionStatus.granted) {
        //   //await _performBlActivities();

        // }
      }
    }
  }

  FutureOr<void> _listenToPolarDevices(
    TrackerStepsEvent event,
    Emitter<TrackerStepsState> emit,
  ) async {
    try {
      //if (!isPaired) {
      _polarScanListener =
          polar.searchForDevice().listen((PolarDeviceInfo deviceInfo) {
        //_blutoothDebugMessage += "=== inside search listen ${deviceInfo.deviceId}\n";
        logger.d('Found device in scan: ${deviceInfo.deviceId}');
        // bool found = false;
        for (var device in registeredDevices) {
          if (deviceInfo.deviceId == device.hrCensorId) {
            device.online = true;
          }
        }
        if (deviceInfo.deviceId == connectedDevice.hrCensorId) {
          connectedDevice.online = true;
        }

        if (!deviceInfo.isConnectable) {
          logger.d("=== bluetooth is connectable == false ");
          if (deviceInfo.deviceId == connectedDevice.hrCensorId) {
            connectedDevice.paired = false;
          }
        }
        if (!isPaired) {
          add(TrackerStepsRegisteredDevicesUpdatedEvent(
              registeredDevices: registeredDevices));
        }
      });
      // } else {
      //   _polarScanListener = null;
      //   _polarScanListener?.cancel();
      //}

      _polarBatteryListener = polar.batteryLevel.listen((e) async {
        logger.d('Battery: ${e.level}');
        cacheRepo.setInt(name: 'batteryLevel', value: e.level);
        _batteryTestPassed = true;
        add(TrackerStepsBatteryValueUpdatedEvent(batteryLevel: e.level));

        // LocationPermission permission = await Geolocator.checkPermission();
        //
        //   _batteryTestPassed = true;
        //   if (_processIndex == 0 && _pairClicked) {
        //     if (permission != LocationPermission.denied) {
        //       _enableGps();
        //     } else {
        //       _nextStep();
        //     }
        //     //_nextStep();
        //     _pairClicked = false;
        //   }
      });

      _polarDeviceConnectingListener = polar.deviceConnecting.listen((d) {
        logger.d('Device connecting ${d.deviceId}');
        logger.d('Device connecting ${d.isConnectable}');
        _batteryTestPassed = false;
        if (!d.isConnectable) {
          if (d.deviceId == connectedDevice.hrCensorId) {
            connectedDevice.paired = false;
            connectedDevice.online = false;
          }
        }
        add(TrackerStepsPairingEvent());
      });
      _polarDeviceConnectedListener = polar.deviceConnected.listen((d) {
        logger.d('Device connected');
        logger.d("registered device : count ${registeredDevices.length}");
        //_sendTrackerDeviceData(d);
        //_setDeviceStatus(d, "connected");
        for (var device in registeredDevices) {
          logger.d("device info : ${device.deviceName} ${device.deviceId}");
          logger.d("device d info : ${d.deviceId}");
          if (d.deviceId == device.hrCensorId) {
            connectedDevice = device;
            connectedDevice.online = true;
            connectedDevice.paired = true;
            cacheRepo.setString(name: 'myDeviceName', value: device.deviceName);
            cacheRepo.setInt(name: 'myTrackerId', value: device.deviceId);
            cacheRepo.setInt(name: 'myFrequency', value: device.frequency);
            cacheRepo.setString(
                name: 'myHeartRateCensorId', value: device.hrCensorId);
            cacheRepo.setBoolean(name: 'isConnected', value: true);
            cacheRepo.setBoolean(name: 'isPaired', value: true);
            //Integer deviceId = await cacheRepo.getInt(name: 'myTrackerId');
            logger.d(device.deviceId);
          }
        }
        add(TrackerStepsPairedEvent());
      });
      _polarDeviceDisconnectedListener =
          polar.deviceDisconnected.listen((d) async {
        logger.d('Device disconnected');
        cacheRepo.setString(name: 'myHeartRateCensorId', value: "");
        cacheRepo.setBoolean(name: 'isConnected', value: false);
        cacheRepo.setBoolean(name: 'isPaired', value: false);
        cacheRepo.setInt(name: 'myTrackerId', value: 0);
        cacheRepo.setInt(name: 'myFrequency', value: 0);
        connectedDevice = RegisteredDevice.initObject();
        this.isPaired = false;
        add(TrackerStepsUnPairedEvent(
            registeredDevices: this.registeredDevices,
            isPaired: this.isPaired));
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }

  FutureOr<void> _pairAndConnectToDevice(
    TrackerStepsPairDeviceEvent event,
    Emitter<TrackerStepsState> emit,
  ) async {
    await polar.connectToDevice(event.hrCensorId);
    Timer periodicTimer = Timer(const Duration(seconds: 20), () {
      if (!_batteryTestPassed) {
        logger.d(
            "Pairing is taking too long, pls check whether the device is online");
        //_showTakingLongMessage(context);
        emit(TrackerStepsPairingTakingTooLongState());
      } // Update user about remaining time
    });
    logger.d(periodicTimer);
  }

  FutureOr<void> _unpairAndConnectToDevice(
    TrackerStepsUnPairDeviceEvent event,
    Emitter<TrackerStepsState> emit,
  ) async {
    String sensorId = await cacheRepo.getString(name: 'myHeartRateCensorId');
    for (var device in registeredDevices) {
      if (device.hrCensorId == sensorId) {
        device.paired = false;
      }
    }
    cacheRepo.setString(name: 'myHeartRateCensorId', value: "");
    cacheRepo.setBoolean(name: 'isConnected', value: false);
    cacheRepo.setBoolean(name: 'isPaired', value: false);
    cacheRepo.setInt(name: 'myTrackerId', value: 0);
    cacheRepo.setInt(name: 'myFrequency', value: 0);
    await polar.disconnectFromDevice(event.hrCensorId);
  }

  FutureOr<void> _checkForGpsPermissions(
    TrackerStepsEnableGpsEvent event,
    Emitter<TrackerStepsState> emit,
  ) async {
    await BackgroundLocation.setAndroidNotification(
      title: 'EquineAppLocationBackground',
      message: 'EquineAppLocationBackground in progress',
      icon: '@mipmap/ic_launcher',
    );

    await BackgroundLocation.startLocationService();
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //nothing
    }
    this.participant = await trackerRepo.getTrackerParticipant(
        trackerDeviceId: connectedDevice.deviceId.toString());
    cacheRepo.setString(name: 'participantid', value: this.participant!.id.toString());
    emit(TrackerStepsEnabledGpsState());
    emit(TrackerStepGoliveViewState(
        connectedDevice: this.connectedDevice, participant: this.participant));
  }

  FutureOr<void> _addNewTrackerDevice(
    TrackerStepsRegisterDeviceEvent event,
    Emitter<TrackerStepsState> emit,
  ) async {
    ApiResponse response = await trackerRepo.postNewTrackerData(
        deviceId: event.deviceId, deviceName: event.name, macId: event.macId);
    if (response.statusCode == 200) {
      registeredDevices = await getRegisteredDeviceList(userId);
      emit(TrackerStepsRegisteredDevicesUpdatedState(
          registeredDevices: registeredDevices));
    } else {
      emit(TrackerStepsAddRegisterDeviceErrorState());
    }
  }

  Future<List<RegisteredDevice>> getRegisteredDeviceList(String userId) async {
    registeredDevices =
        await trackerRepo.getRegisteredDevicesByUserId(userId: userId);
    hrCensorId = await cacheRepo.getString(name: "myHeartRateCensorId");
    isPaired = await cacheRepo.getBoolean(name: "isPaired");
    for (RegisteredDevice device in registeredDevices) {
      if (isPaired && device.hrCensorId == hrCensorId) {
        device.online = true;
        device.paired = true;
        connectedDevice = device;
      }
    }
    return registeredDevices;
  }
}
