import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:bloc/bloc.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/trainermodel.dart';
import '../../../../../data/service/service.dart';
import 'AddTrainerEvent.dart';
import 'AddTrainerState.dart';

class AddTrainerBloc extends Bloc<AddTrainerEvent, AddTrainerState> {
  Logger logger = new Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  File? _pickedImage; // Store the picked image

  AddTrainerBloc() : super(AddTrainerInitial()) {
    on<SubmitTrainerForm>((event, emit) async {
      emit(AddTrainerLoading());
      try {
        String? trainerId;
        logger.d("performing ${event.id != null ? 'update' : 'add'} horse");
        final response = event.id != null
            ? await trainerrepo.updateTrainer(
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
                addressline1: event.address,
              )
            : await trainerrepo.addTrainer(
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
                addressline1: event.address,
              );
        if (response.statusCode == 200 && response.error.isEmpty) {
          if (event.id == null) {
            trainerId = await cacheService.getString(name: 'TRAINERID');
          } else {
            trainerId = await cacheService.getString(name: 'trainerId');
          }
          try {
            emit(AddTrainerLoading());
            if (_pickedImage != null) {
              final response = await uploadsRepo.addStableWithFile(
                recordId: trainerId,
                tableName: 'Trainer', displayPane: 'profileImgs',

                images: _pickedImage!, // Use the picked image here
              );

              // Fetch data again after successful image upload
              final allFormData = await dropdownRepo.getAllFormData();
              print('Fetched Dropdown Data: $allFormData'); // Add this line

              emit(TrainerImageUploadedSuccessfully(message: response.message));
            } else {
              // Handle case where no image was picked
              emit(TrainerImageUploadFailure(error: 'No image selected'));
            }
          } catch (e) {
            emit(TrainerImageUploadFailure(error: e.toString()));
          }
          emit(AddTrainerSuccess(message: response.message));
        } else {
          emit(AddTrainerFailure(error: response.message));
        }
      } catch (e) {
        emit(AddTrainerFailure(error: e.toString()));
      }
    });

    on<LoadfetchTrainer>((event, emit) async {
      emit(TrainerLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        emit(TrainerLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Trainererror(message: e.toString()));
      }
    });
    on<LoadTrainerDetails>((event, emit) async {
      emit(TrainerLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line

        TrainerModel trainer =
            await trainerrepo.getAllTrainerById(id: event.riderId);
        //emit(HorseDetailsLoaded(horse: horse));
        allFormData.trainerDetail = trainer;
        emit(TrainerLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Trainererror(message: e.toString()));
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
        emit(TrainerImage(pickedImage: _pickedImage!));
      }
    });
    // on<UploadTrainerImage>((event, emit) async {
    //   emit(TrainerLoading());
    //   try {
    //     String? trainerId;

    //     if (event.isEdit) {
    //       // Edit: Retrieve existing stable ID from the cache
    //       trainerId = await cacheService.getString(name: 'trainerId');
    //     } else {
    //       // Add: Retrieve the newly created stable ID from the cache
    //       trainerId = await cacheService.getString(name: 'TRAINERID');
    //     }

    //     if (trainerId == null || trainerId.isEmpty) {
    //       emit(TrainerImageUploadFailure(error: 'Stable ID not found'));
    //       return;
    //     }
    //     if (_pickedImage != null) {
    //       final response = await uploadsRepo.addStableWithFile(
    //         recordId: trainerId,
    //         tableName: 'Trainer',
    //         images: _pickedImage!, // Use the picked image here
    //       );

    //       // Fetch data again after successful image upload
    //       final allFormData = await dropdownRepo.getAllFormData();
    //       print('Fetched Dropdown Data: $allFormData'); // Add this line

    //       emit(TrainerImageUploadedSuccessfully(message: response.message));
    //     } else {
    //       // Handle case where no image was picked
    //       emit(TrainerImageUploadFailure(error: 'No image selected'));
    //     }
    //   } catch (e) {
    //     logger.e(e.toString());
    //     emit(TrainerImageUploadFailure(error: e.toString()));
    //   }
    // });
  }
}
