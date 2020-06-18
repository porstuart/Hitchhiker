import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/trip.dart';
import 'package:hitchhiker/driver.dart';
import 'package:hitchhiker/passenger.dart';
import 'package:hitchhiker/passengerMainPage.dart';
import 'package:hitchhiker/passengerTripPage.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class PassengerTripDetail extends StatefulWidget {
  final Passenger passenger;
  final Driver driver;
  final Trip trip;

  const PassengerTripDetail({Key key, this.passenger, this.trip, this.driver})
      : super(key: key);

  @override
  _PassengerTripDetailState createState() => _PassengerTripDetailState();
}

class _PassengerTripDetailState extends State<PassengerTripDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.indigo[400]));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('TRIP DETAILS'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(146, 143, 206, 1),
                  Color.fromRGBO(170, 177, 229, 1)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(170, 177, 229, 1),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                  trip: widget.trip,
                  passenger: widget.passenger,
                  driver: widget.driver),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => PassengerTripPage(
            passenger: widget.passenger,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Passenger passenger;
  final Trip trip;
  final Driver driver;
  DetailInterface({this.passenger, this.trip, this.driver});

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
                TableRow(children: [
                  Text("Driver", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    widget.trip.driverEmail,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xFF5D74E3),
                        fontFamily: "Poppins-Bold"),
                  ),
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(146, 143, 206, 1),
                    Color.fromRGBO(170, 177, 229, 1)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(170, 177, 229, 1),
                        blurRadius: 12,
                        offset: Offset(0, 6))
                  ],
                ),
                child: MaterialButton(
                  child: Text(
                    'ACCEPT TRIP',
                    style: TextStyle(fontSize: 16),
                  ),
                  textColor: Colors.black,
                  elevation: 5,
                  onPressed: _onAcceptedTrip,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptedTrip() {
    if (widget.passenger.email == "user@noregister") {
      Toast.show("Please register to view accept trips", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      _showDialog();
    }
    print("Accept Job");
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Accept " + widget.trip.destination + " trip?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> acceptRequest() async {
    String urlAcceptJob =
        "http://pickupandlaundry.com/hitchhiker/php/acceptTrip.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Trip");
    pr.show();
    http.post(urlAcceptJob, body: {
      "tripID": widget.trip.tripID,
      "email": widget.passenger.email,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
        _onLogin(widget.passenger.email, context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  void _onLogin(String email, BuildContext ctx) {
    String urlgetuser =
        "http://pickupandlaundry.com/hitchhiker/php/getUser.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Passenger passenger = new Passenger(
            email: dres[1],
            fName: dres[2],
            lName: dres[3],
            matric: dres[4],
            phoneNum: dres[5],
            emergeNum: dres[6],
            residentialHall: dres[7]);
        Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (context) => PassengerMainPage(passenger: passenger)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
