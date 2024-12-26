import 'package:equatable/equatable.dart';

abstract class AddRiderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitRiderForm extends AddRiderEvent {
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

  SubmitRiderForm(
      {this.id,
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
      required this.active});
}

class Loadfetchrider extends AddRiderEvent {}

class LoadriderDetails extends AddRiderEvent {
  final int riderId;
  LoadriderDetails({required this.riderId});
}

class PickImage extends AddRiderEvent {}

class UploadRiderImage extends AddRiderEvent {
  final bool isEdit;

  UploadRiderImage({
    required this.isEdit,
  });
}
