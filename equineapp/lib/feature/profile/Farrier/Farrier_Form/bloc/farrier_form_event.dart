part of 'farrier_form_bloc.dart';

sealed class FarrierFormEvent extends Equatable {
  const FarrierFormEvent();

  @override
  List<Object> get props => [];
}

class LoadFarrierform extends FarrierFormEvent {
  // final String id;
  const LoadFarrierform();
  @override
  List<Object> get props => [];
}

class LoadFarrierformByid extends FarrierFormEvent {
  final int id;
  const LoadFarrierformByid({required this.id});
  @override
  List<Object> get props => [];
}

class SubmitFormFarrier extends FarrierFormEvent {
  final int? id;
  final String horseId;
  final String shoeDatetime;
  final String foreShoeType;
  final String foreShoeSpecification;
  final String foreShoeComplement;
  final String hindShoeType;
  final String hindShoeSpecification;
  final String hindShoeComplement;
  final String surfaceType;
  final List<String?> filePath; // Add this field

  const SubmitFormFarrier({
    this.id,
    required this.filePath,
    required this.horseId,
    required this.shoeDatetime,
    required this.foreShoeType,
    required this.foreShoeSpecification,
    required this.foreShoeComplement,
    required this.hindShoeType,
    required this.hindShoeSpecification,
    required this.hindShoeComplement,
    required this.surfaceType,
  });
}

class SubmitforeShoeType extends FarrierFormEvent {
  final int? id;
  final String name;
  SubmitforeShoeType({this.id, required this.name});
}

class SubmitforeShoeSpecification extends FarrierFormEvent {
  final int? id;
  final String name;
  SubmitforeShoeSpecification({this.id, required this.name});
}

class SubmitforeShoeComplement extends FarrierFormEvent {
  final int? id;
  final String name;
  SubmitforeShoeComplement({this.id, required this.name});
}

class SubmithindShoeType extends FarrierFormEvent {
  final int? id;
  final String name;
  SubmithindShoeType({this.id, required this.name});
}

class SubmithindShoeSpecification extends FarrierFormEvent {
  final int? id;
  final String name;
  SubmithindShoeSpecification({this.id, required this.name});
}

class SubmithindShoeComplement extends FarrierFormEvent {
  final int? id;
  final String name;
  SubmithindShoeComplement({this.id, required this.name});
}

class SubmitsurfaceType extends FarrierFormEvent {
  final int? id;
  final String name;
  SubmitsurfaceType({this.id, required this.name});
}

// class FilePickedFarrier extends FarrierFormEvent {}

class UploadImageFarrier extends FarrierFormEvent {
  final List<String?> filePath; // Add this field

  UploadImageFarrier({required this.filePath});
}

class BeforeFilePickedFarrier extends FarrierFormEvent {}

class BeforeUploadImageFarrier extends FarrierFormEvent {}

class AfterFilePickedFarrier extends FarrierFormEvent {}

class AfterUploadImageFarrier extends FarrierFormEvent {}

class DeleteSurfaceType extends FarrierFormEvent {
  final int surfacetypeId;

  DeleteSurfaceType({required this.surfacetypeId});
}

class DeleteforeShoeType extends FarrierFormEvent {
  final int foreShoeTypeId;

  DeleteforeShoeType({required this.foreShoeTypeId});
}

class DeleteforeShoeSpecification extends FarrierFormEvent {
  final int foreShoeSpecificationId;

  DeleteforeShoeSpecification({required this.foreShoeSpecificationId});
}

class DeleteforeShoeComplement extends FarrierFormEvent {
  final int foreShoeComplementId;

  DeleteforeShoeComplement({required this.foreShoeComplementId});
}

class DeletehindShoeType extends FarrierFormEvent {
  final int hindShoeTypeId;

  DeletehindShoeType({required this.hindShoeTypeId});
}

class DeletehindShoeSpecification extends FarrierFormEvent {
  final int hindShoeSpecificationId;

  DeletehindShoeSpecification({required this.hindShoeSpecificationId});
}

class DeletehindShoeComplement extends FarrierFormEvent {
  final int hindShoeComplementId;

  DeletehindShoeComplement({required this.hindShoeComplementId});
}

class FetchDocs extends FarrierFormEvent {}

class GetDownloadDocs extends FarrierFormEvent {
  final int
      documentId; // Assuming documentId is required to download the document

  const GetDownloadDocs({required this.documentId});

  @override
  List<Object> get props => [documentId];
}
