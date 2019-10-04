import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";
import "package:metlink/models/models.dart";

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
        List<ServiceLocation> serviceLocations = await serviceLocationService.search(event.code);        
        yield ServiceLocationDoneState(serviceLocations: serviceLocations);
      } catch (_) {
        yield ServiceLocationErrorState();
      }
    }
  }
}