part of 'treatment_form_bloc.dart';

sealed class TreatmentFormState extends Equatable {
  const TreatmentFormState();

  @override
  List<Object> get props => [];
}

final class TreatmentFormInitial extends TreatmentFormState {}

class TreatmentFormLoading extends TreatmentFormState {}

class TreatmentFormLoaded extends TreatmentFormState {
  final AllFormModel allFormModel;

  TreatmentFormLoaded({
    required this.allFormModel,
  });
}

class TreatmentFormSuccessfully extends TreatmentFormState {
  final String message;
  const TreatmentFormSuccessfully({required this.message});
}

class TreatmentFormerror extends TreatmentFormState {
  final String error;

  const TreatmentFormerror({required this.error});
  @override
  List<Object> get props => [error];
}

class TreatmentTypeCreateSuccess extends TreatmentFormState {
  final List<TreatmentType> types;
  TreatmentTypeCreateSuccess({required this.types});
}

class TreatmentCreateFailed extends TreatmentFormState {
  final String error;
  const TreatmentCreateFailed({required this.error});
}

// State for uploading files, extended to track the index or progress of each file
class FileUploadInProgress extends TreatmentFormState {
  final List<String> fileNames;
  final int fileIndex;

  FileUploadInProgress({
    required this.fileNames,
    required this.fileIndex,
  });

  @override
  List<Object> get props => [fileNames, fileIndex];
}

class FileUploadSuccess extends TreatmentFormState {
  final String message;

  FileUploadSuccess({required this.message});
}

class FileUploadError extends TreatmentFormState {
  final String error;

  FileUploadError({required this.error});
}

class TreatmentTypeDeleted extends TreatmentFormState {
  final List<TreatmentType> types;

  TreatmentTypeDeleted({required this.types});
}

class FetchDocumentSuccess extends TreatmentFormState {
  final List<Map<String, dynamic>> documentsList;

  FetchDocumentSuccess({required this.documentsList});

  @override
  List<Object> get props => [documentsList];
}

// class FetchDocumentSuccess extends TreatmentFormState {
//   final int documentId;
//   final String documentName;

//   FetchDocumentSuccess({
//     required this.documentId,
//     required this.documentName,
//   });
// }

class FetchDocumentFailed extends TreatmentFormState {
  final String error;

  FetchDocumentFailed({required this.error});
  @override
  List<Object> get props => [error];
}

class FileDownloadInProgress extends TreatmentFormState {
  final int documentId;

  const FileDownloadInProgress({required this.documentId});

  @override
  List<Object> get props => [documentId];
}

class FileDownloadSuccess extends TreatmentFormState {}

class FileDownloadError extends TreatmentFormState {
  final String error;

  const FileDownloadError({required this.error});

  @override
  List<Object> get props => [error];
}
