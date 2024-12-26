import 'dart:convert';
import 'dart:io';
import 'package:EquineApp/data/models/farrier_model.dart';
import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/all_form_model.dart';
import '../../../../../data/models/shoeSpecification.dart';
import '../../../../../data/models/shoeType_model.dart';
import '../../../../../data/models/shoecomplement.dart';
import '../../../../../data/models/surfaceType.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../data/service/service.dart';

part 'farrier_form_event.dart';
part 'farrier_form_state.dart';

class FarrierFormBloc extends Bloc<FarrierFormEvent, FarrierFormState> {
  Logger logger = new Logger();
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  final ImagePicker _picker1 = ImagePicker(); // Define the ImagePicker instance
  final ImagePicker _picker2 = ImagePicker(); // Define the ImagePicker instance
  File? pickedImage;
  File? pickedImage1;
  File? pickedImage2;
  List<String> _fileNames = [];

  FarrierFormBloc() : super(FarrierFormInitial()) {
    on<SubmitFormFarrier>((event, emit) async {
      try {
        String shoedatetime = event.shoeDatetime + "T00:00:00";
        logger.d(shoedatetime);
        final response = event.id != null
            ? await farrierrepo.updatefarrier(
                id: event.id!,
                horseId: event.horseId,
                shoeDatetime: event.shoeDatetime,
                foreShoeType: event.foreShoeType,
                foreShoeSpecification: event.foreShoeSpecification,
                foreShoeComplement: event.foreShoeComplement,
                hindShoeType: event.hindShoeType,
                hindShoeSpecification: event.hindShoeSpecification,
                hindShoeComplement: event.hindShoeComplement,
                surfaceType: event.surfaceType)
            : await farrierrepo.addfarrier(
                horseId: event.horseId,
                shoeDatetime: event.shoeDatetime,
                foreShoeType: event.foreShoeType,
                foreShoeSpecification: event.foreShoeSpecification,
                foreShoeComplement: event.foreShoeComplement,
                hindShoeType: event.hindShoeType,
                hindShoeSpecification: event.hindShoeSpecification,
                hindShoeComplement: event.hindShoeComplement,
                surfaceType: event.surfaceType);
        if (response.statusCode == 200 && response.error.isEmpty) {
          // Trigger image upload events

          add(UploadImageFarrier(filePath: event.filePath));

          if (pickedImage1 != null) {
            add(BeforeUploadImageFarrier());
          }

          if (pickedImage2 != null) {
            add(AfterUploadImageFarrier());
          }
          emit(FarrierFormSuccessfully(message: response.message));
        } else {
          emit(FarrierFormerror(error: response.message));
        }
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<LoadFarrierform>((event, emit) async {
      emit(FarrierFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        emit(FarrierFormLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<LoadFarrierformByid>((event, emit) async {
      emit(FarrierFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        FarrierModel farrier =
            await farrierrepo.getAllFarrierById(id: event.id);
        //emit(HorseDetailsLoaded(horse: horse));
        allFormData.farrierDetail = farrier;
        emit(FarrierFormLoaded(allFormModel: allFormData));
        add(FetchDocs());
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<SubmitforeShoeType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateshoeType(
                name: event.name, id: event.id!)
            : await masterApiRepo.addshoeType(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<shoeType> types = await masterApiRepo.getAllshoeType();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(foreShoeTypeCreateSuccess(types: types));
        } else {
          emit(foreshoeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(foreshoeCreateFailed(error: e.toString()));
      }
    });
    on<DeleteforeShoeType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteshoeType(id: event.foreShoeTypeId);

        List<shoeType> types = await masterApiRepo.getAllshoeType();
        emit(foreShoeTypeDeleted(types: types));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<SubmitforeShoeSpecification>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateshoeSpecification(
                name: event.name, id: event.id!)
            : await masterApiRepo.addshoeSpecification(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<shoeSpecification> types =
            await masterApiRepo.getAllshoeSpecification();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(foreshoeSpecfCreateSuccess(types: types));
        } else {
          emit(foreshoeSpecfCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(foreshoeSpecfCreateFailed(error: e.toString()));
      }
    });
    on<DeleteforeShoeSpecification>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteshoeSpecification(
            id: event.foreShoeSpecificationId);

        List<shoeSpecification> types =
            await masterApiRepo.getAllshoeSpecification();
        emit(foreShoeSpecificationDeleted(types: types));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<SubmitforeShoeComplement>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateshoeComplement(
                name: event.name, id: event.id!)
            : await masterApiRepo.addshoeComplement(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<shoeComplement> types = await masterApiRepo.getAllshoeComplement();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(foreshoecompCreateSuccess(types: types));
        } else {
          emit(foreshoecompCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(foreshoecompCreateFailed(error: e.toString()));
      }
    });
    on<DeleteforeShoeComplement>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteshoeComplement(
            id: event.foreShoeComplementId);

        List<shoeComplement> types = await masterApiRepo.getAllshoeComplement();

        emit(foreShoeComplementDeleted(types: types));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<SubmithindShoeType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateshoeType(
                name: event.name, id: event.id!)
            : await masterApiRepo.addshoeType(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<shoeType> types = await masterApiRepo.getAllshoeType();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(hindShoeTypeCreateSuccess(types: types));
        } else {
          emit(hindshoeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(hindshoeCreateFailed(error: e.toString()));
      }
    });
    on<DeletehindShoeType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteshoeType(id: event.hindShoeTypeId);

        List<shoeType> types = await masterApiRepo.getAllshoeType();

        emit(hindShoeTypeDeleted(types: types));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<SubmithindShoeSpecification>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateshoeSpecification(
                name: event.name, id: event.id!)
            : await masterApiRepo.addshoeSpecification(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<shoeSpecification> types =
            await masterApiRepo.getAllshoeSpecification();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(hindshoeSpecfCreateSuccess(types: types));
        } else {
          emit(hindshoeSpecfCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(hindshoeSpecfCreateFailed(error: e.toString()));
      }
    });
    on<DeletehindShoeSpecification>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteshoeSpecification(
            id: event.hindShoeSpecificationId);

        List<shoeSpecification> types =
            await masterApiRepo.getAllshoeSpecification();
        emit(hindShoeSpecificationDeleted(types: types));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<SubmithindShoeComplement>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateshoeComplement(
                name: event.name, id: event.id!)
            : await masterApiRepo.addshoeComplement(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<shoeComplement> types = await masterApiRepo.getAllshoeComplement();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(hindshoecompCreateSuccess(types: types));
        } else {
          emit(hindshoecompCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(hindshoecompCreateFailed(error: e.toString()));
      }
    });
    on<DeletehindShoeComplement>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteshoeComplement(
            id: event.hindShoeComplementId);

        List<shoeComplement> types = await masterApiRepo.getAllshoeComplement();

        emit(hindShoeComplementDeleted(types: types));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    on<SubmitsurfaceType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateSurfaceType(
                name: event.name, id: event.id!)
            : await masterApiRepo.addSurfaceType(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<SurfaceType> types = await masterApiRepo.getAllSurfaceTypes();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(SurfaceTypeCreateSuccess(types: types));
        } else {
          emit(SurfaceTypeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(SurfaceTypeCreateFailed(error: e.toString()));
      }
    });
    on<DeleteSurfaceType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteSurfaceTypes(id: event.surfacetypeId);

        List<SurfaceType> types = await masterApiRepo.getAllSurfaceTypes();

        emit(SurfaceTypeDeleted(types: types));
      } catch (e) {
        emit(FarrierFormerror(error: e.toString()));
      }
    });
    // on<FilePickedFarrier>((event, emit) async {
    //   final XFile? pickedFile = await _picker.pickImage(
    //     source: ImageSource.gallery,
    //   );
    //   // Open the file picker
    //   if (pickedFile != null) {
    //     pickedImage = File(pickedFile.path);

    //     emit(FileSelectedFarrier(pickedImage: pickedImage!));
    //   } else {
    //     // Handle case where no image was picked
    //     emit(FilePickerError('No file selected'));
    //   }
    // });
    on<UploadImageFarrier>((event, emit) async {
      emit(FileUploadInProgress(
          fileNames: _fileNames, fileIndex: 0)); // Start with the first file
      try {
        logger.d("Starting file upload process...");

        // Retrieve the record ID from the cache service
        var recordId = await cacheService.getString(name: 'FarrierId');
        logger.d("Retrieved recordId: $recordId");
        // Ensure filePaths is not null
        if (event.filePath == null || event.filePath.isEmpty) {
          emit(ImageUploadFailed(error: "No files to upload."));
          return;
        } // Iterate through all file paths
        for (int i = 0; i < event.filePath.length; i++) {
          final filePath = event.filePath[i];
          if (filePath == null) {
            logger.e("Null file path encountered at index $i");
            continue; // Skip null paths
          }

          // Ensure the file exists before proceeding
          final file = File(filePath);
          if (!await file.exists()) {
            logger.e("File does not exist at path: ${event.filePath}");
            emit(ImageUploadFailed(error: "File not found at specified path."));
            return;
          }

          final fileName = file.path.split('/').last;
          logger.d("File name: $fileName");

          // Prepare FormData
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path, filename: fileName),
          });
          logger.d("FormData prepared: $formData");

          // Upload the file
          final response = await docsRepo.postuploaddocs(
            recordId: recordId,
            tableName: 'Farrier',
            rootLabel: 'Farrier',
            displayPane: 'FarrierDocs',
            documents: file,
          );

          // Check response status
          if (response.statusCode == 200 && response.error.isEmpty) {
            logger
                .d("File uploaded successfully. Message: ${response.message}");
            emit(ImageUploadSuccessfully(message: response.message));
          } else {
            logger.e("File upload failed. Error: ${response.message}");
            emit(ImageUploadFailed(error: response.message));
          }
        }
      } catch (e) {
        if (e is DioError) {
          logger.e("DioError occurred during file upload: ${e.response?.data}");
        } else {
          logger.e("Unexpected error during file upload: $e");
        }
        emit(ImageUploadFailed(error: e.toString()));
      }
    });
    // on<UploadImageFarrier>((event, emit) async {
    //   try {
    //     var horsesId = await cacheService.getString(name: 'horsesId');
    //     final response = await uploadsRepo.addStableWithFile(
    //       recordId: horsesId,
    //       tableName: 'Horse',
    //       images: pickedImage!, // Use the picked image here
    //     );
    //     emit(ImageUploadSuccessfully(message: response.message));
    //   } catch (e) {
    //     emit(ImageUploadFailed(error: 'No image selected'));
    //   }
    // });
    on<BeforeFilePickedFarrier>((event, emit) async {
      final XFile? pickedFile = await _picker1.pickImage(
        source: ImageSource.gallery,
      );
      // Open the file picker
      if (pickedFile != null) {
        pickedImage1 = File(pickedFile.path);

        emit(BeforeFileSelectedFarrier(pickedImage1: pickedImage1!));
      } else {
        // Handle case where no image was picked
        emit(BeforeFilePickerError('No file selected'));
      }
    });
    on<BeforeUploadImageFarrier>((event, emit) async {
      try {
        var FarrierId = await cacheService.getString(name: 'FarrierId');
        final response = await uploadsRepo.addStableWithFile(
          recordId: FarrierId,
          tableName: 'Farrier',
          displayPane: 'Before',
          images: pickedImage1!, // Use the picked image here
        );
        emit(ImageUploadSuccessfully(message: response.message));
      } catch (e) {
        emit(ImageUploadFailed(error: 'No image selected'));
      }
    });
    on<AfterFilePickedFarrier>((event, emit) async {
      final XFile? pickedFile = await _picker2.pickImage(
        source: ImageSource.gallery,
      );
      // Open the file picker
      if (pickedFile != null) {
        pickedImage2 = File(pickedFile.path);

        emit(AfterFileSelectedFarrier(pickedImage2: pickedImage2!));
      } else {
        // Handle case where no image was picked
        emit(AfterFilePickerError('No file selected'));
      }
    });
    on<AfterUploadImageFarrier>((event, emit) async {
      try {
        var FarrierId = await cacheService.getString(name: 'FarrierId');
        final response = await uploadsRepo.addStableWithFile(
          recordId: FarrierId,
          tableName: 'Farrier',
          displayPane: 'After',
          images: pickedImage2!, // Use the picked image here
        );
        emit(ImageUploadSuccessfully(message: response.message));
      } catch (e) {
        emit(ImageUploadFailed(error: 'No image selected'));
      }
    });
    on<FetchDocs>((event, emit) async {
      try {
        var recordId = await cacheService.getString(name: 'horseFarrierId');
        final response = await docsRepo.postfetchDocs(
            recordId: recordId,
            tableName: 'Farrier',
            displayPane: 'FarrierDocs');

        var responseData = jsonDecode(response.data.toString());
        logger.d(responseData.toString());

        // Initialize a list to store all document details
        List<Map<String, dynamic>> documentsList = [];

        // Loop through each main directory
        for (var mainDirectory in responseData['directories']) {
          // Loop through each nested directory in the main directory
          for (var nestedDirectory in mainDirectory['directories']) {
            // Extract documentId and documentName
            int documentId = nestedDirectory['documentId'];
            String documentName = nestedDirectory['documentName'];

            // Add the document details to the list
            documentsList.add({
              'documentId': documentId,
              'documentName': documentName,
            });

            logger.d('Document ID: $documentId');
            logger.d('Document Name: $documentName');
          }
        }

        // Emit the state with the list of documents
        emit(FetchDocumentSuccess(
          documentsList: documentsList,
        ));
      } catch (e) {
        emit(FetchDocumentFailed(error: e.toString()));
      }
    });
    on<GetDownloadDocs>((event, emit) async {
      try {
        // Emit loading state before the request
        emit(FileDownloadInProgress(documentId: event.documentId));

        // Make the API call to fetch the document
        await docsRepo.getdownloadDocs(event.documentId);

        emit(FileDownloadSuccess());
        await Future.delayed(Duration(seconds: 1));
        add(FetchDocs());
      } catch (e) {
        logger.e("Error during file download: $e");
        emit(FileDownloadError(error: e.toString()));
      }
    });
  }
}
