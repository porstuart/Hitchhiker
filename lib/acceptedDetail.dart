import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/acceptedTripPage.dart';
import 'package:hitchhiker/trip.dart';
import 'package:hitchhiker/passenger.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class AcceptedDetail extends StatefulWidget {
  final Passenger passenger;
  final Trip trip;

  const AcceptedDetail({Key key, this.trip, this.passenger}) : super(key: key);

  @override
  _AcceptedDetailState createState() => _AcceptedDetailState();
}

class _AcceptedDetailState extends State<AcceptedDetail> {
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
                passenger: widget.passenger,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => AcceptedTripPage(
            passenger: widget.passenger,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Passenger passenger;
  final Trip trip;
  DetailInterface({this.passenger, this.trip});

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

  Future<String> acceptRequest() async {
    String urlLoadJobs = "http://pickupandlaundry.com/hitchhiker/php/acceptTrip.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Trip");
    pr.show();
    http.post(urlLoadJobs, body: {
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
    String urlgetuser = "http://pickupandlaundry.com/hitchhiker/php/getUser.php";

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
                builder: (context) => AcceptedTripPage(passenger: passenger)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}