// qr_event.dart

import 'package:equatable/equatable.dart';

abstract class QrEvent extends Equatable {
  const QrEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch roles
class FetchRoles extends QrEvent {}

// Event when a role is selected and QR code generation is requested
class RoleSelected extends QrEvent {
  final String roleId;

  RoleSelected(this.roleId);
}
