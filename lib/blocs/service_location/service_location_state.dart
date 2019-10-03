import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class ServiceLocationState extends Equatable {
  ServiceLocationState([List props = const []]) : super(props);
}

class ServiceLocationErrorState extends ServiceLocationState {}
class ServiceLocationInitialState extends ServiceLocationState {}
class ServiceLocationSearchingState extends ServiceLocationState {}

class ServiceLocationDoneState extends ServiceLocationState {
  final dynamic result;
  ServiceLocationDoneState({@required this.result})
      : assert(result != null),
        super([result]);
}



