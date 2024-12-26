// add_stable_bloc.dart
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';
import 'add_stable_event.dart';
import 'add_stable_state.dart';
import 'package:logger/logger.dart';

class AddStableBloc extends Bloc<AddStableEvent, AddStableState> {
  Logger logger = Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  File? pickedImage;
  AddStableBloc() : super(AddStableInitial()) {
    on<SubmitForm>((event, emit) async {
      emit(AddStableLoading());

      try {
        logger.d("Performing ${event.id != null ? 'update' : 'add'} stable");
        var tenantId = await cacheService.getString(name: 'tenantId');
        // Retrieve stable ID based on context
        String? stableId;
        // Call the appropriate API for add or update
        final response = event.id == null
            ? await stablerepo.addStable(
                tenantId: tenantId, stablename: event.name)
            : await stablerepo.updateStable(
                stableId: event.id!,
                tenantId: tenantId,
                stablename: event.name);

        if (response.statusCode == 200 && response.error.isEmpty) {
          // Store the newly created or updated stable ID in cache
          if (event.id == null) {
            stableId = await cacheService.getString(name: 'STABLEID');
          } else {
            stableId = await cacheService.getString(name: 'stableId');
          }

          // If an image is picked, attempt to upload it
          if (pickedImage != null) {
            try {
              emit(AddStableLoading()); // Emit loading state for image upload
              final uploadResponse = await uploadsRepo.addStableWithFile(
                recordId: stableId, // Use stable ID from response
                tableName: 'Stable',
                images: pickedImage!,            displayPane:'profileImgs',

              );

              if (uploadResponse.statusCode == 200 &&
                  uploadResponse.error.isEmpty) {
                emit(StableImageUploadedSuccessfully(
                    message: uploadResponse.message));
              } else {
                emit(StableImageUploadFailure(error: uploadResponse.message));
              }
            } catch (uploadError) {
              emit(StableImageUploadFailure(error: uploadError.toString()));
            }
          }

          // Final success emission
          emit(AddStableSuccess(message: response.message));
        } else {
          emit(AddStableFailure(error: response.message));
        }
      } catch (error) {
        emit(AddStableFailure(error: error.toString()));
      }
    });

    on<LoadstablebyId>((event, emit) async {
      try {
        final horses = await stablerepo.getAllStableById(id: event.id);
        emit(StableLoadedbyId(stable: horses));
      } catch (e) {
        emit(StableErrorbyId("Failed to load horses"));
      }
    });
    on<PickImage>((event, emit) async {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        pickedImage = File(pickedFile.path); // Store the picked image

        // Combine both image and dropdown data into a single state emission
        emit(stableImage(pickedImage: pickedImage!));
      }
    });
    // on<UploadImage>((event, emit) async {
    //   try {
    //     //edit
    //     var stableId = await cacheService.getString(name: 'stableId');
    //     //add
    //     var Stableid = await cacheService.getString(name: 'STABLEID');

    //     if (pickedImage != null) {
    //       final response = await uploadsRepo.addStableWithFile(
    //         recordId: stableId,
    //         tableName: 'Stable',
    //         images: pickedImage!, // Use the picked image here
    //       );

    //       // Fetch data again after successful image upload
    //       final allFormData = await dropdownRepo.getAllFormData();
    //       print('Fetched Dropdown Data: $allFormData'); // Add this line

    //       emit(StableImageUploadedSuccessfully(message: response.message));
    //     } else {
    //       // Handle case where no image was picked
    //       emit(StableImageUploadFailure(error: 'No image selected'));
    //     }
    //   } catch (e) {
    //     logger.e(e.toString());
    //     emit(StableImageUploadFailure(error: e.toString()));
    //   }
    // });
    // on<UploadImage>((event, emit) async {
    //   try {
    //     // Retrieve stable ID based on context
    //     String? stableId;

    //     if (event.isEdit) {
    //       // Edit: Retrieve existing stable ID from the cache
    //       stableId = await cacheService.getString(name: 'stableId');
    //     } else {
    //       // Add: Retrieve the newly created stable ID from the cache
    //       stableId = await cacheService.getString(name: 'STABLEID');
    //     }

    //     if (stableId == null || stableId.isEmpty) {
    //       emit(StableImageUploadFailure(error: 'Stable ID not found'));
    //       return;
    //     }

    //     if (pickedImage != null) {
    //       // Call the upload API
    //       final response = await uploadsRepo.addStableWithFile(
    //         recordId: stableId,
    //         tableName: 'Stable',
    //         images: pickedImage!,
    //       );

    //       // Optionally fetch dropdown or stable data again
    //       final allFormData = await dropdownRepo.getAllFormData();
    //       logger.d('Fetched Dropdown Data: $allFormData');

    //       // Emit success state with message
    //       emit(StableImageUploadedSuccessfully(message: response.message));
    //     } else {
    //       // Handle no image selected
    //       emit(StableImageUploadFailure(error: 'No image selected for upload'));
    //     }
    //   } catch (e) {
    //     logger.e(e.toString());
    //     emit(StableImageUploadFailure(error: e.toString()));
    //   }
    // });
  }
}
