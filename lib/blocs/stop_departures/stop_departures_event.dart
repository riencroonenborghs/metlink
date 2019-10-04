import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:metlink/models/models.dart";

abstract class StopDeparturesEvent extends Equatable {
  StopDeparturesEvent([List props = const []]) : super(props);
}

class StopDeparturesPerformEvent extends StopDeparturesEvent {
  final Stop stop;
  StopDeparturesPerformEvent({@required this.stop})
      : assert(stop != null),
        super([stop]);
}