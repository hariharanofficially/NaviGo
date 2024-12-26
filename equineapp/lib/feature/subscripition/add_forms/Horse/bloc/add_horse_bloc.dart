import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:logger/logger.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/service/service.dart';
import '../horse_data_table.dart';
import 'add_horse_event.dart';
import 'add_horse_state.dart';

class AddHorseBloc extends Bloc<AddHorseEvent, AddHorseState> {
  Logger logger = Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  File? pickedImage; // Store the picked image

  AddHorseBloc({
    this.pickedImage,
  }) : super(AddHorseInitial()) {
    on<SubmitForm>(_onSubmitForm);
    on<SelectDate>(_onSelectDate);
    on<LoadFetch>(_onFetchAll);
    on<LoadHorseDetails>(_onFetchHorseDetails);
    on<PickImage>(_onPickImage); // Add event handler for picking images
    // on<UploadStableImage>(_onUploadStableImage);
  }

  void _onSubmitForm(SubmitForm event, Emitter<AddHorseState> emit) async {
    emit(FormSubmitting());
    try {
      logger.d("performing ${event.id != null ? 'update' : 'add'} horse");
      String? horsesId;

      final response = event.id != null
          ? await horseRepo.updatehorse(
              id: event.id!,
              name: event.name,
              currentName: event.currentname,
              originalName: event.originalname,
              dateOfBirth: event.dateOfBirth,
              microchipNo: event.microchipNo,
              remarks: event.remarks,
              breedId: event.breedId,
              divisionId: event.divisionId,
              active: event.active,
              stableId: event.stableId,
            )
          : await horseRepo.addHorses(
              name: event.name,
              currentName: event.currentname,
              originalName: event.originalname,
              dateOfBirth: event.dateOfBirth,
              microchipNo: event.microchipNo,
              remarks: event.remarks,
              breedId: event.breedId,
              divisionId: event.divisionId,
              active: event.active,
              stableId: event.stableId,
            );

      if (response.statusCode == 200 && response.error.isEmpty) {
        if (event.id == null) {
          horsesId = await cacheService.getString(name: 'horseId');
        } else {
          horsesId = await cacheService.getString(name: 'horsesId');
        }
        try {
          emit(FormSubmitting());
          if (pickedImage != null) {
            final response = await uploadsRepo.addStableWithFile(
              recordId: horsesId,
              tableName: 'Horse',
              images: pickedImage!, // Use the picked image here
                          displayPane:'profileImgs',

            );
            final allFormData = await dropdownRepo.getAllFormData();
            logger.d('Fetched Dropdown Data: $allFormData');

            emit(HorseImageUploadedSuccessfully(message: response.message));
          } else {
            // Handle case where no image was picked
            emit(HorseImageUploadFailure(error: 'No image selected'));
          }
        } catch (e) {
          emit(HorseImageUploadFailure(error: e.toString()));
        }
        emit(FormSubmittedSuccessfully(message: response.message));
      } else {
        emit(FormSubmittedFailure(error: response.message));
      }
    } catch (e) {
      emit(FormSubmittedFailure(error: e.toString()));
    }
  }

  void _onSelectDate(SelectDate event, Emitter<AddHorseState> emit) async {
    final DateTime? picked = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      emit(DateSelected(DateFormat('dd-MM-yyyy').format(picked)));
    }
  }

  void _onFetchAll(LoadFetch event, Emitter<AddHorseState> emit) async {
    emit(HorseLoading());
    try {
      final allFormData = await dropdownRepo.getAllFormData();
      print('Fetched Dropdown Data: $allFormData'); // Add this line
      // Emit states for each form data type
      emit(HorseLoaded(allFormModel: allFormData));
    } catch (e) {
      emit(Horseerror(message: e.toString()));
    }
  }

  void _onFetchHorseDetails(
      LoadHorseDetails event, Emitter<AddHorseState> emit) async {
    emit(HorseLoading());
    try {
      final allFormData = await dropdownRepo.getAllFormData();
      print('Fetched Dropdown Data: $allFormData'); // Add this line

      HorseModel horse = await horseRepo.getHorseById(id: event.horseId);
      //emit(HorseDetailsLoaded(horse: horse));
      allFormData.horseDetail = horse;

      emit(HorseLoaded(allFormModel: allFormData));
    } catch (e) {
      emit(Horseerror(message: e.toString()));
    }
  }

  void _onPickImage(PickImage event, Emitter<AddHorseState> emit) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path); // Store the picked image

      // Combine both image and dropdown data into a single state emission
      emit(horseImage(pickedImage: pickedImage!));
    }
  }

  // void _onUploadStableImage(
  //     UploadStableImage event, Emitter<AddHorseState> emit) async {
  //   try {
  //     String? horsesId;
  //     if (event.isEdit) {
  //       horsesId = await cacheService.getString(name: 'horsesId');
  //     } else {
  //       horsesId = await cacheService.getString(name: 'horseId');
  //     }
  //     if (horsesId == null || horsesId.isEmpty) {
  //       emit(HorseImageUploadFailure(error: 'Stable ID not found'));
  //       return;
  //     }
  //     if (pickedImage != null) {
  //       final response = await uploadsRepo.addStableWithFile(
  //         recordId: horsesId,
  //         tableName: 'Horse',
  //         images: pickedImage!, // Use the picked image here
  //       );
  //       final allFormData = await dropdownRepo.getAllFormData();
  //       logger.d('Fetched Dropdown Data: $allFormData');

  //       emit(HorseImageUploadedSuccessfully(message: response.message));
  //     } else {
  //       // Handle case where no image was picked
  //       emit(HorseImageUploadFailure(error: 'No image selected'));
  //     }
  //   } catch (e) {
  //     logger.e(e.toString());
  //     emit(HorseImageUploadFailure(error: e.toString()));
  //   }
  // }
  // void _onUploadStableImage(
  //     UploadStableImage event, Emitter<AddHorseState> emit) async {
  //   try {
  //     var horsesId = await cacheService.getString(name: 'horsesId');

  //     if (pickedImage != null) {
  //       final response = await uploadsRepo.addStableWithFile(
  //         recordId: horsesId,
  //         tableName: 'Horse',
  //         images: pickedImage!, // Use the picked image here
  //       );

  //       // Fetch data again after successful image upload
  //       final allFormData = await dropdownRepo.getAllFormData();
  //       print('Fetched Dropdown Data: $allFormData'); // Add this line

  //       emit(HorseImageUploadedSuccessfully(message: response.message));
  //     } else {
  //       // Handle case where no image was picked
  //       emit(HorseImageUploadFailure(error: 'No image selected'));
  //     }
  //   } catch (e) {
  //     logger.e(e.toString());
  //     emit(HorseImageUploadFailure(error: e.toString()));
  //   }
  // }
}
