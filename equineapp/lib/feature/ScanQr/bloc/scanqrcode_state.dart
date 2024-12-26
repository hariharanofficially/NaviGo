
// scanqrcode_state.dart
part of 'scanqrcode_bloc.dart';

// States
abstract class QRScannerState {}

class QRScannerInitial extends QRScannerState {}

class QRCodeScannedState extends QRScannerState {
  final String code;
  QRCodeScannedState(this.code);
}

class QRScannerLoading extends QRScannerState {}

class QRCodeSubmitSuccess extends QRScannerState {}

class QRCodeSubmitFailure extends QRScannerState {}
