part of 'my_approval_bloc.dart';

sealed class MyApprovalEvent extends Equatable {
  const MyApprovalEvent();

  @override
  List<Object> get props => [];
}

class LoadMyApproval extends MyApprovalEvent {
  // final String id;
  const LoadMyApproval();
  @override
  List<Object> get props =>[];
}

class ApproveRequestEvent extends MyApprovalEvent {
  final String id;
  const ApproveRequestEvent({required this.id});
}

class RejectRequestEvent extends MyApprovalEvent {
  final String id;
  const RejectRequestEvent({required this.id});
}

class RevokeRequestEvent extends MyApprovalEvent {
  final String id;
  const RevokeRequestEvent({required this.id});
}
