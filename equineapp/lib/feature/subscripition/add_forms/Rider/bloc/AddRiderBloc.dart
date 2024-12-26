import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Rider/bloc/AddRiderEvent.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Rider/bloc/AddRiderState.dart';
import 'package:bloc/bloc.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/rider_model.dart';
import '../../../../../data/service/service.dart';

class AddRiderBloc extends Bloc<AddRiderEvent, AddRiderState> {
  Logger logger = new Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  File? _pickedImage; // Store the picked image

  AddRiderBloc() : super(AddRiderInitial()) {
    on<SubmitRiderForm>((event, emit) async {
      emit(AddRiderLoading());
      try {
        String? riderId;

        logger.d("performing ${event.id != null ? 'update' : 'add'} horse");
        final response = event.id != null
            ? await riderrepo.updateRider(
                id: event.id!,
                name: event.name,
                fatherName: event.fathersName,
                dateOfBirth: event.dateOfBirth,
                bloodGroup: event.bloodGroup,
                remarks: event.remarks,
                riderWeight: event.riderWeight,
                mobile: event.mobile,
                email: event.email,
                divisionname: event.division,
                stablename: event.stablename,
                active: event.active,
                nationality: event.nationality,
              )
            : await riderrepo.addRider(
                name: event.name,
                fatherName: event.fathersName,
                dateOfBirth: event.dateOfBirth,
                bloodGroup: event.bloodGroup,
                remarks: event.remarks,
                riderWeight: event.riderWeight,
                mobile: event.mobile,
                email: event.email,
                divisionname: event.division,
                stablename: event.stablename,
                active: event.active,
                nationality: event.nationality,
              );

        if (response.statusCode == 200 && response.error.isEmpty) {
          if (event.id == null) {
            riderId = await cacheService.getString(name: 'RIDERID');
          } else {
            riderId = await cacheService.getString(name: 'riderId');
          }
          try {
            emit(AddRiderLoading());

            if (_pickedImage != null) {
              final response = await uploadsRepo.addStableWithFile(
                recordId: riderId,
                tableName: 'Rider',            displayPane:'profileImgs',

                images: _pickedImage!, // Use the picked image here
              );

              // Fetch data again after successful image upload
              final allFormData = await dropdownRepo.getAllFormData();
              print('Fetched Dropdown Data: $allFormData'); // Add this line

              emit(RiderImageUploadedSuccessfully(message: response.message));
            } else {
              // Handle case where no image was picked
              emit(RiderImageUploadFailure(error: 'No image selected'));
            }
          } catch (e) {
            emit(RiderImageUploadFailure(error: e.toString()));
          }
          emit(AddRiderSuccess(message: response.message));
        } else {
          emit(AddRiderFailure(error: response.message));
        }
      } catch (e) {
        emit(AddRiderFailure(error: e.toString()));
      }
    });

    on<Loadfetchrider>((event, emit) async {
      emit(RiderLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        emit(RiderLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Ridererror(message: e.toString()));
      }
    });
    on<LoadriderDetails>((event, emit) async {
      emit(RiderLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line

        RiderModel rider = await riderrepo.getAllRiderById(id: event.riderId);
        //emit(HorseDetailsLoaded(horse: horse));
        allFormData.riderDetail = rider;
        emit(RiderLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Ridererror(message: e.toString()));
      }
    });

    on<PickImage>((event, emit) async {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _pickedImage = File(pickedFile.path); // Store the picked image

        // Fetch dropdown data after picking the image
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Debugging log
        // Combine both image and dropdown data into a single state emission
        emit(riderImage(pickedImage: _pickedImage!));
      }
    });
    // on<UploadRiderImage>((event, emit) async {
    //   emit(RiderLoading());
    //   try {
    //     // Retrieve stable ID based on context
    //     String? riderId;

    //     if (event.isEdit) {
    //       // Edit: Retrieve existing stable ID from the cache
    //       riderId = await cacheService.getString(name: 'riderId');
    //     } else {
    //       // Add: Retrieve the newly created stable ID from the cache
    //       riderId = await cacheService.getString(name: 'RIDERID');
    //     }

    //     if (riderId == null || riderId.isEmpty) {
    //       emit(RiderImageUploadFailure(error: 'RIDER ID not found'));
    //       return;
    //     }

    //     if (_pickedImage != null) {
    //       final response = await uploadsRepo.addStableWithFile(
    //         recordId: riderId,
    //         tableName: 'Rider',
    //         images: _pickedImage!, // Use the picked image here
    //       );

    //       // Fetch data again after successful image upload
    //       final allFormData = await dropdownRepo.getAllFormData();
    //       print('Fetched Dropdown Data: $allFormData'); // Add this line

    //       emit(RiderImageUploadedSuccessfully(message: response.message));
    //     } else {
    //       // Handle case where no image was picked
    //       emit(RiderImageUploadFailure(error: 'No image selected'));
    //     }
    //   } catch (e) {
    //     logger.e(e.toString());
    //     emit(RiderImageUploadFailure(error: e.toString()));
    //   }
    // });
  }
}
