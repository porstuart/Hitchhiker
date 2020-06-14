import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hitchhiker/trip.dart';
import 'package:hitchhiker/driver.dart';
import 'package:hitchhiker/slideRightRoute.dart';
import 'package:hitchhiker/driverTripDetail.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

double perpage = 1;

class DriverHistoryPage extends StatefulWidget {
  final Driver driver;

  DriverHistoryPage({Key key, this.driver});

  @override
  _DriverHistoryPageState createState() => _DriverHistoryPageState();
}

class _DriverHistoryPageState extends State<DriverHistoryPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: RefreshIndicator(
              key: refreshKey,
              color: Colors.black,
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                itemCount: data == null ? 1 : data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text("Hitchhiker",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: 300,
                                  height: 140,
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.person,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  widget.driver.fName
                                                              .toUpperCase() +
                                                          " " +
                                                          widget.driver.lName
                                                              .toUpperCase() ??
                                                      "Not registered",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.phone_android,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                    widget.driver.phoneNum),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.card_membership,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child:
                                                    Text(widget.driver.matric),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            color: Colors.blue,
                            child: Center(
                              child: Text("Trip History",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (index == data.length && perpage > 1) {
                    return Container(
                      width: 250,
                      color: Colors.white,
                      child: MaterialButton(
                        child: Text(
                          "Load More",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                      ),
                    );
                  }
                  index -= 1;
                  DateTime tempDate = new DateFormat("yyyy-MM-dd")
                      .parse(data[index]['depatureDate']);

                  if (tempDate.isBefore(new DateTime.now())) {
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _onTripDetail(
                            data[index]['tripID'],
                            data[index]['origin'],
                            data[index]['destination'],
                            data[index]['pickupPoint'],
                            data[index]['depatureDate'],
                            data[index]['depatureTime'],
                            data[index]['arrivalTime'],
                            data[index]['travellingPreferences'],
                            data[index]['rewards'],
                            widget.driver.fName,
                            widget.driver.lName,
                          ),
                          onLongPress: () => _onJobDelete(
                              data[index]['tripID'].toString(),
                              data[index]['destination'].toString()),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/trip.jpg")))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['destination']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['origin']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['depatureDate']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['depatureTime']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            )));
  }

  Future<String> makeRequest() async {
    String urlLoadTrip =
        "http://pickupandlaundry.com/hitchhiker/php/loadPostedTrip.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Trip");
    pr.show();
    http.post(urlLoadTrip, body: {
      "email": widget.driver.email ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["trips"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onTripDetail(
      String tripID,
      String origin,
      String destination,
      String pickupPoint,
      String depatureDate,
      String depatureTime,
      String arrivalTime,
      String travellingPreferences,
      String rewards,
      String fName,
      String lName) {
    Trip trip = new Trip(
        tripID: tripID,
        origin: origin,
        destination: destination,
        pickupPoint: pickupPoint,
        depatureDate: depatureDate,
        depatureTime: depatureTime,
        arrivalTime: arrivalTime,
        travellingPreferences: travellingPreferences,
        rewards: rewards);
    Navigator.push(
        context,
        SlideRightRoute(
            page: DriverTripDetail(trip: trip, driver: widget.driver)));
  }

  void _onJobDelete(String tripID, String destination) {
    print("Delete " + tripID);
    _showDialog(tripID, destination);
  }

  void _showDialog(String tripID, String destination) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete " + destination),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteRequest(tripID);
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

  Future<String> deleteRequest(String tripID) async {
    String urlDeleteTrip =
        "http://pickupandlaundry.com/hitchhiker/php/deleteTrip.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting Trip");
    pr.show();
    http.post(urlDeleteTrip, body: {
      "tripID": tripID,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        init();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }
}
