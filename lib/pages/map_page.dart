import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong/latlong.dart";
import "dart:async";

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";
import "package:metlink/models/models.dart";

class MapPage extends StatefulWidget {
  final ServiceLocation serviceLocation;

  MapPage({Key key, @required this.serviceLocation}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with UtilsWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext buildContext;
  ServiceLocationBloc serviceLocationBloc = new ServiceLocationBloc();
  List<ServiceLocation> serviceLocations;
  Marker marker;
  Timer timer;

  Marker _createMarker() {
    serviceLocations.forEach((serviceLocation){
      if(serviceLocation.vehicleRef == widget.serviceLocation.vehicleRef) {
        print("bearing ${serviceLocation.bearing} -> ${serviceLocation.bearingRadians}");
        marker = Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(serviceLocation.lat, serviceLocation.long),
          builder: (ctx) => Container(
            child: GestureDetector(
              onTap: () {
                String text = "Is on time.";
                if(serviceLocation.isBehind) {
                  text = "Delayed by ${(serviceLocation.delayInS / 60).ceil()} minutes.";
                }
                text += " On its way to ${serviceLocation.destinationStopName}.";
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(text),
                ));
              },
              child: Container(
                child: Transform.rotate(
                  angle: serviceLocation.bearingRadians,
                  child: Image.asset("assets/images/bus-primary.png")
                )
              )
            )
          )
        );
      }
    });    
  }

  Widget _showMap() {
    return Flexible(
      child: FlutterMap(
        options: MapOptions(
          center: marker.point,
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ["a", "b", "c"]
          ),
          MarkerLayerOptions(markers: [marker])
        ]
      )
    );
  }

  Widget _searchList(List<ServiceLocation> serviceLocations) {
    List<Widget> cards = new List<Widget>();
    serviceLocations.forEach((serviceLocation) {
      String title = "Vehicle #${serviceLocation.vehicleRef} going to ${serviceLocation.destinationStopName}";
      String subtitle = "";
      if(serviceLocation.isBehind) {
        subtitle = "delayed by ${(serviceLocation.delayInS / 60).ceil()} minutes.";
      }
      Card card = Card(
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              buildContext,
              MaterialPageRoute(
                builder: (context) => MapPage(serviceLocation: serviceLocation)
              )
            );
          }
        ),
      );
      cards.add(card);
    });
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ListView(
          shrinkWrap: true,
          children: cards
        )
      )
    );
  }

  Widget _searchResults() {
    return BlocBuilder<ServiceLocationEvent, ServiceLocationState>(
      bloc: serviceLocationBloc,
      builder: (_, ServiceLocationState serviceLocationState) {
        if(serviceLocationState is ServiceLocationInitialState) {
          if(marker != null) { return _showMap(); }
          return Container();
        }
        if(serviceLocationState is ServiceLocationSearchingState) {
          if(marker != null) { return _showMap(); }
          return waiting(buildContext, "Searching...");
        }
        if(serviceLocationState is ServiceLocationErrorState) {
          if(marker != null) { return _showMap(); }
          return errorMessage("Something went wrong :(");
        }
        if(serviceLocationState is ServiceLocationDoneState) {
          serviceLocations = serviceLocationState.serviceLocations;
          _createMarker();
          return _showMap();
        }
      }
    );
  }

  _reload() {
    print("loading ${DateTime.now()}");
    serviceLocationBloc.dispatch(ServiceLocationPerformEvent(code: widget.serviceLocation.stopDeparture.code));
  }

  @override
  void dispose() {
    if(timer != null ) { timer.cancel(); }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    serviceLocationBloc = new ServiceLocationBloc();

    _reload();
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Vehicle ${widget.serviceLocation.vehicleRef}")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            leftAlignText("Going to ${widget.serviceLocation.destinationStopName}"),
            _searchResults()
          ]
        )
      )
    );
  }
}
