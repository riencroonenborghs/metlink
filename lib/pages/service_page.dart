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
  // StopDeparturesBloc stopDeparturesBloc = new StopDeparturesBloc();

  // Widget _searchList(List result) {
  //   List<Widget> cards = new List<Widget>();

  //   Map<String, String> services = new Map<String, String>();
  //   result.forEach((item) {
  //     dynamic service = item["Service"];
  //     String code = service["Code"];
  //     String name = service["Name"];
  //     if(!services.keys.contains(code)) {
  //       services[code] = name;
  //     }
  //   });

  //   services.entries.forEach((service) {
  //     Card card = Card(
  //       child: ListTile(
  //         title: Text("${service.key} - ${service.value}"),
  //         trailing: Icon(Icons.chevron_right),
  //         onTap: () {
  //           Navigator.push(
  //             buildContext,
  //             MaterialPageRoute(builder: (BuildContext buildContext) => ServicePage(service: service.key))
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

  // Widget _searchResults() {
  //   return BlocBuilder<StopDeparturesEvent, StopDeparturesState>(
  //     bloc: stopDeparturesBloc,
  //     builder: (_, StopDeparturesState serviceLocationState) {
  //       if(serviceLocationState is StopDeparturesInitialState) {
  //         return Container();
  //       }
  //       if(serviceLocationState is StopDeparturesSearchingState) {
  //         return waiting(buildContext, "Searching...");
  //       }
  //       if(serviceLocationState is StopDeparturesErrorState) {
  //         return errorMessage("Something went wrong :(");
  //       }
  //       if(serviceLocationState is StopDeparturesDoneState) {
  //         if(serviceLocationState.result == null) {
  //           return Padding(
  //             padding: EdgeInsets.only(top: 8.0),
  //             child: leftAlignText("Nothing found")
  //           );
  //         } else {
  //           return _searchList(serviceLocationState.result["Services"]);
  //         }
  //       }
  //     }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    // stopDeparturesBloc = new StopDeparturesBloc();
    // stopDeparturesBloc.dispatch(StopDeparturesPerformEvent(stop: widget.stop));

    return Scaffold(
      appBar: AppBar(
        title: Text("Service ${widget.code} - ${widget.name}")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            leftAlignText("Timetable"),
            leftAlignText("Map")
          ]
        )
      )
    );
  }
}
