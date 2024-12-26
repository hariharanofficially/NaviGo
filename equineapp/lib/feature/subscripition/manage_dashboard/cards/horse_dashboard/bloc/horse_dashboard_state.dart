import 'package:EquineApp/data/models/horse_model.dart';
import 'package:equatable/equatable.dart';

abstract class HorseDashboardState extends Equatable {
  const HorseDashboardState();

  @override
  List<Object> get props => [];
}

class HorsesLoading extends HorseDashboardState {}

class HorsesLoaded extends HorseDashboardState {
  final List<HorseModel> horses;

  const HorsesLoaded({required this.horses});

  @override
  List<Object> get props => [horses];
}

class HorsesError extends HorseDashboardState {
  final String message;

  const HorsesError(this.message);

  @override
  List<Object> get props => [message];
}
