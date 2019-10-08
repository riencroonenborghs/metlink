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

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with UtilsWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  
  
  BuildContext buildContext;
  
  int _selectedIndex = 0;
  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    TrackerPage(),
    RoutesPage(),
    TimetablesPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  Widget _render() {
    return Center(
      child: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;    

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(mainTitle)
      ),
      body: _render(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_searching),
            title: Text("Tracker"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text("Routes"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text("Timetables"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped
      )
    );
  }
}
