import 'package:equatable/equatable.dart';

abstract class AddTrainerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitTrainerForm extends AddTrainerEvent {
  final int? id;
  final String name;
  final String fathersName;
  final String nationality;
  final String dateOfBirth;
  final String bloodGroup;
  final String mobile;
  final String email;
  final String division;
  final String remarks;
  final String riderWeight;
  final String stablename;
  final String active;
  final String address;

  SubmitTrainerForm({
    this.id,
    required this.name,
    required this.fathersName,
    required this.nationality,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.mobile,
    required this.email,
    required this.division,
    required this.remarks,
    required this.riderWeight,
    required this.stablename,
    required this.active,
    required this.address,
  });
}

class LoadfetchTrainer extends AddTrainerEvent {}

class LoadTrainerDetails extends AddTrainerEvent {
  final int riderId;
  LoadTrainerDetails({required this.riderId});
}

class PickImage extends AddTrainerEvent {}

class UploadTrainerImage extends AddTrainerEvent {
  final bool isEdit;
  UploadTrainerImage({required this.isEdit});
}
