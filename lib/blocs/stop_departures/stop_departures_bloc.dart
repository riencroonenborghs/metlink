import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";

class StopDeparturesBloc extends Bloc<StopDeparturesEvent, StopDeparturesState> {
  final StopDeparturesService stopDeparturesService = new StopDeparturesService();

  StopDeparturesBloc();

  @override
  StopDeparturesState get initialState => StopDeparturesInitialState();

  @override
  Stream<StopDeparturesState> mapEventToState(StopDeparturesEvent event) async* {
    if(event is StopDeparturesPerformEvent) {
      yield StopDeparturesSearchingState();
      try {
        dynamic data = await stopDeparturesService.search(event.stop);        
        yield StopDeparturesDoneState(result: data);
      } catch (_) {
        yield StopDeparturesErrorState();
      }
    }
  }
}