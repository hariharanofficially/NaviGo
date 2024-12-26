// scanqrcode_event.dart
part of 'scanqrcode_bloc.dart';
// Events
abstract class QRScannerEvent {}

class QRCodeScanned extends QRScannerEvent {
  final String code;
  QRCodeScanned(this.code);
}
class QRCodeSubmit extends QRScannerEvent {
  final String code;
  QRCodeSubmit({required this.code});
}
