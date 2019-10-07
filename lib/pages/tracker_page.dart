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

class TrackerPage extends StatefulWidget {
  TrackerPage({Key key}) : super(key: key);

  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> with UtilsWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static double DEFAULT_ZOOM = 15.0;
  static num TRACK_UPDATE_DELAY = 2;
  MapController mapController;

  StopSearchService stopSearchService = new StopSearchService();
  StopService stopService = new StopService();
  StopDeparturesService stopDeparturesService = new StopDeparturesService();
  StopsNearbyService stopsNearbyService = new StopsNearbyService();
  ServiceLocationService serviceLocationService = new ServiceLocationService();
  ServiceMapService serviceMapService = new ServiceMapService();
  
  BuildContext buildContext;  
  Marker _myLocationMarker;
  Marker _trackedBusMarker;
  PersistentBottomSheetController _stopInfoBottomSheet;
  PersistentBottomSheetController _busInfoBottomSheet;
  ServiceMap _selectedServiceMap;

  List<Marker> _stopMarkers;
  List<StopDeparture> _stopDepartures;
  bool _fakeRebuild = false;
  bool _moveMap = false;
  bool _showServiceMap = false;
  Stop _clickedStop;
  Timer _timer;

  // --------------------
  // Find things
  // --------------------

  _findStopsNearby(LatLng latLng) async {
    _stopMarkers = new List<Marker>();
    stopsNearbyService.search(latLng).then((List<Stop> foundStops) {
      foundStops.forEach((Stop stop) {
        _stopMarkers.add(_createStopMarker(stop));
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
      if(mapController != null) { 
        mapController.move(
          latLng,
          DEFAULT_ZOOM
        );
      }
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
              _stopDepartures = foundStopDepartures;
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
    _myLocationMarker = Marker(
      width: 45.0,
      height: 45.0,
      point: latLng,
      builder: (ctx) => Container(
        child: Icon(Icons.location_on)
      )
    );
  }

  Marker _createBusMarker(ServiceLocation serviceLocation) {
    _trackedBusMarker = Marker(
      width: 45.0,
      height: 45.0,
      point: LatLng(serviceLocation.lat, serviceLocation.long),
      builder: (ctx) => Container(
        child: GestureDetector(
          onTap: () {
            _showBusInfoBottomSheet(serviceLocation);
          },
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

  _showBusInfoBottomSheet(ServiceLocation serviceLocation) {
    _busInfoBottomSheet = _scaffoldKey.currentState.showBottomSheet((context) => Container(
      color: Colors.white,
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _bottomSheetTitle("Vehicle ${serviceLocation.vehicleRef}"),
                  leftAlignText("${serviceLocation.code} - ${serviceLocation.name}"),
                  leftAlignText(serviceLocation.isBehind ? "Delayed by ${serviceLocation.delayInM} minutes." : "On Time.")
                ]
              )
            )
          )
        ]
      )
    ));
  }

  Widget _showMap() {
    LatLng centerOn = _myLocationMarker == null ? beehiveMarker.point : _myLocationMarker.point;
    Marker marker = _myLocationMarker == null ? beehiveMarker : _myLocationMarker;
    List<Marker> allMarkers = new List<Marker>();
    allMarkers.addAll([marker]);
    if(_stopMarkers != null) { allMarkers.addAll(_stopMarkers); }
    if(_trackedBusMarker != null)  { allMarkers.add(_trackedBusMarker); }

    return Flexible(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: centerOn,
          zoom: DEFAULT_ZOOM,
          onTap: (LatLng latLng) {
            _closeBottomSheets();
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
          PolylineLayerOptions(
            polylines: _showServiceMap && _selectedServiceMap != null ?
              _selectedServiceMap.generatePolylines(routeColor) :
              []
          ),
          MarkerLayerOptions(markers: allMarkers)
        ]
      )
    );
  }

  _trackBus(StopDeparture stopDeparture) {
    _loadTrackedBus(stopDeparture);
    _timer = Timer.periodic(Duration(seconds: TRACK_UPDATE_DELAY), (timer) {
      _loadTrackedBus(stopDeparture);
    });
  }

  _resetTrackedBus() {
    _trackedBusMarker = null;
    if(_timer != null) _timer.cancel();
  }

  _resetMyLocation() {
    _myLocationMarker = null;
  }

  _resetNearbyStops() {
    _stopMarkers = null;
  }

  _resetServiceMap() {
    _showServiceMap = false;
    _selectedServiceMap = null;
  }

  _closeBottomSheets() {
    if(_stopInfoBottomSheet != null) { 
      _stopInfoBottomSheet.close();
      _stopInfoBottomSheet = null;
    }
    if(_busInfoBottomSheet != null) {
      _busInfoBottomSheet.close();
      _busInfoBottomSheet = null;
    }
  }

  Widget _bottomSheetTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(title)
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            _closeBottomSheets();
          }
        )
      ]
    );
  }

  _loadTrackedBus(StopDeparture stopDeparture) {
    serviceLocationService.forStopDeparture(stopDeparture).then((ServiceLocation serviceLocation) {
      if(serviceLocation == null) {
        _resetTrackedBus();
        _findStopsNearby(_myLocationMarker.point);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: errorMessage("Cound not find your bus on the road.")
          )
        );
        return;
      }
      setState(() {
        print("_loadTrackedBus ${DateTime.now()}: ${serviceLocation.lat}/${serviceLocation.long}");
        _createBusMarker(serviceLocation);
        if(_moveMap) {
          mapController.move(
            _trackedBusMarker.point,
            DEFAULT_ZOOM
          );
          _moveMap = false;
        }
      });
    });
  }

  Widget _stopInfo() {
    Row title = _bottomSheetTitle("Stop ${_clickedStop.code} - ${_clickedStop.name}");

    List<Widget> departures = new List<Widget>();
    _stopDepartures.forEach((stopDeparture) {
      String subtitle = "Due: ${DateFormat.jm().format(stopDeparture.aimedArrival)}";
      if(stopDeparture.departureStatus != null) {
        if(stopDeparture.departureStatus == "delayed") { subtitle += " Delayed."; }
      }

      ListTile tile = ListTile(
        title: Text("${stopDeparture.code} - ${stopDeparture.name}"),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
        onTap: () {
          _closeBottomSheets();
          _moveMap = true;       
          _trackBus(stopDeparture);
          serviceMapService.search(stopDeparture.code).then((ServiceMap foundServiceMap) {
            _selectedServiceMap = foundServiceMap;
            _showServiceMap = true;
          });
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
    if(_myLocationMarker == null) {
      return centerWaiting(buildContext, "Locating where you are ...");
    } else {
      List<Widget> stackChildren = new List<Widget>();
      stackChildren.add(
        Column(
          children: [        
            _showMap()
          ]
        )
      );

      List<Widget> iconChildren = new List<Widget>();
      stackChildren.add(Row(children: iconChildren));

      iconChildren.add(
        IconButton(
          icon: Icon(Icons.location_searching),
          onPressed: () {
            _findMyLocation();
          }
        )
      );
      if(_trackedBusMarker != null) {
        iconChildren.add(
          IconButton(
            icon: Icon(Icons.location_off, color: Theme.of(context).primaryColor),
            onPressed: () {
              _resetTrackedBus();
              _findStopsNearby(_myLocationMarker.point);
              _resetServiceMap();
              setState(() { _fakeRebuild = true; });
            }
          )
        );
        iconChildren.add(
          IconButton(
            icon: Icon(Icons.remove_red_eye, color: _showServiceMap ? routeColor : Colors.black),
            onPressed: () {
              setState(() { _showServiceMap = !_showServiceMap; });
            }
          )
        );
      }

      return Stack(
        children: stackChildren
      );
    }
  }

  @override
  void dispose() {
    if(_timer != null ) { _timer.cancel(); }
    super.dispose();

  }
  
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _findMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;    

    return Scaffold(
      key: _scaffoldKey,
      body: _render()
    );
  }
}
