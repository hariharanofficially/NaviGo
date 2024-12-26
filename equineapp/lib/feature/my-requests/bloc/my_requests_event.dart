part of 'my_requests_bloc.dart';

sealed class MyRequestsEvent extends Equatable {
  const MyRequestsEvent();

  @override
  List<Object> get props => [];
}

class LoadMyRequests extends MyRequestsEvent {
  // final String id;
  const LoadMyRequests();
  @override
  List<Object> get props =>[];
}
