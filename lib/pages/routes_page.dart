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
  MapController mapController;
  
  BuildContext buildContext;

  Widget _showMap() {
    LatLng centerOn = beehiveMarker.point;
    Marker marker = beehiveMarker;

    return Flexible(
      child: FlutterMap(
        mapController: mapController,
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
          // PolylineLayerOptions(
          //   polylines: _showServiceMap && _selectedServiceMap != null ?
          //     _selectedServiceMap.generatePolylines(routeColor) :
          //     []
          // ),
          // MarkerLayerOptions(markers: allMarkers)
        ]
      )
    );
  }

  Widget _render() {
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

    return Stack(
      children: stackChildren
    );
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
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
