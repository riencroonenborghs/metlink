import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";

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

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    serviceLocationBloc = new ServiceLocationBloc();
    // serviceLocationBloc.dispatch(ServiceLocationPerformEvent(code: widget.code));

    return Scaffold(
      appBar: AppBar(
        title: Text("Service ${widget.code} - ${widget.name}")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            leftAlignText("Map"),
          ]
        )
      )
    );
  }
}
