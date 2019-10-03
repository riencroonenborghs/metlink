import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";

class ServiceLocationBloc extends Bloc<ServiceLocationEvent, ServiceLocationState> {
  final ServiceLocationService searchLocationService = new ServiceLocationService();

  ServiceLocationBloc();

  @override
  ServiceLocationState get initialState => ServiceLocationInitialState();

  @override
  Stream<ServiceLocationState> mapEventToState(ServiceLocationEvent event) async* {
    if(event is ServiceLocationPerformEvent) {
      yield ServiceLocationSearchingState();
      try {
        dynamic data = await searchLocationService.search(event.number);        
        yield ServiceLocationDoneState(result: data);
      } catch (_) {
        yield ServiceLocationErrorState();
      }
    }
  }
}