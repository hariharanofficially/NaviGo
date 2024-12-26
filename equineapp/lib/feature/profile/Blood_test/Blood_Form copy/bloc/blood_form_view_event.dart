part of 'blood_form_view_bloc.dart';

sealed class BloodFormViewEvent extends Equatable {
  const BloodFormViewEvent();

  @override
  List<Object> get props => [];
}

class LoadBloodFormView extends BloodFormViewEvent {
  final String horseId;
  final String testDate;

  LoadBloodFormView({required this.testDate, required this.horseId});
}
