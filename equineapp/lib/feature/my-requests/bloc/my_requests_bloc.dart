import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/approvalRequest_model.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/service.dart';

part 'my_requests_event.dart';
part 'my_requests_state.dart';

class MyRequestsBloc extends Bloc<MyRequestsEvent, MyRequestsState> {
  MyRequestsBloc() : super(MyRequestsLoading()) {
    on<LoadMyRequests>((event, emit) async{
      try {

        final String userId = await cacheService.getString(name: 'userId');
        final List<ApprovalRequest> response = await approvalrepo.getRequestsByUser(id: userId);

        emit(MyRequestsLoaded(
            request: response,
           ));
      } catch (e) {
        emit(MyRequestsError("Failed to load My requests"));
      }
    });
  }
}
