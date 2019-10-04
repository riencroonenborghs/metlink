import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";
import "package:metlink/models/models.dart";

class StopSearchBloc extends Bloc<StopSearchEvent, StopSearchState> {
  final StopSearchService searchService = new StopSearchService();

  StopSearchBloc();

  @override
  StopSearchState get initialState => StopSearchInitialState();

  @override
  Stream<StopSearchState> mapEventToState(StopSearchEvent event) async* {
    if(event is StopSearchPerformEvent) {
      yield StopSearchStopSearchingState();
      try {
        List<Stop> stops = await searchService.search(event.query);
        yield StopSearchDoneState(stops: stops);
      } catch (_) {
        yield StopSearchErrorState();
      }
    }
  }
}