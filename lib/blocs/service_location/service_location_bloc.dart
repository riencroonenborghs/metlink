import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";

class ServiceLocationBloc extends Bloc<ServiceLocationEvent, ServiceLocationState> {
  final ServiceLocationService serviceLocationService = new ServiceLocationService();

  ServiceLocationBloc();

  @override
  ServiceLocationState get initialState => ServiceLocationInitialState();

  @override
  Stream<ServiceLocationState> mapEventToState(ServiceLocationEvent event) async* {
    if(event is ServiceLocationPerformEvent) {
      yield ServiceLocationSearchingState();
      try {
        dynamic data = await serviceLocationService.search(event.code);        
        yield ServiceLocationDoneState(result: data);
      } catch (_) {
        yield ServiceLocationErrorState();
      }
    }
  }
}