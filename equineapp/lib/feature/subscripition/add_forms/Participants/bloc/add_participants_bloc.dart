import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../data/models/participant.dart';
import '../../../../../data/service/service.dart';
import 'add_participants_event.dart';
import 'add_participants_state.dart';
import 'package:logger/logger.dart';

class AddParticipantsBloc
    extends Bloc<AddParticipantsEvent, AddParticipantsState> {
  Logger logger = new Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  File? _pickedImage; // Store the picked image

  AddParticipantsBloc() : super(AddParticipantsInitial()) {
    on<SubmitParticipantsForm>((event, emit) async {
      emit(AddParticipantsLoading());

      try {
        logger.d("performing ${event.id != null ? 'update' : 'add'} horse");
        final response = event.id != null
            ? await participantrepo.updateParticipant(
                id: event.id!,
                ownername: event.ownername,
                startNumber: event.startNumber,
                stablename: event.stablename,
                eventId: event.eventId,
                riderId: event.riderId,
                horseId: event.horseId,
                deviceId: event.deviceId)
            : await participantrepo.addParticipant(
                ownername: event.ownername,
                startNumber: event.startNumber,
                stablename: event.stablename,
                eventId: event.eventId,
                riderId: event.riderId,
                horseId: event.horseId,
                deviceId: event.deviceId);

        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(AddParticipantsSuccess(message: response.message));
        } else {
          emit(AddParticipantsFailure(error: response.message));
        }
        // Simulate network delay
        //await Future.delayed(Duration(seconds: 2));

        // Perform your form submission logic here
        // Replace with actual API call or data processing

        //emit(AddParticipantsSuccess(message: ''));
      } catch (e) {
        emit(AddParticipantsFailure(error: e.toString()));
      }
    });
    on<Loadfetchparticipant>((event, emit) async {
      emit(ParticipantsLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        emit(ParticipantsLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Participantserror(message: e.toString()));
      }
    });
    on<LoadparticipantDetails>((event, emit) async {
      emit(ParticipantsLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();

        Participant participants = await participantrepo.getAllParticipantById(
            id: event.participantId);
        allFormData.participantDetails = participants;
        emit(ParticipantsLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(Participantserror(message: e.toString()));
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
        emit(participantImage(pickedImage: _pickedImage!));
      }
    });
    on<UploadPartImage>((event, emit) async {
      emit(ParticipantsLoading());
      try {
        var participantId = await cacheService.getString(name: 'participantId');
        if (_pickedImage != null) {
          final response = await uploadsRepo.addStableWithFile(
            recordId: participantId,
            tableName: 'Participant',            displayPane:'profileImgs',

            images: _pickedImage!, // Use the picked image here
          );

          // Fetch data again after successful image upload
          final allFormData = await dropdownRepo.getAllFormData();
          print('Fetched Dropdown Data: $allFormData'); // Add this line

          emit(
              ParticipantsImageUploadedSuccessfully(message: response.message));
        } else {
          // Handle case where no image was picked
          emit(ParticipantsImageUploadFailure(error: 'No image selected'));
        }
      } catch (e) {
        logger.e(e.toString());
        emit(ParticipantsImageUploadFailure(error: e.toString()));
      }
    });
  }
}
