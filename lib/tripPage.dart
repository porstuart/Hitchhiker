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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "No available trip yet.",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins-Medium",
                    fontSize: 25),
              )
            ],
          )
        ],
      ),
    );
  }
}
