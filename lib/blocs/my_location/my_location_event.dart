import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class MyLocationEvent extends Equatable {
  MyLocationEvent([List props = const []]) : super(props);
}

class MyLocationPerformEvent extends MyLocationEvent {}