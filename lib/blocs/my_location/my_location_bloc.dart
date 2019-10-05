import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:geolocator/geolocator.dart";

import "package:metlink/blocs/blocs.dart";
import "package:metlink/services/services.dart";
import "package:metlink/models/models.dart";

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc();

  @override
  MyLocationState get initialState => MyLocationInitialState();

  @override
  Stream<MyLocationState> mapEventToState(MyLocationEvent event) async* {
    if(event is MyLocationPerformEvent) {
      yield MyLocationSearchingState();
      try {
        Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
        // -41.2845402,174.7242675
        position = Position(
          latitude: -41.2845402,
          longitude: 174.7242675,
          timestamp: null,
          mocked: null,
          accuracy: null,
          altitude: null,
          heading: null,
          speed: null,
          speedAccuracy: null
        );
        yield MyLocationFoundState(myPosition: position);
      } catch (_) {
        yield MyLocationErrorState();
      }
    }
  }
}