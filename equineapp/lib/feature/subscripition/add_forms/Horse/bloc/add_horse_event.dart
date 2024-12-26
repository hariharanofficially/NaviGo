import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddHorseEvent extends Equatable {
  const AddHorseEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends AddHorseEvent {
  final int?
      id; // Nullable integer for horse ID; if null, it's an "add" operation.
  final String name;
  final String currentname;
  final String originalname;
  final String dateOfBirth;
  final String microchipNo;
  final String remarks;
  final String breedId;
  final String divisionId;
  final String active;
  final String stableId;
  const SubmitForm({
    this.id, // Make id nullable; this indicates whether it's an add or update operation.
    required this.name,
    required this.currentname,
    required this.originalname,
    required this.dateOfBirth,
    required this.microchipNo,
    required this.remarks,
    required this.breedId,
    required this.divisionId,
    required this.active,
    required this.stableId,
  });
}

class SelectDate extends AddHorseEvent {
  final BuildContext context;
  const SelectDate(this.context);

  @override
  List<Object> get props => [context];
}

class LoadFetch extends AddHorseEvent {}

class LoadHorseDetails extends AddHorseEvent {
  final int horseId;
  // final XFile? imageFile;
  const LoadHorseDetails({
    required this.horseId,
    // this.imageFile,
  });
}

class PickImage extends AddHorseEvent {}

class UploadStableImage extends AddHorseEvent {
  final bool isEdit;
  UploadStableImage({required this.isEdit});
}
// class LoadHorseData extends AddHorseEvent {
//   final int? horseId;F
//
//   LoadHorseData({this.horseId});
// }

// class LoadHorseDetails extends AddHorseEvent {
//   final int horseId;

//  const LoadHorseDetails({required this.horseId});

// }

// class LoadFormData extends AddHorseEvent {}
