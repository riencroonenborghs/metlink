import "package:meta/meta.dart";
import "package:geolocator/geolocator.dart";
import "package:equatable/equatable.dart";
import "package:metlink/models/models.dart";

abstract class MyLocationState extends Equatable {
  MyLocationState([List props = const []]) : super(props);
}

class MyLocationInitialState extends MyLocationState {}
class MyLocationSearchingState extends MyLocationState {}
class MyLocationErrorState extends MyLocationState {}

class MyLocationFoundState extends MyLocationState {
  final Position myPosition;
  MyLocationFoundState({@required this.myPosition})
      : assert(myPosition != null),
        super([myPosition]);
}



