part of 'farrier_form_bloc.dart';

sealed class FarrierFormState extends Equatable {
  const FarrierFormState();

  @override
  List<Object> get props => [];
}

final class FarrierFormInitial extends FarrierFormState {}

class FarrierFormLoading extends FarrierFormState {}

class FarrierFormLoaded extends FarrierFormState {
  final AllFormModel allFormModel;

  FarrierFormLoaded({
    required this.allFormModel,
  });
}

class FarrierFormSuccessfully extends FarrierFormState {
  final String message;
  const FarrierFormSuccessfully({required this.message});
}

class FarrierFormerror extends FarrierFormState {
  final String error;

  const FarrierFormerror({required this.error});
}

class foreShoeTypeCreateSuccess extends FarrierFormState {
  final List<shoeType> types;
  foreShoeTypeCreateSuccess({required this.types});
}

class foreshoeCreateFailed extends FarrierFormState {
  final String error;
  const foreshoeCreateFailed({required this.error});
}

class foreshoeSpecfCreateSuccess extends FarrierFormState {
  final List<shoeSpecification> types;
  foreshoeSpecfCreateSuccess({required this.types});
}

class foreshoeSpecfCreateFailed extends FarrierFormState {
  final String error;
  const foreshoeSpecfCreateFailed({required this.error});
}

class foreshoecompCreateSuccess extends FarrierFormState {
  final List<shoeComplement> types;
  foreshoecompCreateSuccess({required this.types});
}

class foreshoecompCreateFailed extends FarrierFormState {
  final String error;
  const foreshoecompCreateFailed({required this.error});
}

class hindShoeTypeCreateSuccess extends FarrierFormState {
  final List<shoeType> types;
  hindShoeTypeCreateSuccess({required this.types});
}

class hindshoeCreateFailed extends FarrierFormState {
  final String error;
  const hindshoeCreateFailed({required this.error});
}

class hindshoeSpecfCreateSuccess extends FarrierFormState {
  final List<shoeSpecification> types;
  hindshoeSpecfCreateSuccess({required this.types});
}

class hindshoeSpecfCreateFailed extends FarrierFormState {
  final String error;
  const hindshoeSpecfCreateFailed({required this.error});
}

class hindshoecompCreateSuccess extends FarrierFormState {
  final List<shoeComplement> types;
  hindshoecompCreateSuccess({required this.types});
}

class hindshoecompCreateFailed extends FarrierFormState {
  final String error;
  const hindshoecompCreateFailed({required this.error});
}

class SurfaceTypeCreateSuccess extends FarrierFormState {
  final List<SurfaceType> types;
  SurfaceTypeCreateSuccess({required this.types});
}

class SurfaceTypeCreateFailed extends FarrierFormState {
  final String error;
  const SurfaceTypeCreateFailed({required this.error});
}

class FileUploadInProgress extends FarrierFormState {
  final List<String> fileNames;
  final int fileIndex;

  FileUploadInProgress({
    required this.fileNames,
    required this.fileIndex,
  });

  @override
  List<Object> get props => [fileNames, fileIndex];
}
// class FileSelectedFarrier extends FarrierFormState {
//   final File pickedImage;
//   FileSelectedFarrier({required this.pickedImage});
// }

// class FilePickerError extends FarrierFormState {
//   final String message;

//   FilePickerError(this.message);
// }

class BeforeFileSelectedFarrier extends FarrierFormState {
  final File pickedImage1;
  BeforeFileSelectedFarrier({required this.pickedImage1});
}

class BeforeFilePickerError extends FarrierFormState {
  final String message;

  BeforeFilePickerError(this.message);
}

class AfterFileSelectedFarrier extends FarrierFormState {
  final File pickedImage2;
  AfterFileSelectedFarrier({required this.pickedImage2});
}

class AfterFilePickerError extends FarrierFormState {
  final String message;

  AfterFilePickerError(this.message);
}

class ImageUploadSuccessfully extends FarrierFormState {
  final String message;

  const ImageUploadSuccessfully({required this.message});
}

class ImageUploadFailed extends FarrierFormState {
  final String error;

  const ImageUploadFailed({required this.error});
}

class SurfaceTypeDeleted extends FarrierFormState {
  final List<SurfaceType> types;

  SurfaceTypeDeleted({required this.types});
}

class foreShoeTypeDeleted extends FarrierFormState {
  final List<shoeType> types;

  foreShoeTypeDeleted({required this.types});
}

class foreShoeSpecificationDeleted extends FarrierFormState {
  final List<shoeSpecification> types;

  foreShoeSpecificationDeleted({required this.types});
}

class foreShoeComplementDeleted extends FarrierFormState {
  final List<shoeComplement> types;

  foreShoeComplementDeleted({required this.types});
}

class hindShoeTypeDeleted extends FarrierFormState {
  final List<shoeType> types;

  hindShoeTypeDeleted({required this.types});
}

class hindShoeSpecificationDeleted extends FarrierFormState {
  final List<shoeSpecification> types;

  hindShoeSpecificationDeleted({required this.types});
}

class hindShoeComplementDeleted extends FarrierFormState {
  final List<shoeComplement> types;

  hindShoeComplementDeleted({required this.types});
}

class FetchDocumentSuccess extends FarrierFormState {
  final List<Map<String, dynamic>> documentsList;

  FetchDocumentSuccess({required this.documentsList});

  @override
  List<Object> get props => [documentsList];
}

class FetchDocumentFailed extends FarrierFormState {
  final String error;

  FetchDocumentFailed({required this.error});
  @override
  List<Object> get props => [error];
}

class FileDownloadInProgress extends FarrierFormState {
  final int documentId;

  FileDownloadInProgress({required this.documentId});

  @override
  List<Object> get props => [documentId];
}

class FileDownloadSuccess extends FarrierFormState {}

class FileDownloadError extends FarrierFormState {
  final String error;

  FileDownloadError({required this.error});

  @override
  List<Object> get props => [error];
}
