// add_event_event.dart
import 'package:equatable/equatable.dart';

abstract class AddEventEvent extends Equatable {
  const AddEventEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends AddEventEvent {
  final int? id;
  final String fromScreen;
  final String startDate;
  final String endDate;
  final String shortName;
  final String title;
  final String groupName;
  final String locationName;
  final String city;
  final String rideStartTime;
  final String rideDate;
  final String source;
  final String vendorName;
  final String stableId;
  final String eventGroupId;
  final String eventTypeId;
  final String eventCountryId;
  final String divisionId;
  final String category;

  SubmitForm(
      {this.id,
      required this.fromScreen,
      required this.startDate,
      required this.endDate,
      required this.shortName,
      required this.title,
      required this.groupName,
      required this.locationName,
      required this.city,
      required this.rideStartTime,
      required this.rideDate,
      required this.source,
      required this.vendorName,
      required this.stableId,
      required this.eventGroupId,
      required this.eventTypeId,
      required this.divisionId,
      required this.eventCountryId,
      required this.category});
}

class Loadfetchevent extends AddEventEvent {}

class LoadeventDetails extends AddEventEvent {
  final int eventId;
  const LoadeventDetails({required this.eventId});
}

class PickImage extends AddEventEvent {}

class UploadEventImage extends AddEventEvent {}
