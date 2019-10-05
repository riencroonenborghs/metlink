import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:metlink/widgets/widgets.dart";
import "package:metlink/services/services.dart";
import "package:metlink/blocs/blocs.dart";
import "package:metlink/pages/pages.dart";
import "package:metlink/models/models.dart";

class LocationPage extends StatefulWidget {
  final Stop stop;
  final StopDeparture stopDeparture;

  LocationPage({Key key, @required this.stop, @required this.stopDeparture}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with UtilsWidget {
  BuildContext buildContext;
  ServiceLocationBloc serviceLocationBloc = new ServiceLocationBloc();
  bool _ignore = false;

  _resolveAddress(ServiceLocation serviceLocation) {
    serviceLocation.getApproxAddress().then((_){
      setState((){ _ignore = !_ignore; });
    });
  }
 
  Widget _searchList(List<ServiceLocation> serviceLocations) {
    List<Widget> cards = new List<Widget>();
    serviceLocations.forEach((serviceLocation) {
      String title = "Vehicle ${serviceLocation.vehicleRef} going to ${serviceLocation.destinationStopName}";
      List<Widget> subtitles = new List<Widget>();
      if(serviceLocation.isBehind) {
        subtitles.add(
          leftAlign(
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey),
                Text("Delayed by ${(serviceLocation.delayInS / 60).ceil()} minutes.")
              ]
            )
          )
        );
      }
      if(serviceLocation.approxAddress != null && serviceLocation.approxAddress != null) {
        subtitles.add(
          leftAlign(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey),
                Expanded(
                  child: Text("Located somwehere around ${serviceLocation.approxAddress}.", softWrap: true)
                )
              ]
            )
          )
        );
      }
      _resolveAddress(serviceLocation);
      Card card = Card(
        child: ListTile(
          title: Text(title),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: subtitles
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              buildContext,
              MaterialPageRoute(
                builder: (context) => MapPage(serviceLocation: serviceLocation)
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
    return BlocBuilder<ServiceLocationEvent, ServiceLocationState>(
      bloc: serviceLocationBloc,
      builder: (_, ServiceLocationState serviceLocationState) {
        if(serviceLocationState is ServiceLocationInitialState) {
          return Container();
        }
        if(serviceLocationState is ServiceLocationSearchingState) {
          return waiting(buildContext, "Searching...");
        }
        if(serviceLocationState is ServiceLocationErrorState) {
          return errorMessage("Something went wrong :(");
        }
        if(serviceLocationState is ServiceLocationDoneState) {
          return _searchList(serviceLocationState.serviceLocations);
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    serviceLocationBloc = new ServiceLocationBloc();
    serviceLocationBloc.dispatch(ServiceLocationPerformEvent(code: widget.stopDeparture.code));
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Metlink: Is my bus going show up?")
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            leftAlignText("Stop ${widget.stop.name}"),
            leftAlignText("Service ${widget.stopDeparture.code} - ${widget.stopDeparture.name}"),
            leftAlignText("Vehicles that claim to be on the road:"),
            _searchResults()
          ]
        )
      )
    );
  }
}
