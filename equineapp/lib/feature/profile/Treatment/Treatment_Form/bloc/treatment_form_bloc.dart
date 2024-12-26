import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/all_form_model.dart';
import '../../../../../data/models/treatment_model.dart';
import '../../../../../data/models/treatment_type.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';

part 'treatment_form_event.dart';
part 'treatment_form_state.dart';

class TreatmentFormBloc extends Bloc<TreatmentFormEvent, TreatmentFormState> {
  Logger logger =
      new Logger(); // Define _fileNames to store the list of file names
  List<String> _fileNames = [];
  TreatmentFormBloc() : super(TreatmentFormInitial()) {
    on<SubmitFormTreatment>((event, emit) async {
      try {
        String treatdatetime = event.treatmentDatetime + "T00:00:00";
        String nextchechkdatetime = event.nextCheckupDatetime + "T00:00:00";
        logger.d(treatdatetime);
        logger.d(nextchechkdatetime);
        final response = event.id != null
            ? await treatmentrepo.updatetreatment(
                id: event.id!,
                horseId: event.horseId,
                notes: event.notes,
                treatmentDatetime: treatdatetime,
                nextCheckupDatetime: nextchechkdatetime,
                treatmenttypeid: event.treatmenttypeid)
            : await treatmentrepo.addtreatment(
                horseId: event.horseId,
                notes: event.notes,
                treatmentDatetime: treatdatetime,
                nextCheckupDatetime: nextchechkdatetime,
                treatmenttypeid: event.treatmenttypeid);
        if (response.statusCode == 200 && response.error.isEmpty) {
          add(UploadTreatmentFile(filePath: event.filePath));
          emit(TreatmentFormSuccessfully(message: response.message));
        } else {
          emit(TreatmentFormerror(error: response.message));
        }
      } catch (e) {
        emit(TreatmentFormerror(error: e.toString()));
      }
    });
    on<LoadTreatmentform>((event, emit) async {
      emit(TreatmentFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        emit(TreatmentFormLoaded(allFormModel: allFormData));
      } catch (e) {
        emit(TreatmentFormerror(error: e.toString()));
      }
    });
    on<LoadTreatmentformByid>((event, emit) async {
      emit(TreatmentFormLoading());
      try {
        final allFormData = await dropdownRepo.getAllFormData();
        print('Fetched Dropdown Data: $allFormData'); // Add this line
        TreatmentModel treatment =
            await treatmentrepo.getAllTreamentById(id: event.id);
        //emit(HorseDetailsLoaded(horse: horse));
        allFormData.treatmentDetail = treatment;
        emit(TreatmentFormLoaded(allFormModel: allFormData));
        add(FetchDocs());
      } catch (e) {
        emit(TreatmentFormerror(error: e.toString()));
      }
    });
    on<SubmitTreatmentType>((event, emit) async {
      try {
        final response = event.id != null
            ? await masterApiRepo.updateTreatmentType(
                name: event.name, id: event.id!)
            : await masterApiRepo.addTreatmentType(name: event.name);
        //print('Fetched Dropdown Data: $allFormData'); // Add this line
        List<TreatmentType> types = await masterApiRepo.getAllTreatmentType();
        if (response.statusCode == 200 && response.error.isEmpty) {
          emit(TreatmentTypeCreateSuccess(types: types));
        } else {
          emit(TreatmentCreateFailed(error: response.message));
        }
      } catch (e) {
        emit(TreatmentCreateFailed(error: e.toString()));
      }
    });
    on<DeleteTreatmentType>((event, emit) async {
      try {
        // Call the delete API
        await masterApiRepo.deleteTreatmentType(id: event.treatmenttypeId);

        List<TreatmentType> types = await masterApiRepo.getAllTreatmentType();

        emit(TreatmentTypeDeleted(types: types));
      } catch (e) {
        emit(TreatmentFormerror(error: e.toString()));
      }
    });
    on<UploadTreatmentFile>((event, emit) async {
      emit(FileUploadInProgress(
          fileNames: _fileNames, fileIndex: 0)); // Start with the first file
      try {
        logger.d("Starting file upload process...");

        // Retrieve the record ID from the cache service
        var recordId = await cacheService.getString(name: 'TreatmentsId');
        logger.d("Retrieved recordId: $recordId");
        // Ensure filePaths is not null
        if (event.filePath == null || event.filePath.isEmpty) {
          emit(FileUploadError(error: "No files to upload."));
          return;
        } // Iterate through all file paths
        for (int i = 0; i < event.filePath.length; i++) {
          final filePath = event.filePath[i];
          if (filePath == null) {
            logger.e("Null file path encountered at index $i");
            continue; // Skip null paths
          }

          final file = File(filePath);
          if (!await file.exists()) {
            logger.e("File does not exist at path: ${event.filePath}");
            emit(FileUploadError(error: "File not found at specified path."));
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
            tableName: 'Treatment',
            rootLabel: 'Treatment',
            displayPane: 'TreatmentDocs',
            documents: file,
          );

          // Check response status
          if (response.statusCode == 200 && response.error.isEmpty) {
            logger
                .d("File uploaded successfully. Message: ${response.message}");
            emit(FileUploadSuccess(message: response.message));
          } else {
            logger.e("File upload failed. Error: ${response.message}");
            emit(FileUploadError(error: response.message));
          }
        }
      } catch (e) {
        if (e is DioError) {
          logger.e("DioError occurred during file upload: ${e.response?.data}");
        } else {
          logger.e("Unexpected error during file upload: $e");
        }
        emit(FileUploadError(error: e.toString()));
      }
    });

//     on<FetchDocs>((event, emit) async {
//       try {
//         var recordId = await cacheService.getString(name: 'horseTreatmentId');
//         final response = await docsRepo.postfetchDocs(
//             recordId: recordId,
//             tableName: 'Treatment',
//             displayPane: 'TreatmentDocs');

//         var responseData = jsonDecode(response.data.toString());
//         logger.d(responseData.toString());

// // Access the first directory in the directories list
//         var mainDirectory = responseData['directories'][0];

// // Access the nested directories list
//         var nestedDirectory = mainDirectory['directories'][0];

// // Extract documentId and documentName
//         int documentId = nestedDirectory['documentId']; // No .toString() needed
//         String documentName = nestedDirectory['documentName'];

//         logger.d('Document ID: $documentId');
//         logger.d('Document Name: $documentName');

//         emit(FetchDocumentSuccess(
//           documentId: documentId,
//           documentName: documentName,
//         ));
//       } catch (e) {
//         emit(FetchDocumentFailed(error: e.toString()));
//       }
//     });
    on<FetchDocs>((event, emit) async {
      try {
        var recordId = await cacheService.getString(name: 'horseTreatmentId');
        final response = await docsRepo.postfetchDocs(
            recordId: recordId,
            tableName: 'Treatment',
            displayPane: 'TreatmentDocs');

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
    }); // In TreatmentFormBloc

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
