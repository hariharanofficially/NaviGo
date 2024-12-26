import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/approvalRequest_model.dart';
import '../../../data/repo/repo.dart';
import '../../../data/service/service.dart';

part 'my_approval_event.dart';
part 'my_approval_state.dart';

class MyApprovalBloc extends Bloc<MyApprovalEvent, MyApprovalState> {
  Logger logger = new Logger();
  MyApprovalBloc() : super(MyApprovalLoading()) {
    on<LoadMyApproval>((event, emit) async {
      try {
        final String tenantId = await cacheService.getString(name: 'tenantId');
        final List<ApprovalRequest> response = await approvalrepo.getApprovalsByTenant(id: tenantId);
        List<ApprovalRequest> pendingApprovals = [];
        List<ApprovalRequest> approvedApprovals = [];
        List<ApprovalRequest> rejectedApprovals = [];
        if (response.length > 0 ) {
          response.forEach( (req) => {
            // Assuming data is QR code as String
            if (req.approvalStatus == 'pending') {
              pendingApprovals.add(req)
            } else if (req.approvalStatus == 'approved') {
              approvedApprovals.add(req)
            } else if (req.approvalStatus == 'rejected') {
              rejectedApprovals.add(req)
            }
          });
        }

        // final MyApproval = ['Pending1', 'Pending2', 'Pending3'];
        // final MyApproval2 = ['Approved1', 'Approval2', 'Approval3'];
        // final MyApproval3 = ['Reject1', 'Reject2', 'Reject3'];
        emit(MyApprovalLoaded(
            pending: pendingApprovals,
            approved: approvedApprovals,
            rejected: rejectedApprovals));
      } catch (e) {
        emit(MyApprovalError("Failed to load MyApproval"));
      }
    });

    on<ApproveRequestEvent>((event, emit) async {
      var userId = await cacheService.getString(name: 'userId');
      Map data={
        "approval": {
          "id": event.id,
          "approvalBy": {
            "id": userId
          },
          "approvalStatus":"approved"
        }
      };
      logger.d(data);
    try{
      final response = await approvalrepo.postApprovalStatus(data:data);

      if (response.statusCode == 200 && response.error.isEmpty) {
        logger.d("Approve request success");
        emit(ApproveRequestSuccess());
        add(LoadMyApproval());
      } else {
        emit(ApproveRequestFailed(error: response.message));
      }
    }  catch (error) {
      emit(ApproveRequestFailed(error: error.toString()));
    }
    });

    on<RejectRequestEvent>((event, emit) async {
      var userId = await cacheService.getString(name: 'userId');
      Map data={
        "approval": {
          "id": event.id,
          "approvalBy": {
            "id": userId
          },
          "approvalStatus":"rejected"
        }
      };
      logger.d(data);
      try{
        final response = await approvalrepo.postApprovalStatus(data:data);

        if (response.statusCode == 200 && response.error.isEmpty) {
          logger.d("Reject request success");
          emit(RejectRequestSuccess());
          add(LoadMyApproval());
        } else {
          emit(RejectRequestFailed(error: response.message));
        }
      }  catch (error) {
        emit(RejectRequestFailed(error: error.toString()));
      }
    });

    on<RevokeRequestEvent>((event, emit) async {
      var userId = await cacheService.getString(name: 'userId');
      Map data={
        "approval": {
          "id": event.id,
          "approvalBy": {
            "id": userId
          },
          "approvalStatus":"pending"
        }
      };
      logger.d(data);
      try{
        final response = await approvalrepo.postApprovalStatus(data:data);

        if (response.statusCode == 200 && response.error.isEmpty) {
          logger.d("Reject request success");
          emit(RevokeRequestSuccess());
          add(LoadMyApproval());
        } else {
          emit(RejectRequestFailed(error: response.message));
        }
      }  catch (error) {
        emit(RejectRequestFailed(error: error.toString()));
      }
    });
  }
}
