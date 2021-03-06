import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hitchhiker/trip.dart';
import 'package:hitchhiker/passenger.dart';
import 'package:hitchhiker/acceptedDetail.dart';
import 'package:hitchhiker/slideRightRoute.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

double perpage = 1;

class AcceptedTripPage extends StatefulWidget {
  final Passenger passenger;
  final Trip trip;

  AcceptedTripPage({Key key, this.passenger, this.trip});

  @override
  _AcceptedTripPageState createState() => _AcceptedTripPageState();
}

class _AcceptedTripPageState extends State<AcceptedTripPage> {
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
        SystemUiOverlayStyle(statusBarColor: Colors.indigo[400]));
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
                                    child: Text(
                                      "HITCHHIKER",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: "Agne",
                                        height: 1,
                                      ),
                                    ),
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
                                                    widget.passenger.fName
                                                                .toUpperCase() +
                                                            " " +
                                                            widget
                                                                .passenger.lName
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
                                                  child: Text(widget
                                                      .passenger.phoneNum),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.credit_card,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      widget.passenger.matric),
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
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(146, 143, 206, 1),
                                      Color.fromRGBO(170, 177, 229, 1)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(170, 177, 229, 1),
                                      blurRadius: 12,
                                      offset: Offset(0, 6))
                                ],
                              ),
                              child: Center(
                                child: Text("Accepted Trip",
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
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
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
                            widget.passenger.fName,
                            widget.passenger.lName,
                          ),
                          onLongPress: _onJobDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(80, 167, 194, 1),
                                          Color.fromRGBO(183, 248, 219, 1)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(80, 167, 194, 0.8),
                                          blurRadius: 12,
                                          offset: Offset(0, 6))
                                    ],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(20)),
                                      Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                  color: Colors.white),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      "assets/images/trip.jpg")))),
                                      Expanded(
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(34),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                    data[index]['destination']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(data[index]['origin']),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(data[index]
                                                    ['depatureDate']),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(data[index]
                                                    ['depatureTime']),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }

  Future<String> makeRequest() async {
    String urlLoadTrip =
        "http://pickupandlaundry.com/hitchhiker/php/loadAcceptedTrip.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Trips");
    pr.show();
    http.post(urlLoadTrip, body: {
      "email": widget.passenger.email ?? "notavail",
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
    await Future.delayed(Duration(seconds: 0));
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
            page: AcceptedDetail(trip: trip, passenger: widget.passenger)));
  }

  void _onJobDelete() {
    print("Delete");
  }
}
