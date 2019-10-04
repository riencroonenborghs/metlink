import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:metlink/models/models.dart";

abstract class StopDeparturesState extends Equatable {
  StopDeparturesState([List props = const []]) : super(props);
}

class StopDeparturesErrorState extends StopDeparturesState {}
class StopDeparturesInitialState extends StopDeparturesState {}
class StopDeparturesSearchingState extends StopDeparturesState {}

class StopDeparturesDoneState extends StopDeparturesState {
  final List<StopDeparture> stopDepartures;
  StopDeparturesDoneState({@required this.stopDepartures})
      : assert(stopDepartures != null),
        super([stopDepartures]);
}



