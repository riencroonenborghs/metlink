import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong/latlong.dart";
import "package:geolocator/geolocator.dart";

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

  StopSearchService stopSearchService = new StopSearchService();
  StopService stopService = new StopService();
  
  BuildContext buildContext;  
  Marker myLocationMarker;
  List<Marker> stopMarkers;

  // Timer timer;

  Marker _createStopMarker(Stop stop) {
    return Marker(
      width: 45.0,
      height: 45.0,
      point: LatLng(stop.lat, stop.long),
      builder: (ctx) => Container(
        child: GestureDetector(
          onTap: () {
          },
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor
          )
        )
      )
    );
  }

  Marker _createMyLocationMarker(LatLng latLng) {
    myLocationMarker = Marker(
      width: 45.0,
      height: 45.0,
      point: latLng,
      builder: (ctx) => Container(
        child: GestureDetector(
          onTap: () {
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

  _findAddress(LatLng latLng) async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark placemark = placemarks[0];
    if(placemark == null) return;

    stopMarkers = new List<Marker>();
    stopSearchService.search(placemark.thoroughfare).then((List<Stop> stops) {

      stops.asMap().forEach((index, Stop foundStop) {
        Timer(Duration(milliseconds: (index + 1) * 750), () {
          stopService.search(foundStop.code).then((Stop stop) {
            setState(() {
              stopMarkers.add(_createStopMarker(stop));
            });
          });
        });
      });
    });
  }

  Widget _showMap() {
    LatLng centerOn = myLocationMarker == null ? beehiveMarker.point : myLocationMarker.point;
    Marker marker = myLocationMarker == null ? beehiveMarker : myLocationMarker;
    List<Marker> allMarkers = new List<Marker>();
    allMarkers.addAll([marker]);
    if(stopMarkers != null) { allMarkers.addAll(stopMarkers); }

    return Flexible(
      child: FlutterMap(
        options: MapOptions(
          center: centerOn,
          zoom: 15.0,
          onTap: (LatLng latLng) {
            _createMyLocationMarker(latLng);
            _findAddress(latLng);

            setState(() { _findingMyLocation = false; });
          }
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ["a", "b", "c"]
          ),
          MarkerLayerOptions(markers: allMarkers)
        ]
      )
    );
  }

  Widget _showMyLocation() {
    if(myLocationMarker == null) {
      return centerWaiting(buildContext, "Locating where you are...");
    } else {
      return Stack(
        children: [
          Column(
            children: [        
              _showMap()
            ]
          ),
          IconButton(
            icon: Icon(Icons.location_searching),
            onPressed: () {
              _findMyLocation();
            }
          )
        ]
      );
    }
  }

  // @override
  // void dispose() {
  //   if(timer != null ) { timer.cancel(); }
  //   super.dispose();
  // }

  bool _findingMyLocation = false;
  _findMyLocation() {
    Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
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

      LatLng latLng = LatLng(position.latitude, position.longitude);
      _createMyLocationMarker(latLng);
      _findAddress(latLng);

      setState(() { _findingMyLocation = false; });
    }); 
  }

  @override
  void initState() {
    super.initState();
    _findMyLocation();
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
        title: Text("Metlink Bus Tracker")
      ),
      body: _showMyLocation()
    );
  }
}
