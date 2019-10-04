import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";
import "package:metlink/models/models.dart";

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
        List<StopDeparture> stopDepartures = await stopDeparturesService.search(event.stop);        
        yield StopDeparturesDoneState(stopDepartures: stopDepartures);
      } catch (_) {
        yield StopDeparturesErrorState();
      }
    }
  }
}