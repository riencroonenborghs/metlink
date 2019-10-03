import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";

class BusSearchPage extends StatefulWidget {
  BusSearchPage({Key key}) : super(key: key);

  @override
  _StopSearchPageState createState() => _StopSearchPageState();
}

class _StopSearchPageState extends State<BusSearchPage> with UtilsWidget {
  BuildContext buildContext;
  StopSearchBloc searchBloc;

  Widget _searchResults() {
    return BlocBuilder<StopSearchEvent, StopSearchState>(
      bloc: searchBloc,
      builder: (_, StopSearchState searchState) {
        if(searchState is StopSearchInitialState) {
          return Container();
        }
        if(searchState is StopSearchStopSearchingState) {
          return waiting(buildContext, "StopSearching...");
        }
        if(searchState is StopSearchErrorState) {
          return errorMessage("Something went wrong :(");
        }
        if(searchState is StopSearchDoneState) {
          List<Widget> cards = new List<Widget>();
          searchState.result.forEach((item) {
            Card card = Card(
              child: ListTile(
                title: Text(item["Name"]),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/measurements/new"
                  ); 
                }
              ),
            );
            cards.add(card);
          });
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              children: cards
            )
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    searchBloc = new StopSearchBloc();

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          leftAlignText("Bus Search"),
          TextField(
            decoration: InputDecoration(
              labelText: "Bus number"
            ),
            onSubmitted: (String query) {
              searchBloc.dispatch(StopSearchPerformEvent(query: query));
            }
          ),
          _searchResults()
        ]
      )
    );
  }
}
