// add_event_bloc.dart
import 'dart:io';

import 'package:EquineApp/feature/subscripition/add_forms/Rider/bloc/AddRiderState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../../data/models/event_model.dart';
import '../../../../../data/service/service.dart';
import 'AddEvent_Event.dart';
import 'AddEvent_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  Logger logger = new Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  File? _pickedImage; // Store the picked image

  AddEventBloc() : super(AddEventInitial()) {
    on<SubmitForm>((event, emit) async {
      try {
        logger.d("category choosen : " + event.fromScreen);
        logger.d("performing ${event.id != null ? 'update' : 'add'} horse");

        final response = event.id != null
            ? await eventrepo.updateEvent(
                startDate: event.startDate,
                endDate: event.endDate,
                shortName: event.shortName,
                title: event.title,
                groupName: event.groupName,
                locationName: event.locationName,
                city: event.city,
                rideStartTime: event.rideStartTime,
                rideDate: event.rideDate,
                source: event.source,
                vendorName: event.vendorName,
                stableId: event.stableId,
                eventGroupId: event.eventGroupId,
                eventTypeId: event.eventTypeId,
                divisionId: event.divisionId,
                category: event.fromScreen,
                id: event.id!,
                eventCountryId: event.eventCountryId,
                phase: '')
            : await eventrepo.addEvent(
                startDate: event.startDate,
                endDate: event.endDate,
                shortName: event.shortName,
                title: event.title,
                groupName: event.groupName,
                locationName: event.locationName,
                city: event.city,
                rideStartTime: event.rideStartTime,
                rideDate: event.rideDate,
                source: event.source,
                vendorName: event.vendorName,
                stableId: event.stableId,
                eventGroupId: event.eventGroupId,
                eventTypeId: event.eventTypeId,
                divisionId: event.divisionId,
                category: event.fromScreen,
                eventCountryId: event.eventCountryId, phase: '');

        if (response.statusCode == 200 && response.error.isEmpty) {
          if (event.fromScreen == "race") {
            emit(AddRaceEventSuccess(message: response.message));
          } else if (event.fromScreen == "training") {
            emit(AddTrainingEventSuccess(message: response.message));
          } else if (event.fromScreen == "mock") {
            emit(AddMockEventSuccess(message: response.message));
          }
        } else {
          emit(AddEventFailure(error: response.message));
        }
        // await Future.delayed(Duration(seconds: 2));
        // emit(AddEventSuccess());
      } catch (e) {
        emit(AddEventFailure(error: e.toString()));
      }
    });

    on<Loadfetchevent>((event, emit) async {
      emit(eventLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        // Emit states for each form data type
        emit(eventLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(eventerror(message: e.toString()));
      }
    });

    on<LoadeventDetails>((event, emit) async {
      emit(eventLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        EventModel events = await eventrepo.getAlleventsById(id: event.eventId);
        allFormData.eventDetail = events;
        // Emit states for each form data type
        emit(eventLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(eventerror(message: e.toString()));
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

        // Emit states for each form data type
        emit(eventsImage(pickedImage: _pickedImage!));
      }
    });
    on<UploadEventImage>((event, emit) async {
      emit(eventLoading());
      try {
        var eventId = await cacheService.getString(name: 'eventId');

        if (_pickedImage != null) {
          final response = await uploadsRepo.addStableWithFile(
            recordId: eventId,
            tableName: 'Event',
            images: _pickedImage!, // Use the picked image here
            displayPane: 'profileImgs',
          );
          final allFormData = await dropdownRepo.getAllFormData();
          print('Fetched Dropdown Data: $allFormData'); // Add this line

          emit(EventImageUploadedSuccessfully(message: response.message));
        } else {
          // Handle case where no image was picked
          emit(EventImageUploadFailure(error: 'No image selected'));
        }
      } catch (e) {
        emit(EventImageUploadFailure(error: e.toString()));
      }
    });
  }
}
