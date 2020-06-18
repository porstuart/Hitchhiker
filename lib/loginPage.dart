import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hitchhiker/driver.dart';
import 'package:hitchhiker/passenger.dart';
import 'package:hitchhiker/passengerRegisterPage.dart';
import 'package:hitchhiker/driverMainPage.dart';
import 'package:hitchhiker/forgotPassword.dart';
import 'package:hitchhiker/passengerMainPage.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String urlLoginPassenger =
      "http://pickupandlaundry.com/hitchhiker/php/loginPassenger.php";
  String urlLoginDriver =
      "http://pickupandlaundry.com/hitchhiker/php/loginDriver.php";
  String urlSecurityCodeForResetPass =
      "http://pickupandlaundry.com/hitchhiker/php/securityCode.php";
  String _email, _password = "";
  Passenger passenger;
  var _user = ['Passenger', 'Driver'];
  var _currentUser = 'Passenger';

  @override
  void initState() {
    //loadpref();
    print('Init: $_email');
    super.initState();
  }

  void _onLogin() {
    _email = _emailController.text;
    _password = _passwordController.text;
    if (_isEmailValid(_email) &&
        (_password.length > 4) &&
        this._currentUser == 'Passenger') {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login as Passenger");
      pr.show();
      http.post(urlLoginPassenger, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          print(dres);
          Passenger passenger = new Passenger(
              email: dres[1],
              fName: dres[2],
              lName: dres[3],
              matric: dres[4],
              phoneNum: dres[5],
              emergeNum: dres[6],
              residentialHall: dres[7]);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PassengerMainPage(passenger: passenger)),
              (Route<dynamic> route) => false);
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else if (_email == null || _password == null) {
      Toast.show("Log in failed, please try again.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_isEmailValid(_email) &&
        (_password.length > 4) &&
        this._currentUser == 'Driver') {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login as Driver");
      pr.show();
      http.post(urlLoginDriver, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          print("success driver");
          pr.dismiss();
          print(dres);
          Driver driver = new Driver(
              email: dres[1],
              fName: dres[2],
              lName: dres[3],
              matric: dres[4],
              phoneNum: dres[5],
              residentialHall: dres[6],
              carBrand: dres[7],
              carModel: dres[8],
              carPlate: dres[9],
              tripCount: dres[10]);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => DriverMainPage(driver: driver)),
              (Route<dynamic> route) => false);
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {}
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PassengerRegisterScreen()));
  }

  void _onForgot() {
    _email = _emailController.text;

    if (_isEmailValid(_email)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Sending Email");
      pr.show();
      http.post(urlSecurityCodeForResetPass, body: {
        "email": _email,
      }).then((res) {
        print("secure code : " + res.body);
        if (res.body == "error") {
          pr.dismiss();
          Toast.show('error', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          pr.dismiss();
          _saveEmailForPassReset(_email);
          _saveSecureCode(res.body); //save secure code for password reset
          Toast.show('Security code sent to your email', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {
      Toast.show('Invalid Email', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _saveEmailForPassReset(String email) async {
    print('saving preferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('resetPassEmail', email);
  }

  void _saveSecureCode(String code) async {
    print('saving preferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('secureCode', code);
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email.length > 1) {
      _emailController.text = _email;
      _passwordController.text = _password;
      setState(() {});
    } else {
      print('No pref');
      setState(() {});
    }
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _email = _emailController.text;
    _password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_isEmailValid(_email) && (_password.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Save pref $_email');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {});
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {});
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentUser = newValueSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover)),
        child: Stack(
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
                              "Login",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  fontFamily: "Poppins-Bold",
                                  letterSpacing: .6),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Text(
                              "Email",
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontSize: ScreenUtil.getInstance().setSp(26)),
                            ),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Text(
                              "Password",
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontSize: ScreenUtil.getInstance().setSp(26)),
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(20),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    child: DropdownButton<String>(
                                      items: _user
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(
                                            dropDownStringItem,
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String newValueSelected) {
                                        _onDropDownItemSelected(
                                            newValueSelected);
                                      },
                                      value: _currentUser,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _onForgot();
                                  },
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                        fontFamily: "Poppins-Medium",
                                        fontSize:
                                            ScreenUtil.getInstance().setSp(28)),
                                  ),
                                ),
                              ],
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
                                colors: [Color(0xFF17EAD9), Color(0xDD6078EA)],
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
                                  _onLogin();
                                },
                                child: Center(
                                  child: Text(
                                    "LOGIN",
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
                      height: ScreenUtil.getInstance().setHeight(100),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("New User? ",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                color: Colors.white)),
                        GestureDetector(
                          onTap: () {
                            _onRegister();
                          },
                          child: Text("Register",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue[400],
                                  fontFamily: "Poppins-Bold")),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
