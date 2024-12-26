import 'dart:io';

import 'package:EquineApp/data/models/ownername.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';

part 'owner_event.dart';

part 'owner_state.dart';

class Addownerbloc extends Bloc<AddOwnerEvent, AddOwnerState> {
  Logger logger = Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  File? pickedImage;
  Addownerbloc() : super(AddOwnerInitial()) {
    on<SubmitForm>((event, emit) async {
      emit(AddOwnerLoading());
      try {
        String? OwnerId;

        final response = event.id == null
            ? await ownerrepo.addowner(ownername: event.name)
            : await ownerrepo.updateowner(ownername: event.name, id: event.id!);
        if (response.statusCode == 200 && response.error.isEmpty) {
          // Store the newly created or updated stable ID in cache
          if (event.id == null) {
            OwnerId = await cacheService.getString(name: 'OWNERID');
          } else {
            OwnerId = await cacheService.getString(name: 'ownerId');
          }

          // If an image is picked, attempt to upload it
          if (pickedImage != null) {
            try {
              emit(AddOwnerLoading()); // Emit loading state for image upload
              final uploadResponse = await uploadsRepo.addStableWithFile(
                recordId: OwnerId, // Use stable ID from response
                tableName: 'Owner',
                images: pickedImage!, displayPane: 'profileImgs',
              );

              if (uploadResponse.statusCode == 200 &&
                  uploadResponse.error.isEmpty) {
                emit(OwnerImageUploadedSuccessfully(
                    message: uploadResponse.message));
              } else {
                emit(OwnerImageUploadFailure(error: uploadResponse.message));
              }
            } catch (uploadError) {
              emit(OwnerImageUploadFailure(error: uploadError.toString()));
            }
          }
          emit(AddOwnerSuccess(message: response.message));
        } else {
          emit(AddOwnerFailure(error: response.message));
        }
      } catch (error) {
        emit(AddOwnerFailure(error: error.toString()));
      }
    });
    on<LoadOwnerbyId>((event, emit) async {
      try {
        final owner = await ownerrepo.getAllOwnerById(id: event.id);
        emit(OwnerLoadedbyId(owner: owner));
      } catch (e) {
        emit(OwnerErrorbyId("Failed to load horses"));
      }
    });
    on<PickImage>((event, emit) async {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        pickedImage = File(pickedFile.path); // Store the picked image

        // Combine both image and dropdown data into a single state emission
        emit(ownerImage(pickedImage: pickedImage!));
      }
    });
  }
}
