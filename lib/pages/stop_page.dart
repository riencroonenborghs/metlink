import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";
import "package:metlink/models/models.dart";

class StopPage extends StatefulWidget {
  final Stop stop;

  StopPage({Key key, @required this.stop}) : super(key: key);

  @override
  _StopPageState createState() => _StopPageState();
}

class _StopPageState extends State<StopPage> with UtilsWidget {
  BuildContext buildContext;
  StopDeparturesBloc stopDeparturesBloc = new StopDeparturesBloc();

  Widget _searchList(List<StopDeparture> stopDepartures) {
    List<Widget> cards = new List<Widget>();

    Map<String, StopDeparture> services = new Map<String, StopDeparture>();
    stopDepartures.forEach((stopDeparture) {
      if(!services.keys.contains(stopDeparture.code)) {
        services[stopDeparture.code] = stopDeparture;
      }
    });

    services.entries.forEach((entry) {
      String code = entry.key;
      StopDeparture stopDeparture = entry.value;
      Card card = Card(
        child: ListTile(
          title: Text("${stopDeparture.code} - ${stopDeparture.name}"),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (BuildContext buildContext) => LocationPage(stopDeparture: stopDeparture))
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
    return BlocBuilder<StopDeparturesEvent, StopDeparturesState>(
      bloc: stopDeparturesBloc,
      builder: (_, StopDeparturesState stopDeparturesState) {
        if(stopDeparturesState is StopDeparturesInitialState) {
          return Container();
        }
        if(stopDeparturesState is StopDeparturesSearchingState) {
          return waiting(buildContext, "Searching...");
        }
        if(stopDeparturesState is StopDeparturesErrorState) {
          return errorMessage("Something went wrong :(");
        }
        if(stopDeparturesState is StopDeparturesDoneState) {
          if(stopDeparturesState.stopDepartures.length == 0) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: leftAlignText("Nothing found")
            );
          } else {
            return _searchList(stopDeparturesState.stopDepartures);
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    stopDeparturesBloc = new StopDeparturesBloc();
    stopDeparturesBloc.dispatch(StopDeparturesPerformEvent(stop: widget.stop));

    return Scaffold(
      appBar: AppBar(
        title: Text("Stop ${widget.stop.code}")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            leftAlignText(widget.stop.name),
            leftAlignText("Services for this stop:"),
            _searchResults()
          ]
        )
      )
    );
  }
}
