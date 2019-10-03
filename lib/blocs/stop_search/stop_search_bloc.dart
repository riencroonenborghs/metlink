import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";

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
        dynamic data = await searchService.search(event.query);        
        yield StopSearchDoneState(result: data);
      } catch (_) {
        yield StopSearchErrorState();
      }
    }
  }
}