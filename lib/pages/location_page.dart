import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";
import "package:metlink/models/models.dart";

class LocationPage extends StatefulWidget {
  final TransportService transportService;

  LocationPage({Key key, @required this.transportService}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with UtilsWidget {
  BuildContext buildContext;
  ServiceLocationBloc serviceLocationBloc = new ServiceLocationBloc();
  List<Marker> markers;
  List<ServiceLocation> serviceLocations;

  // List<double> zoomOptions = [2.0, 4.0, 6.0, 8.0, 10.0, 12.0];
  // double zoom = 15.0;

  Widget _showMap() {
    return Flexible(
      child: FlutterMap(
        options: MapOptions(
          center: markers[0].point,
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ["a", "b", "c"]
          ),
          MarkerLayerOptions(markers: markers)
        ],
      ),
    );
  }

  Widget _loadTransportVehicles() {
    return BlocBuilder<ServiceLocationEvent, ServiceLocationState>(
      bloc: serviceLocationBloc,
      builder: (_, ServiceLocationState serviceLocationState) {
        if(serviceLocationState is ServiceLocationInitialState) {
          return Container();
        }
        if(serviceLocationState is ServiceLocationSearchingState) {
          return waiting(buildContext, "Searching...");
        }
        if(serviceLocationState is ServiceLocationErrorState) {
          return errorMessage("Something went wrong :(");
        }
        if(serviceLocationState is ServiceLocationDoneState) {
          markers = new List<Marker>();
          serviceLocationState.serviceLocations.forEach((serviceLocation) {
            Marker marker = Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(serviceLocation.lat, serviceLocation.long),
              builder: (ctx) => Container(
                child: Icon(Icons.location_on)
              )
            );
            markers.add(marker);
          });
          return _showMap();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    serviceLocationBloc = new ServiceLocationBloc();
    serviceLocationBloc.dispatch(ServiceLocationPerformEvent(code: widget.transportService.code));

    return Scaffold(
      appBar: AppBar(
        title: Text("Service ${widget.transportService.code} - ${widget.transportService.name}")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _loadTransportVehicles()
          ]
        )
      )
    );
  }
}
