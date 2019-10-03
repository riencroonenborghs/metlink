import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class StopDeparturesEvent extends Equatable {
  StopDeparturesEvent([List props = const []]) : super(props);
}

class StopDeparturesPerformEvent extends StopDeparturesEvent {
  final String stop;
  StopDeparturesPerformEvent({@required this.stop})
      : assert(stop != null),
        super([stop]);
}