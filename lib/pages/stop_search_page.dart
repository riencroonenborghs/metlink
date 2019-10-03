import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";

class StopSearchPage extends StatefulWidget {
  StopSearchPage({Key key}) : super(key: key);

  @override
  _StopSearchPageState createState() => _StopSearchPageState();
}

class _StopSearchPageState extends State<StopSearchPage> with UtilsWidget {
  BuildContext buildContext;
  StopSearchBloc searchBloc = new StopSearchBloc();

  Widget _searchList(List result) {
    List<Widget> cards = new List<Widget>();
    result.forEach((item) {
      Card card = Card(
        child: ListTile(
          title: Text(item["Name"]),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              buildContext,
              MaterialPageRoute(
                builder: (context) => StopPage(stop: item["Sms"])
              )
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
    return BlocBuilder<StopSearchEvent, StopSearchState>(
      bloc: searchBloc,
      builder: (_, StopSearchState searchState) {
        if(searchState is StopSearchInitialState) {
          return Container();
        }
        if(searchState is StopSearchStopSearchingState) {
          return waiting(buildContext, "Searching...");
        }
        if(searchState is StopSearchErrorState) {
          return errorMessage("Something went wrong :(");
        }
        if(searchState is StopSearchDoneState) {
          if(searchState.result.length == 0) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: leftAlignText("Nothing found")
            );
          } else {
            return _searchList(searchState.result);
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stop Search")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Street name, stop number or station"
              ),
              onSubmitted: (String query) {
                searchBloc.dispatch(StopSearchPerformEvent(query: query));
              }
            ),
            _searchResults()
          ]
        )
      )
    );
  }
}
