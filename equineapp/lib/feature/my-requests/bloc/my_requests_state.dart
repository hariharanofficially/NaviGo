part of 'my_requests_bloc.dart';

sealed class MyRequestsState extends Equatable {
  const MyRequestsState();

  @override
  List<Object> get props => [];
}

class MyRequestsLoading extends MyRequestsState {}

class MyRequestsLoaded extends MyRequestsState {
  final List<ApprovalRequest> request;
  const MyRequestsLoaded({
    required this.request,
  });
}

class MyRequestsError extends MyRequestsState {
  final String message;

  const MyRequestsError(this.message);

  @override
  List<Object> get props => [message];
}
