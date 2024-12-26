part of 'treatment_form_bloc.dart';

sealed class TreatmentFormEvent extends Equatable {
  const TreatmentFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitFormTreatment extends TreatmentFormEvent {
  final int? id;
  final String horseId;
  final String notes;
  final String treatmentDatetime;
  final String nextCheckupDatetime;
  final String treatmenttypeid;
  final List<String?> filePath; // Add this field

  const SubmitFormTreatment({
    this.id,
    required this.filePath,
    required this.horseId,
    required this.notes,
    required this.treatmentDatetime,
    required this.nextCheckupDatetime,
    required this.treatmenttypeid,
  });
}

class LoadTreatmentform extends TreatmentFormEvent {
  // final String id;
  const LoadTreatmentform();
  @override
  List<Object> get props => [];
}

class LoadTreatmentformByid extends TreatmentFormEvent {
  final int id;
  const LoadTreatmentformByid({required this.id});
  @override
  List<Object> get props => [];
}

class SubmitTreatmentType extends TreatmentFormEvent {
  final int? id;
  final String name;
  SubmitTreatmentType({this.id, required this.name});
}

class UploadTreatmentFile extends TreatmentFormEvent {
  final List<String?> filePath; // Add this field

  UploadTreatmentFile({required this.filePath});
}

class DeleteTreatmentType extends TreatmentFormEvent {
  final int treatmenttypeId;

  DeleteTreatmentType({required this.treatmenttypeId});
}

class FetchDocs extends TreatmentFormEvent {}

class GetDownloadDocs extends TreatmentFormEvent {
  final int
      documentId; // Assuming documentId is required to download the document

  const GetDownloadDocs({required this.documentId});

  @override
  List<Object> get props => [documentId];
}
