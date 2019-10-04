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
  final List<TransportService> transportServices;
  StopDeparturesDoneState({@required this.transportServices})
      : assert(transportServices != null),
        super([transportServices]);
}



