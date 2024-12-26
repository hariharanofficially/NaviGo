// qr_bloc.dart

import 'package:EquineApp/data/repo/repo.dart';
import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_event.dart';
import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/getmodel.dart';
import '../../../data/service/service.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  Logger logger = Logger();
  QrBloc() : super(QrInitial()) {
    on<FetchRoles>(_onFetchRoles);
    on<RoleSelected>(_onRoleSelected);
  }

  Future<void> _onFetchRoles(FetchRoles event, Emitter<QrState> emit) async {
    emit(FetchingRoles());
    try {
      final roles = await sharerepo.getroles(); // Fetch roles from repo
      emit(FetchRolesSuccess(roles));
    } catch (error) {
      emit(FetchRolesError('Failed to fetch roles: ${error.toString()}'));
    }
  }

  Future<void> _onRoleSelected(
      RoleSelected event, Emitter<QrState> emit) async {
    emit(GeneratingQr());
    try {
      final ApiResponse response =
          await sharerepo.postsharecodes(roleId: event.roleId);
      final String qrCode = await cacheService.getString(name: 'qrCode');
      final String sharecode = await cacheService.getString(name: 'sharecode');

      if (response.statusCode == 200 && response.data != null) {
        emit(GenerateQrLoaded(
          qrCode, sharecode,
          // response.data as String,
        )); // Assuming data is QR code as String
      } else {
        emit(GenerateQrError('Failed to load QR code'));
      }
    } catch (e) {
      emit(GenerateQrError('An error occurred'));
    }
  }
}
