part of 'my_approval_bloc.dart';

sealed class MyApprovalState extends Equatable {
  const MyApprovalState();

  @override
  List<Object> get props => [];
}

class MyApprovalLoading extends MyApprovalState {}

class MyApprovalLoaded extends MyApprovalState {
  final List<ApprovalRequest> pending;
  final List<ApprovalRequest> approved;
  final List<ApprovalRequest> rejected;
  const MyApprovalLoaded(
      {required this.pending, required this.approved, required this.rejected,});
}

class MyApprovalError extends MyApprovalState {
  final String message;

  const MyApprovalError(this.message);

  @override
  List<Object> get props => [message];
}

class ApproveRequestSuccess extends MyApprovalState{}

class ApproveRequestFailed extends MyApprovalState {
  final String error;
  const ApproveRequestFailed({required this.error});
}

class RejectRequestSuccess extends MyApprovalState{}
class RevokeRequestSuccess extends MyApprovalState{}

class RejectRequestFailed extends MyApprovalState {
  final String error;
  const RejectRequestFailed({required this.error});
}