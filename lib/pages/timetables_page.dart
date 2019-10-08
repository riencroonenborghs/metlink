import "dart:async";
import "dart:io";
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

import "package:metlink/constants.dart";
import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";
import "package:metlink/models/models.dart";

class TimetablesPage extends StatefulWidget {
  TimetablesPage({Key key}) : super(key: key);

  @override
  _TimetablesPageState createState() => _TimetablesPageState();
}

class _TimetablesPageState extends State<TimetablesPage> with UtilsWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AssetDataService _assetDataService = new AssetDataService();
  bool _loadingMetlinkRoutes = true;
  List<MetlinkRoute> _allMetlinkRoutes;
  MetlinkRoute _selectedMetlinkRoute = null;  
  BuildContext buildContext;

  Widget _metlinkRoutesDropDown() {
    return DropdownButton<MetlinkRoute>(
      isExpanded: true,
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

    List<Widget> children = new List<Widget>();
    children.add(
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: _metlinkRoutesDropDown()
        )
      )
    );
    if(_selectedMetlinkRoute != null) {
      children.add(
        Flexible(
          child: WebView(
            key: UniqueKey(),
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "${busTimetablesUrl}/${_selectedMetlinkRoute.shortName}"
          )
        )
      );  
    }

    return Column(
      children: children
    );
  }

  @override
  void initState() {
    super.initState();
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
