part of 'nutrition_form_bloc.dart';

sealed class NutritionFormState extends Equatable {
  const NutritionFormState();

  @override
  List<Object> get props => [];
}

final class NutritionFormInitial extends NutritionFormState {}

class NutritionFormLoading extends NutritionFormState {}

class NutritionFormLoaded extends NutritionFormState {
  final AllFormModel allFormModel;
  NutritionFormLoaded({
    required this.allFormModel,
  });
}

class NutritionFormSuccessfully extends NutritionFormState {
  final String message;

  const NutritionFormSuccessfully({required this.message});
}

class NutritionFormerror extends NutritionFormState {
  final String error;

  const NutritionFormerror({required this.error});
}

class FoodTypeCreateSuccess extends NutritionFormState {
  final List<FoodType> types;
  FoodTypeCreateSuccess({required this.types});
}

class FoodTypeCreateFailed extends NutritionFormState {
  final String error;
  const FoodTypeCreateFailed({required this.error});
}

class FoodUomTypeCreateSuccess extends NutritionFormState {
  final List<FoodUomType> types;
  FoodUomTypeCreateSuccess({required this.types});
}

class FoodUomTypeCreateFailed extends NutritionFormState {
  final String error;
  const FoodUomTypeCreateFailed({required this.error});
}

class FileUploadInProgress extends NutritionFormState {
  final List<String> fileNames;
  final int fileIndex;

  FileUploadInProgress({
    required this.fileNames,
    required this.fileIndex,
  });

  @override
  List<Object> get props => [fileNames, fileIndex];
}
// class FileSelected extends NutritionFormState {
//   final File pickedImage;
//   FileSelected({required this.pickedImage});
// }

// class FilePickerError extends NutritionFormState {
//   final String message;

//   FilePickerError(this.message);
// }

class ImageUploadSuccessfully extends NutritionFormState {
  final String message;

  const ImageUploadSuccessfully({required this.message});
}

class ImageUploadFailed extends NutritionFormState {
  final String error;

  const ImageUploadFailed({required this.error});
}

class FoodTypeDeleted extends NutritionFormState {
  final List<FoodType> types;

  FoodTypeDeleted({required this.types});
}

class FooduomDeleted extends NutritionFormState {
  final List<FoodUomType> types;

  FooduomDeleted({required this.types});
}

class FetchDocumentSuccess extends NutritionFormState {
  final List<Map<String, dynamic>> documentsList;

  FetchDocumentSuccess({required this.documentsList});

  @override
  List<Object> get props => [documentsList];
}

class FetchDocumentFailed extends NutritionFormState {
  final String error;

  FetchDocumentFailed({required this.error});
  @override
  List<Object> get props => [error];
}

class FileDownloadInProgress extends NutritionFormState {
  final int documentId;

  FileDownloadInProgress({required this.documentId});

  @override
  List<Object> get props => [documentId];
}

class FileDownloadSuccess extends NutritionFormState {}

class FileDownloadError extends NutritionFormState {
  final String error;

  FileDownloadError({required this.error});

  @override
  List<Object> get props => [error];
}
