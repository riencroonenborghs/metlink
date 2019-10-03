import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class ServiceLocationEvent extends Equatable {
  ServiceLocationEvent([List props = const []]) : super(props);
}

class ServiceLocationPerformEvent extends ServiceLocationEvent {
  final String number;
  ServiceLocationPerformEvent({@required this.number})
      : assert(number != null),
        super([number]);
}