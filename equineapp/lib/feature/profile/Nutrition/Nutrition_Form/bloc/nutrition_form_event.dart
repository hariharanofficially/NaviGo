part of 'nutrition_form_bloc.dart';

sealed class NutritionFormEvent extends Equatable {
  const NutritionFormEvent();

  @override
  List<Object> get props => [];
}

class LoadNutritionform extends NutritionFormEvent {
  // final String id;
  const LoadNutritionform();
  @override
  List<Object> get props => [];
}

class LoadNutritionformByid extends NutritionFormEvent {
  final int id;
  const LoadNutritionformByid({required this.id});
  @override
  List<Object> get props => [];
}
// class LoadFetchNutrition extends NutritionFormEvent {}

class SubmitFoodType extends NutritionFormEvent {
  final int? id;
  final String name;
  final String descripition;
  SubmitFoodType({this.id, required this.name, required this.descripition});
}

class SubmitFoodUomType extends NutritionFormEvent {
  final int? id;
  final String name;
  SubmitFoodUomType({
    this.id,
    required this.name,
  });
}

class SubmitFormNutrition extends NutritionFormEvent {
  final int? id;
  final String horseId;
  final String nutritiondatetime;
  final String foodType;
  final String feeduom;
  final String servingValue;
  final List<String?> filePath; // Add this field

  const SubmitFormNutrition({
    this.id,
    required this.filePath,
    required this.horseId,
    required this.foodType,
    required this.feeduom,
    required this.servingValue,
    required this.nutritiondatetime,
  });
}

class FilePickedEvent extends NutritionFormEvent {}

class UploadImageNutrition extends NutritionFormEvent {
  final List<String?> filePath; // Add this field

  UploadImageNutrition({required this.filePath});
  // final int id;
  // const UploadImageNutrition({
  //   required this.id,
  // });
}

class DeleteFoodType extends NutritionFormEvent {
  final int surfacetypeId;

  DeleteFoodType({required this.surfacetypeId});
}

class DeletefoodType extends NutritionFormEvent {
  final int foodTypeId;

  DeletefoodType({required this.foodTypeId});
}

class Deletefooduom extends NutritionFormEvent {
  final int FooduomId;

  Deletefooduom({required this.FooduomId});
}

class FetchDocs extends NutritionFormEvent {}

class GetDownloadDocs extends NutritionFormEvent {
  final int
      documentId; // Assuming documentId is required to download the document

  const GetDownloadDocs({required this.documentId});

  @override
  List<Object> get props => [documentId];
}
