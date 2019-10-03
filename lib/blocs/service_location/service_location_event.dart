import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class ServiceLocationEvent extends Equatable {
  ServiceLocationEvent([List props = const []]) : super(props);
}

class ServiceLocationPerformEvent extends ServiceLocationEvent {
  final String code;
  ServiceLocationPerformEvent({@required this.code})
      : assert(code != null),
        super([code]);
}