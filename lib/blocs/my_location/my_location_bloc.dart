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
    print("--1");
    if(event is MyLocationPerformEvent) {
      print("--2");
      yield MyLocationSearchingState();
      print("--3");
      try {
        print("--4");
        Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
        print("--5");
        print(position);
        yield MyLocationFoundState(myPosition: position);
        print("--6");
      } catch (e) {
        print("--7");
        print(e);
        yield MyLocationErrorState();
      }
    }
  }
}