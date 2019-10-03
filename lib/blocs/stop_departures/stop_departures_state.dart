import "package:meta/meta.dart";
import "package:equatable/equatable.dart";

abstract class StopDeparturesState extends Equatable {
  StopDeparturesState([List props = const []]) : super(props);
}

class StopDeparturesErrorState extends StopDeparturesState {}
class StopDeparturesInitialState extends StopDeparturesState {}
class StopDeparturesSearchingState extends StopDeparturesState {}

class StopDeparturesDoneState extends StopDeparturesState {
  final dynamic result;
  StopDeparturesDoneState({@required this.result})
      : assert(result != null),
        super([result]);
}



