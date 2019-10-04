import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";

// pk.eyJ1IjoicmllbmMiLCJhIjoiY2sxYWVkemxjMmJ6ODNrbzN3dGxjNW56aSJ9.nl5Z8uvIm0nTCQGxpoy-Ug


class ServicePage extends StatefulWidget {
  final String code;
  final String name;

  ServicePage({Key key, @required this.code, @required this.name}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> with UtilsWidget {
  BuildContext buildContext;
  ServiceLocationBloc serviceLocationBloc = new ServiceLocationBloc();
  List<Marker> markers;

  // List<double> zoomOptions = [2.0, 4.0, 6.0, 8.0, 10.0, 12.0];
  // double zoom = 15.0;

  Widget _showMap() {
    return Flexible(
      child: FlutterMap(
        options: MapOptions(
          // center: LatLng(51.5, -0.09),
          center: markers[0].point,
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: markers)
        ],
      ),
    );
  }

  Widget _loadBuses() {
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
          var services = serviceLocationState.result["Services"];
          services.forEach((service) {
            Marker marker = Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(double.parse(service["Lat"]), double.parse(service["Long"])),
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
    serviceLocationBloc.dispatch(ServiceLocationPerformEvent(code: widget.code));

    return Scaffold(
      appBar: AppBar(
        title: Text("Service ${widget.code} - ${widget.name}")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // leftAlignText("Map"),
            _loadBuses()
          ]
        )
      )
    );
  }
}
