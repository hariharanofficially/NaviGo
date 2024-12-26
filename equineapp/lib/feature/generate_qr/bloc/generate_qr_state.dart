// qr_state.dart

import 'package:equatable/equatable.dart';

import '../../../data/models/getmodel.dart';
// qr_state.dart

abstract class QrState extends Equatable {
  const QrState();

  @override
  List<Object> get props => [];
}

// Initial state
class QrInitial extends QrState {}

// State when roles are being fetched
class FetchingRoles extends QrState {}

// State when roles are fetched successfully
class FetchRolesSuccess extends QrState {
  final List<RoleModel> roles;

  const FetchRolesSuccess(this.roles);

  @override
  List<Object> get props => [roles];
}

// State when there is an error fetching roles
class FetchRolesError extends QrState {
  final String message;

  const FetchRolesError(this.message);

  @override
  List<Object> get props => [message];
}

// State when the QR code is being generated
class GeneratingQr extends QrState {}

// State when the QR code is generated successfully
class GenerateQrLoaded extends QrState {
  final String qrCode;
  final String sharecode;

  const GenerateQrLoaded(this.qrCode, this.sharecode);

  @override
  List<Object> get props => [qrCode, sharecode];
}

// State when there is an error generating the QR code
class GenerateQrError extends QrState {
  final String message;

  const GenerateQrError(this.message);

  @override
  List<Object> get props => [message];
}
