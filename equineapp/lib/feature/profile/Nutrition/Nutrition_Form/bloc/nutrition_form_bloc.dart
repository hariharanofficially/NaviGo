import 'dart:convert';
import 'dart:io';

import 'package:EquineApp/data/models/nutrition_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/FoodUom_model.dart';
import '../../../../../data/models/all_form_model.dart';
import '../../../../../data/models/foodType_model.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';

part 'nutrition_form_event.dart';
part 'nutrition_form_state.dart';

class NutritionFormBloc extends Bloc<NutritionFormEvent, NutritionFormState> {
  final ImagePicker _picker = ImagePicker(); // Define the ImagePicker instance
  // File? pickedImage;
  List<String> _fileNames = [];
  Logger logger = new Logger();
  NutritionFormBloc() : super(NutritionFormInitial()) {
    on<SubmitFormNutrition>((event, emit) async {
      try {
        String nutritiondatetime = event.nutritiondatetime + "T00:00:00";
        final response = event.id != null
            ? await nutritionrepo.updateNutrition(
                id: event.id!,
                nutritionDatetime: nutritiondatetime,
                horseId: event.horseId,
                foodType: event.foodType,
                feeduom: event.feeduom,
                servingValue: event.servingValue)
            : await nutritionrepo.addNutrition(
                nutritionDatetime: nutritiondatetime,
                horseId: event.horseId,
                foodType: event.foodType,
                feeduom: event.feeduom,
                servingValue: event.servingValue);
        if (response.statusCode == 200) {
          add(UploadImageNutrition(filePath: event.filePath));
          emit(NutritionFormSuccessfully(
            message: response.message,
          ));
        } else {
          emit(NutritionFormerror(error: response.message));
        }
      } catch (e) {
        emit(NutritionFormerror(error: e.toString()));
      }
    });
    on<LoadNutritionform>((event, emit) async {
      emit(NutritionFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        emit(NutritionFormLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(NutritionFormerror(error: e.toString()));
      }
    });
    on<LoadNutritionformByid>((event, emit) async {
      emit(NutritionFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        NutritionModel horse =
            await nutritionrepo.getAllNutritionById(id: event.id);
        //emit(HorseDetailsLoaded(horse: horse));
        allFormData.nutritionDetail = horse;
        emit(NutritionFormLoaded(allFormModel: allFormData));
        add(FetchDocs());
      } catch (e) {
        emit(NutritionFormerror(error: e.toString()));
      }
    });
    on<SubmitFoodType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateFoodType(
                name: event.name,
                descripition: event.descripition,
                id: event.id!)
            : await masterApiRepo.addFoodType(
                name: event.name, descripition: event.descripition);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<FoodType> types = await masterApiRepo.getAllFoodType();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(FoodTypeCreateSuccess(types: types));
        } else {
          emit(FoodTypeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(FoodTypeCreateFailed(error: e.toString()));
      }
    });
    on<DeletefoodType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteFoodType(id: event.foodTypeId);

        List<FoodType> types = await masterApiRepo.getAllFoodType();

        emit(FoodTypeDeleted(types: types));
      } catch (e) {
        emit(NutritionFormerror(error: e.toString()));
      }
    });
    on<SubmitFoodUomType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateFoodUomType(
                name: event.name,
                id: event.id!,
              )
            : await masterApiRepo.addFoodUomType(
                name: event.name,
              );
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<FoodUomType> types = await masterApiRepo.getAllFoodUom();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(FoodUomTypeCreateSuccess(types: types));
        } else {
          emit(FoodUomTypeCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(FoodUomTypeCreateFailed(error: e.toString()));
      }
    });
    on<Deletefooduom>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteFoodUom(id: event.FooduomId);

        List<FoodUomType> types = await masterApiRepo.getAllFoodUom();

        emit(FooduomDeleted(types: types));
      } catch (e) {
        emit(NutritionFormerror(error: e.toString()));
      }
    });

    // on<FilePickedEvent>((event, emit) async {
    //   final XFile? pickedFile = await _picker.pickImage(
    //     source: ImageSource.gallery,
    //   );
    //   // Open the file picker
    //   if (pickedFile != null) {
    //     pickedImage = File(pickedFile.path);

    //     emit(FileSelected(pickedImage: pickedImage!));
    //   } else {
    //     // Handle case where no image was picked
    //     emit(FilePickerError('No file selected'));
    //   }
    // });
    on<UploadImageNutrition>((event, emit) async {
      emit(FileUploadInProgress(
          fileNames: _fileNames, fileIndex: 0)); // Start with the first file
      try {
        logger.d("Starting file upload process...");

        // Retrieve the record ID from the cache service
        var recordId = await cacheService.getString(name: 'NutritionId');
        logger.d("Retrieved recordId: $recordId");
        if (event.filePath == null || event.filePath.isEmpty) {
          emit(ImageUploadFailed(error: "No files to upload."));
          return;
        }
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
            tableName: 'Nutrition',
            rootLabel: 'Nutrition',
            displayPane: 'NutritionDocs',
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
    on<FetchDocs>((event, emit) async {
      try {
        var recordId = await cacheService.getString(name: 'horseNutritionId');
        final response = await docsRepo.postfetchDocs(
            recordId: recordId,
            tableName: 'Nutrition',
            displayPane: 'NutritionDocs');

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
    // on<UploadImageNutrition>((event, emit) async {
    //   try {
    //     var horsesId = await cacheService.getString(name: 'horsesId');
    //     final response = await uploadsRepo.addStableWithFile(
    //       recordId: horsesId,
    //       // recordId: event.id.toString(),
    //       tableName: 'horseNutrition',
    //       images: pickedImage!, // Use the picked image here
    //     );
    //     emit(ImageUploadSuccessfully(message: response.message));
    //   } catch (e) {
    //     emit(ImageUploadFailed(error: 'No image selected'));
    //   }
    // });
  }
}
