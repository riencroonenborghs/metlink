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

class RoutesPage extends StatefulWidget {
  RoutesPage({Key key}) : super(key: key);

  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> with UtilsWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static double DEFAULT_ZOOM = 12.0;
  MapController _mapController;
  AssetDataService _assetDataService = new AssetDataService();
  ServiceMapService serviceMapService = new ServiceMapService();
  List<MetlinkRoute> _allMetlinkRoutes;
  MetlinkRoute _selectedMetlinkRoute = null;
  bool _loadingMetlinkRoutes = true;
  ServiceMap _selectedServiceMap;
  
  BuildContext buildContext;

  Widget _showMap() {
    LatLng centerOn = beehiveMarker.point;
    Marker marker = beehiveMarker;

    return Flexible(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: centerOn,
          zoom: DEFAULT_ZOOM,
          onTap: (LatLng latLng) {
          },
          onLongPress: (LatLng latLng) {
          }
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ["a", "b", "c"]
          ),
          PolylineLayerOptions(
            polylines: _selectedServiceMap != null ?
              _selectedServiceMap.generatePolylines(routeColor) :
              []
          ),
          // MarkerLayerOptions(markers: allMarkers)
        ]
      )
    );
  }

  Widget _metlinkRoutesDropDown() {
    return DropdownButton<MetlinkRoute>(
      isExpanded: true,
      hint: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Select a route")
      ),
      value: _selectedMetlinkRoute,
      icon: Icon(Icons.keyboard_arrow_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
        color: Theme.of(context).primaryColor
      ),
      underline: Container(
        height: 0
      ),
      onChanged: (MetlinkRoute newMetlinkRoute) {
        serviceMapService.search(newMetlinkRoute.shortName).then((ServiceMap foundServiceMap) {
          setState(() {
            _selectedServiceMap = foundServiceMap;
            _mapController.move(
              _selectedServiceMap.paths[0][0],
              DEFAULT_ZOOM
            );
          });
        });

        setState(() {
          _selectedMetlinkRoute = newMetlinkRoute;
        });
      },
      items: _allMetlinkRoutes
        .map<DropdownMenuItem<MetlinkRoute>>((MetlinkRoute value) {
          return DropdownMenuItem<MetlinkRoute>(
            value: value,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("${value.shortName} - ${value.longName} (${value.agencyId})")
            )
          );
        })
        .toList()
    );
  }

  Widget _render() {
    if(_loadingMetlinkRoutes) {
      return centerWaiting(buildContext, "Loading routes ...");
    }

    List<Widget> stackChildren = new List<Widget>();
    stackChildren.add(
      Column(
        children: [        
          _showMap()
        ]
      )
    );

    stackChildren.add(
      Column(
        children: [        
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              child: _metlinkRoutesDropDown()
            )
          )
        ]
      )
    );

    return Stack(
      children: stackChildren
    );
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _assetDataService.loadMetlinkRoutes().then((_) {
      _allMetlinkRoutes = _assetDataService.metlinkRoutes;
      setState(() { _loadingMetlinkRoutes = false; });
    });
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
