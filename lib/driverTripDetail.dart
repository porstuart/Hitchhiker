import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/driver.dart';
import 'package:hitchhiker/driverMainPage.dart';
import 'package:hitchhiker/trip.dart';

class DriverTripDetail extends StatefulWidget {
  final Driver driver;
  final Trip trip;

  const DriverTripDetail({Key key, this.driver, this.trip}) : super(key: key);

  @override
  _DriverTripDetailState createState() => _DriverTripDetailState();
}

class _DriverTripDetailState extends State<DriverTripDetail> {
  Driver driver;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('TRIP DETAILS'),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                trip: widget.trip,
                driver: widget.driver,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => DriverMainPage(
            driver: widget.driver,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Driver driver;
  final Trip trip;
  DetailInterface({this.driver, this.trip});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network('assets/images/trip.jpg', fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.trip.destination.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Origin", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.trip.origin),
                ]),
                TableRow(children: [
                  Text("Depature Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.trip.depatureDate),
                ]),
                TableRow(children: [
                  Text("Depature Time",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.trip.depatureTime)
                ]),
                TableRow(children: [
                  Text("Estimated Arrival Time",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.trip.arrivalTime)
                ]),
                TableRow(children: [
                  Text("Travelling Preferences",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.trip.travellingPreferences)
                ]),
                TableRow(children: [
                  Text("Rewards",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.trip.rewards)
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
