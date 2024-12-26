import 'package:equatable/equatable.dart';

abstract class HorseDashboardEvent extends Equatable {
  const HorseDashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadHorses extends HorseDashboardEvent {
  // final String id;
  const LoadHorses();
  @override
  List<Object> get props =>[];
}

class DeleteHorse extends HorseDashboardEvent {
  final int horseId;

  DeleteHorse({required this.horseId});
}