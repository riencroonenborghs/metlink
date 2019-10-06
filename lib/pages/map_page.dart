import "dart:async";
import "dart:io";
import "package:intl/intl.dart";
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
  StopDeparturesService stopDeparturesService = new StopDeparturesService();
  StopsNearbyService stopsNearbyService = new StopsNearbyService();
  ServiceLocationService serviceLocationService = new ServiceLocationService();
  
  BuildContext buildContext;  
  Marker myLocationMarker;
  Marker trackedBusMarker;
  PersistentBottomSheetController _stopInfoBottomSheet;

  List<Marker> stopMarkers;
  List<StopDeparture> stopDepartures;
  bool _fakeRebuild = false;
  Stop _clickedStop;
  Timer timer;

  // --------------------
  // Find things
  // --------------------

  _findStopsNearby(LatLng latLng) async {
    stopMarkers = new List<Marker>();
    stopsNearbyService.search(latLng).then((List<Stop> foundStops) {
      foundStops.forEach((Stop stop) {
        stopMarkers.add(_createStopMarker(stop));
      });
      setState(() { _fakeRebuild = true; });
    });
  }
   
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
      _findStopsNearby(latLng);
    }); 
  }

  // --------------------
  // Create widgets
  // --------------------

  Marker _createStopMarker(Stop stop) {
    return Marker(
      width: 45.0,
      height: 45.0,
      point: LatLng(stop.lat, stop.long),
      builder: (ctx) => Container(
        child: GestureDetector(
          onTap: () {
            _clickedStop = stop;
            stopDeparturesService.search(stop).then((List<StopDeparture> foundStopDepartures) {
              stopDepartures = foundStopDepartures;
              // foundStopDepartures.forEach((stopDeparture) {
              //   if(!stopDepartures.keys.contains(stopDeparture.code)) {
              //     stopDepartures[stopDeparture.code] = stopDeparture;
              //   }
              // });
              _stopInfo();
            });
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
        )
      )
    );
  }

  Marker _createBusMarker(ServiceLocation serviceLocation) {
    trackedBusMarker = Marker(
      width: 45.0,
      height: 45.0,
      point: LatLng(serviceLocation.lat, serviceLocation.long),
      builder: (ctx) => Container(
        child: GestureDetector(
          child: Container(
            child: Transform.rotate(
              angle: serviceLocation.bearingRadians,
              child: serviceLocation.bearing < 180 ? 
                Image.asset("assets/images/bus-primary-going-east.png") :
                Image.asset("assets/images/bus-primary-going-west.png")
            )
          )
        )
      )
    );
  }

  Widget _showMap() {
    LatLng centerOn = myLocationMarker == null ? beehiveMarker.point : myLocationMarker.point;
    Marker marker = myLocationMarker == null ? beehiveMarker : myLocationMarker;
    List<Marker> allMarkers = new List<Marker>();
    allMarkers.addAll([marker]);
    if(stopMarkers != null) { allMarkers.addAll(stopMarkers); }
    if(trackedBusMarker != null)  { allMarkers.add(trackedBusMarker); }

    return Flexible(
      child: FlutterMap(
        options: MapOptions(
          center: centerOn,
          zoom: 15.0,
          onTap: (LatLng latLng) {
            if(_stopInfoBottomSheet != null) { _stopInfoBottomSheet.close(); }
          },
          onLongPress: (LatLng latLng) {
            _createMyLocationMarker(latLng);
            _findStopsNearby(latLng);
            _resetTrackedBus();
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

  _trackBus(StopDeparture stopDeparture) {
    _loadTrackedBus(stopDeparture);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _loadTrackedBus(stopDeparture);
    });
  }

  _resetTrackedBus() {
    trackedBusMarker = null;
    if(timer != null) timer.cancel();
  }

  _resetMyLocation() {
    myLocationMarker = null;
  }

  _resetNearbyStops() {
    stopMarkers = null;
  }

  _loadTrackedBus(StopDeparture stopDeparture) {
    serviceLocationService.forStopDeparture(stopDeparture).then((ServiceLocation serviceLocation) {
      if(serviceLocation == null) return;
      setState(() {
        _createBusMarker(serviceLocation);
      });
    });
  }

  Widget _stopInfo() {
    Row title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text("Stop ${_clickedStop.code} - ${_clickedStop.name}")
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            _stopInfoBottomSheet.close();
          }
        )
      ]
    );

    List<Widget> departures = new List<Widget>();
    stopDepartures.forEach((stopDeparture) {
      List<Widget> subtitles = new List<Widget>();
      if(stopDeparture.departureStatus != null) { subtitles.add(leftAlignText(stopDeparture.departureStatus)); }
      subtitles.add(leftAlignText("Due: ${DateFormat.jm().format(stopDeparture.aimedArrival)}"));

      ListTile tile = ListTile(
        title: Text("${stopDeparture.code} - ${stopDeparture.name}"),
        subtitle: Column(children: subtitles),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          if(_stopInfoBottomSheet != null) { _stopInfoBottomSheet.close(); }
          _trackBus(stopDeparture);
          setState(() {
            _resetNearbyStops();
          });
        }
      );
      departures.add(tile);
    });

    _stopInfoBottomSheet = _scaffoldKey.currentState.showBottomSheet((context) => Container(
      color: Colors.white,
      height: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  title,
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: departures
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    ));
  }

  Widget _render() {
    if(myLocationMarker == null) {
      return centerWaiting(buildContext, "Locating where you are...");
    } else {
      List<Widget> children = new List<Widget>();
      children.add(
        Column(
          children: [        
            _showMap()
          ]
        )
      );
      children.add(
        IconButton(
          icon: Icon(Icons.location_searching),
          onPressed: () {
            _findMyLocation();
          }
        )
      );

      return Stack(
        children: children
      );
    }
  }

  @override
  void dispose() {
    if(timer != null ) { timer.cancel(); }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _findMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;    

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Metlink Bus Tracker")
      ),
      body: _render()
    );
  }
}
