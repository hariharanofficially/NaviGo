import 'package:equatable/equatable.dart';

abstract class myplanEvent extends Equatable {
  const myplanEvent();

  @override
  List<Object> get props => [];
}

class Loadmyplan extends myplanEvent {}

class Upgrademyplan extends myplanEvent {}
