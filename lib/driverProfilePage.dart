import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/main.dart';
import 'package:hitchhiker/driver.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String urlGetdriver =
    "http://pickupandlaundry.com/hitchhiker/php/getdriver.php";
String urlUpdate =
    "http://pickupandlaundry.com/hitchhiker/php/updateDriverProfile.php";

class DriverProfilePage extends StatefulWidget {
  final Driver driver;

  DriverProfilePage({this.driver});

  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  void _changePassword() {
    TextEditingController passwordController = TextEditingController();
    print(widget.driver.fName + " " + widget.driver.lName);
    if (widget.driver.fName == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Change Password"),
          content: new TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passwordController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlUpdate, body: {
                  "email": widget.driver.email,
                  "password": passwordController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.driver.fName = dres[2];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passwordController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _changePhone() {
    TextEditingController phoneNumController = TextEditingController();
    print(widget.driver.fName + " " + widget.driver.lName);
    if (widget.driver.fName == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Change Contact Number"),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneNumController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneNumController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlUpdate, body: {
                  "email": widget.driver.email,
                  "phoneNum": phoneNumController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.driver.phoneNum = dres[5];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
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

  void _changeResidentialHall() {
    TextEditingController residentialHallController = TextEditingController();
    print(widget.driver.fName + " " + widget.driver.lName);
    if (widget.driver.fName == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Change Residential Hall"),
          content: new TextField(
            controller: residentialHallController,
            decoration: InputDecoration(
              labelText: 'Residential Hall',
              icon: Icon(Icons.home),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                http.post(urlUpdate, body: {
                  "email": widget.driver.email,
                  "residentialHall": residentialHallController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.driver.residentialHall = dres[6];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(residentialHallController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _changeCarBrand() {
    TextEditingController carBrandController = TextEditingController();
    print(widget.driver.fName + " " + widget.driver.lName);
    if (widget.driver.fName == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Change Car Brand"),
          content: new TextField(
            controller: carBrandController,
            decoration: InputDecoration(
              labelText: 'Car Brand',
              icon: Icon(Icons.lock),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                http.post(urlUpdate, body: {
                  "email": widget.driver.email,
                  "carBrand": carBrandController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.driver.carBrand = dres[7];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(carBrandController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _changeCarModel() {
    TextEditingController carModelController = TextEditingController();
    print(widget.driver.fName + " " + widget.driver.lName);
    if (widget.driver.fName == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Change Car Model"),
          content: new TextField(
            controller: carModelController,
            decoration: InputDecoration(
              labelText: 'Car Model',
              icon: Icon(Icons.lock),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                http.post(urlUpdate, body: {
                  "email": widget.driver.email,
                  "carModel": carModelController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.driver.carModel = dres[8];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(carModelController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _changeCarPlate() {
    TextEditingController carPlateController = TextEditingController();
    print(widget.driver.fName + " " + widget.driver.lName);
    if (widget.driver.fName == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Change Car Plate"),
          content: new TextField(
            controller: carPlateController,
            decoration: InputDecoration(
              labelText: 'Car Plate',
              icon: Icon(Icons.lock),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                http.post(urlUpdate, body: {
                  "email": widget.driver.email,
                  "carPlate": carPlateController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.driver.carPlate = dres[9];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(carPlateController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _gotologout() async {
    print(widget.driver.fName + " " + widget.driver.lName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Go to login page?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                print("LOGOUT");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (Route<dynamic> route) => false);
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

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', pass);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.indigo[400]));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Image.asset(
                            "assets/images/background.png",
                            fit: BoxFit.fitWidth,
                          ),
                          Column(
                            children: <Widget>[
                              Center(
                                child: Text("Hitchhiker",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              SizedBox(height: 5),
                              SizedBox(height: 5),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      widget.driver.fName?.toUpperCase() ??
                                          'Not register',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(" "),
                                    Text(
                                      widget.driver.lName?.toUpperCase() ??
                                          'Not register',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.driver.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                      ),
                                      Text(widget.driver.phoneNum ??
                                          'not registered'),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.credit_card,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(widget.driver.matric ??
                                            "not registered"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.home,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                            widget.driver.residentialHall ??
                                                "not registered"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.motorcycle,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(widget.driver.carBrand ??
                                            "not registered"),
                                      ),
                                      Flexible(
                                        child: Text(" "),
                                      ),
                                      Flexible(
                                        child: Text(widget.driver.carModel ??
                                            "not registered"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.motorcycle,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(widget.driver.carPlate ??
                                            "not registered"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
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
                                  child: Text("My Profile ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130,
                                child: Text(
                                  "Password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                width: 130,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 77,
                                      child: Text(
                                        "********",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      iconSize: 20,
                                      onPressed: _changePassword,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130,
                                child: Text(
                                  "Contact Number",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                width: 130,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      widget.driver.phoneNum,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      iconSize: 20,
                                      onPressed: _changePhone,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130,
                                child: Text(
                                  "Residential Hall",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                width: 130,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      child: Text(
                                        widget.driver.residentialHall,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      iconSize: 20,
                                      onPressed: _changeResidentialHall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130,
                                child: Text(
                                  "Car Brand",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                width: 130,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      child: Text(
                                        widget.driver.carBrand,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      iconSize: 20,
                                      onPressed: _changeCarBrand,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130,
                                child: Text(
                                  "Car Model",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                width: 130,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      child: Text(
                                        widget.driver.carModel,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      iconSize: 20,
                                      onPressed: _changeCarModel,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130,
                                child: Text(
                                  "Car Plate",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                width: 130,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      child: Text(
                                        widget.driver.carPlate,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      iconSize: 20,
                                      onPressed: _changeCarPlate,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 100),
                        MaterialButton(
                          onPressed: _gotologout,
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Container();
              }),
        ));
  }
}
