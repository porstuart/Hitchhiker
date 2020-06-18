import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hitchhiker/driver.dart';
import 'package:hitchhiker/driverMainPage.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
import 'package:progress_dialog/progress_dialog.dart';

String urlAddTrip = "http://pickupandlaundry.com/hitchhiker/php/addTrip.php";
String urlGetDriver =
    "http://pickupandlaundry.com/hitchhiker/php/getDriver.php";

final TextEditingController _originController = TextEditingController();
final TextEditingController _destinationController = TextEditingController();
final TextEditingController _pickupPointController = TextEditingController();
final TextEditingController _travellingPreferencesController =
    TextEditingController();
final TextEditingController _rewardsController = TextEditingController();
DateTime _departDatePicker = new DateTime.now();
TimeOfDay _departTimePicker = new TimeOfDay.now();
TimeOfDay _arriveTimePicker = new TimeOfDay.now();
String _departureDate = DateFormat('yyyy-M-dd').format(_departDatePicker);
String _departureTime =
    "${_departTimePicker.hour} : ${_departTimePicker.minute}";
String _arrivalTime = "${_arriveTimePicker.hour} : ${_arriveTimePicker.minute}";

class AddTripPage extends StatefulWidget {
  final Driver driver;
  const AddTripPage({Key key, this.driver}) : super(key: key);

  @override
  _AddTripPageState createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  @override
  void initState() {
    super.initState();
    print("below here is AddTripPage");
    print(widget.driver.email);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Image.asset(
                      "assets/images/hitchhikerLogo.png",
                      width: ScreenUtil.getInstance().setWidth(550),
                      height: ScreenUtil.getInstance().setHeight(400),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Image.asset("assets/images/background.png")
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 40.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil.getInstance().setWidth(110),
                            height: ScreenUtil.getInstance().setHeight(110),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(180),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 15.0),
                                blurRadius: 15.0)
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Add Trip",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(45),
                                    fontFamily: "Poppins-Bold",
                                    letterSpacing: .6),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Origin",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              TextField(
                                controller: _originController,
                                decoration: InputDecoration(
                                    hintText: "Origin",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Destination",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              TextField(
                                controller: _destinationController,
                                decoration: InputDecoration(
                                    hintText: "Destination",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Pickup Point",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              TextField(
                                controller: _pickupPointController,
                                decoration: InputDecoration(
                                    hintText: "Pickup Point",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Depature Date",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              FlatButton(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.calendar_today),
                                      SizedBox(width: 10),
                                      Text(
                                        '${formatDate(_departDatePicker, [
                                          dd,
                                          '-',
                                          mm,
                                          '-',
                                          yyyy
                                        ])}',
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    final dtPick = await showDatePicker(
                                        context: context,
                                        initialDate: new DateTime.now(),
                                        firstDate: new DateTime(2020),
                                        lastDate: new DateTime(2100));

                                    if (dtPick != null &&
                                        dtPick != _departDatePicker) {
                                      setState(() {
                                        _departDatePicker = dtPick;
                                      });
                                    }
                                  }),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Depature Time",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.alarm),
                                    SizedBox(width: 10),
                                    Text(
                                        '${_departTimePicker.hour} : ${_departTimePicker.minute}'),
                                  ],
                                ),
                                onPressed: () async {
                                  final timePick = await showTimePicker(
                                    context: context,
                                    initialTime: new TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child,
                                      );
                                    },
                                  );

                                  if (timePick != null) {
                                    setState(() {
                                      _departTimePicker = timePick;
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Arrival Time",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.alarm),
                                    SizedBox(width: 10),
                                    Text(
                                        '${_arriveTimePicker.hour} : ${_arriveTimePicker.minute}'),
                                  ],
                                ),
                                onPressed: () async {
                                  final timePick = await showTimePicker(
                                    context: context,
                                    initialTime: new TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child,
                                      );
                                    },
                                  );

                                  if (timePick != null) {
                                    setState(() {
                                      _arriveTimePicker = timePick;
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Travelling Preferences",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              TextField(
                                controller: _travellingPreferencesController,
                                decoration: InputDecoration(
                                    hintText: "Travelling Preferences",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text(
                                "Rewards",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26)),
                              ),
                              TextField(
                                controller: _rewardsController,
                                decoration: InputDecoration(
                                    hintText: "Rewards",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: ScreenUtil.getInstance().setWidth(330),
                              height: ScreenUtil.getInstance().setHeight(100),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF17EAD9),
                                    Color(0xDD6078EA)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078EA).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _onAddTrip();
                                  },
                                  child: Center(
                                    child: Text(
                                      "Add Trip",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins-Bold",
                                          fontSize: 18,
                                          letterSpacing: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(40),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<bool> _onBackPressAppBar() async {
    _originController.text = "";
    _destinationController.text = "";
    _pickupPointController.text = "";
    _departDatePicker = new DateTime.now();
    _departTimePicker = new TimeOfDay.now();
    _arriveTimePicker = new TimeOfDay.now();
    _travellingPreferencesController.text = "";
    _rewardsController.text = "";

    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => DriverMainPage(driver: widget.driver),
        ));
    return Future.value(false);
  }

  void _onAddTrip() {
    print(widget.driver.email);

    if (_originController.text.isEmpty) {
      Toast.show("Please enter origin", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Adding Trip");
    pr.show();

    http.post(urlAddTrip, body: {
      "driverEmail": widget.driver.email,
      "tripCount": widget.driver.tripCount,
      "origin": _originController.text,
      "destination": _destinationController.text,
      "pickupPoint": _pickupPointController.text,
      "depatureDate": _departureDate,
      "depatureTime": _departureTime,
      "arrivalTime": _arrivalTime,
      "travellingPreferences": _travellingPreferencesController.text,
      "rewards": _rewardsController.text,
    }).then((res) {
      print(urlAddTrip);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _originController.text = '';
        _destinationController.text = '';
        _pickupPointController.text = "";
        _departDatePicker = new DateTime.now();
        _departTimePicker = new TimeOfDay.now();
        _arriveTimePicker = new TimeOfDay.now();
        _travellingPreferencesController.text = "";
        _rewardsController.text = "";
        pr.dismiss();
        print(widget.driver.email);
        print(_departureTime);
        _onLogin(widget.driver.email, context);
      } else {
        pr.dismiss();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  void _onLogin(String email, BuildContext ctx) {
    http.post(urlGetDriver, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Driver driver = new Driver(
          email: dres[1],
          fName: dres[2],
          lName: dres[3],
          matric: dres[4],
          phoneNum: dres[5],
          residentialHall: dres[6],
        );
        Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (context) => DriverMainPage(driver: driver)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
