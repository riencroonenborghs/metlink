import "package:flutter/material.dart";
import "package:metlink/pages/pages.dart";

class UtilsWidget {
  Widget waiting(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          CircularProgressIndicator(
            value: null,
            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(label, style: TextStyle(fontSize: 8.0))
          )        
        ]
      )
    );
  }

  Widget centerWaiting(BuildContext context, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            waiting(context, text)
          ]
        )
      ]
    );
  }

  Widget errorMessage(String message) {
    return Text(
      message,
      style: TextStyle(color: Colors.red)
    );
  }

  Widget leftAlignText(String text, {TextStyle style = TextStyle()}) {
    return leftAlign(Text(text, style: style));
  }
  // Widget leftAlignTextSmall(String text, {TextStyle style = TextStyle()}) {
  //   style = style.merge(TextStyle(fontSize: smallerFont));
  //   return leftAlign(Text(text, style: style));
  // }

  // Widget SmallText(String text, {TextStyle style = TextStyle()}) {
  //   style = style.merge(TextStyle(fontSize: smallerFont));
  //   return Text(
  //     text,
  //     style: style
  //   );
  // }


  Widget leftAlign(Widget child) {
    return Align(
      alignment: Alignment.centerLeft,
      child: child
    );
  }

  Divider blueDivider() {
    return  Divider();
  }

  // String formatDate(DateTime date, {bool short = false}) {
  //   String fmt = short ? "d MMM y" : "EEEE, d MMMM y";
  //   return new DateFormat(fmt).format(date);
  // }

  Widget fancyTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          leftAlignText(title),
          blueDivider()
        ]
      )
    );
  }

  // showSuccessMessage(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  //   scaffoldKey.currentState.showSnackBar(SuccessSnackBar(message));
  // }
  // showErrorMessage(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  //   scaffoldKey.currentState.showSnackBar(ErrorSnackBar(message));
  // }

  // Widget drawer(BuildContext context, String title) {
  //   return ListView(
  //     padding: EdgeInsets.zero,
  //     children: [
  //       DrawerHeader(
  //         child: Center(child: Text(title, style: TextStyle(fontSize: 24, color: Colors.white))),
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColor
  //         ),
  //       ),
  //       ListTile(
  //         title: Text("Find a route"),
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => FindRoutePage()),
  //           );
  //         }
  //       ),
  //       ListTile(
  //         title: Text("Timetables"),
  //         onTap: () {
  //         }
  //       )
  //     ]
  //   );
  // }
}