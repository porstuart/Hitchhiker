import 'package:flutter/material.dart';
import 'package:hitchhiker/passenger.dart';

class TripPage extends StatefulWidget {
  final Passenger passenger;

  TripPage({Key key, this.passenger}) : super(key: key);

  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Row(children: <Widget>[Text("There")],),
    );
  }
}
