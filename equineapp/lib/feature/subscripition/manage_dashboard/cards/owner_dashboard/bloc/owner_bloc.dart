import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/models/ownername.dart';
import '../../../../../../data/repo/repo.dart';
import '../../../../../../data/service/service.dart';
part 'owner_state.dart';
part 'owner_event.dart';

class OwnerBloc extends Bloc<OwnerEvent, OwnerState> {
  OwnerBloc() : super(OwnerLoading()) {
    on<LoadOwner>((event, emit) async {
      try {
        await Future.delayed(Duration(seconds: 2));
        final Owners = await ownerrepo.getAllOwner();
        // final Stable = await stablerepo.getAllStable();
        emit(OwnerLoaded(Owner: Owners));
      } catch (e) {
        emit(OwnerError("Failed to load participants"));
      }
    });
    on<DeleteOwner>((event, emit) async {
      try {
        // Call the delete API
        await ownerrepo.deleteOwnerById(id: event.ownerId);

        // Reload the horses after deletion
        final Stable = await ownerrepo.getAllOwner();
        emit(OwnerLoaded(Owner: Stable));
      } catch (e) {
        emit(OwnerError("Failed to delete horse"));
      }
    });
  }
}
