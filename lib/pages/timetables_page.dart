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

class TimetablesPage extends StatefulWidget {
  TimetablesPage({Key key}) : super(key: key);

  @override
  _TimetablesPageState createState() => _TimetablesPageState();
}

class _TimetablesPageState extends State<TimetablesPage> with UtilsWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String mainTitle = "Timetables";
  
  BuildContext buildContext;  

  Widget _render() {
    return Text("qwe");
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;    

    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text(mainTitle)
      // ),
      body: _render(),
      // drawer: Drawer(
      //   child: drawer(context, mainTitle)
      // )
    );
  }
}
