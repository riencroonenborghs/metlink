import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:metlink/models/models.dart";

abstract class ServiceLocationState extends Equatable {
  ServiceLocationState([List props = const []]) : super(props);
}

class ServiceLocationErrorState extends ServiceLocationState {}
class ServiceLocationInitialState extends ServiceLocationState {}
class ServiceLocationSearchingState extends ServiceLocationState {}

class ServiceLocationDoneState extends ServiceLocationState {
  final List<ServiceLocation> serviceLocations;
  ServiceLocationDoneState({@required this.serviceLocations})
      : assert(serviceLocations != null),
        super([serviceLocations]);
}



