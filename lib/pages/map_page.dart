import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong/latlong.dart";
import "package:geolocator/geolocator.dart";
import "dart:async";

import "package:metlink/constants.dart";
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
  MyLocationBloc myLocationBloc = new MyLocationBloc();
  // ServiceLocationBloc serviceLocationBloc = new ServiceLocationBloc();
  // List<ServiceLocation> serviceLocations;
  Marker myLocationMarker;

  // Timer timer;

  Marker _createMyLocationMarker(Position myPosition) {
    myLocationMarker = Marker(
      width: 45.0,
      height: 45.0,
      point: LatLng(myPosition.latitude, myPosition.longitude),
      builder: (ctx) => Container(
        child: GestureDetector(
          onTap: () {
            print("something");
          },
          child: Icon(Icons.location_on)
          // child: Container(
          //   child: Transform.rotate(
          //     angle: serviceLocation.bearingRadians,
          //     child: serviceLocation.bearing < 180 ? 
          //       Image.asset("assets/images/bus-primary-going-east.png") :
          //       Image.asset("assets/images/bus-primary-going-west.png")
          //   )
          // )
        )
      )
    );
  }

  Widget _showMap() {
    return Flexible(
      child: FlutterMap(
        options: MapOptions(
          center: myLocationMarker == null ? beehiveMarker.point : myLocationMarker.point,
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ["a", "b", "c"]
          ),
          MarkerLayerOptions(markers: [myLocationMarker == null ? beehiveMarker : myLocationMarker])
        ]
      )
    );
  }

  // Widget _searchList(List<ServiceLocation> serviceLocations) {
  //   List<Widget> cards = new List<Widget>();
  //   serviceLocations.forEach((serviceLocation) {
  //     String title = "Vehicle #${serviceLocation.vehicleRef} going to ${serviceLocation.destinationStopName}";
  //     String subtitle = "";
  //     if(serviceLocation.isBehind) {
  //       subtitle = "delayed by ${(serviceLocation.delayInS / 60).ceil()} minutes.";
  //     }
  //     Card card = Card(
  //       child: ListTile(
  //         title: Text(title),
  //         subtitle: Text(subtitle),
  //         trailing: Icon(Icons.chevron_right),
  //         onTap: () {
  //           Navigator.push(
  //             buildContext,
  //             MaterialPageRoute(
  //               builder: (context) => MapPage(serviceLocation: serviceLocation)
  //             )
  //           );
  //         }
  //       ),
  //     );
  //     cards.add(card);
  //   });
  //   return Expanded(
  //     child: Padding(
  //       padding: EdgeInsets.only(top: 8.0),
  //       child: ListView(
  //         shrinkWrap: true,
  //         children: cards
  //       )
  //     )
  //   );
  // }

  Widget _showMyLocation() {
    return BlocBuilder<MyLocationEvent, MyLocationState>(
      bloc: myLocationBloc,
      builder: (_, MyLocationState myLocationState) {
        if(myLocationState is MyLocationInitialState) {
          return _showMap();
        }
        if(myLocationState is MyLocationSearchingState) {
          return _showMap();
        }
        if(myLocationState is MyLocationErrorState) {
          return _showMap();
        }
        if(myLocationState is MyLocationFoundState) {
          _createMyLocationMarker(myLocationState.myPosition);
          return _showMap();
        }
      }
    );
  }

  // _reload() {
  //   print("loading ${DateTime.now()}");
  //   serviceLocationBloc.dispatch(ServiceLocationPerformEvent(code: widget.serviceLocation.stopDeparture.code));
  // }

  // @override
  // void dispose() {
  //   if(timer != null ) { timer.cancel(); }
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    myLocationBloc = new MyLocationBloc();
    myLocationBloc.dispatch(MyLocationPerformEvent());
    // serviceLocationBloc = new ServiceLocationBloc();

  //   _reload();
  //   timer = Timer.periodic(Duration(seconds: 10), (timer) {
  //     _reload();
  //   });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Metlink: Is my bus going to show up?")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            //   child: leftAlignText("Going to ${widget.serviceLocation.destinationStopName}.")
            // ),
            // _showMap(),
            _showMyLocation()
          ]
        )
      )
    );
  }
}
