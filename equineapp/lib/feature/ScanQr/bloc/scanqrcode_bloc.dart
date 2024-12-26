import 'package:bloc/bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../data/repo/repo.dart';
part 'scanqrcode_event.dart';
part 'scanqrcode_state.dart';

// Bloc
class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  QRViewController? controller;
  bool isFlashOn = false;

  QRScannerBloc() : super(QRScannerInitial()) {
    on<QRCodeScanned>((event, emit) async {
      emit(QRCodeScannedState(event.code));
    });

    on<QRCodeSubmit>((event, emit) async {
      try {
        emit(QRScannerLoading());
        // Call the validateshare API with the code
        final response = await sharerepo.validateshare(codename: event.code);
        if (response.statusCode == 200) {
          emit(QRCodeSubmitSuccess());
        } else {
          emit(QRCodeSubmitFailure());
        }
      } catch (e) {
        emit(QRCodeSubmitFailure());
      }
    });
  }
}
