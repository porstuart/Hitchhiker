import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/loginPage.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(ForgotPassword());

final TextEditingController _securityCodeController = TextEditingController();
final TextEditingController _newPasswordController = TextEditingController();
final TextEditingController _newPasswordController2 = TextEditingController();

String _secureCode = "";
String _newPassword = "";
String _newPassword2 = "";

bool _isCodeMatch = false;
String urlResetPass =
    'http://pickupandlaundry.com/hitchhiker/php/resetPassword.php';
String _email = "";

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  static const String _themePreferenceKey = 'isDark';

  @override
  void initState() {
    _loadResetEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
          child: new Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _securityCodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Security Code',
                    icon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      minWidth: 50,
                      height: 50,
                      child: Text('OK'),
                      color: Colors.blueAccent[200],
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _checkCode,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      minWidth: 10,
                      height: 50,
                      child: Text('Cancel'),
                      color: Colors.blueAccent[200],
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _cancel,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                    enabled: _isCodeMatch,
                    controller: _newPasswordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true),
                TextField(
                  enabled: _isCodeMatch,
                  controller: _newPasswordController2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Re-type Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  minWidth: 80,
                  height: 50,
                  child: Text('Save'),
                  color: Colors.blueAccent[200],
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _updatePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadResetEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('resetPassEmail');

    print('Reset Password Email : $_email');
  }

  void _updatePassword() {
    _newPassword = _newPasswordController.text;
    _newPassword2 = _newPasswordController2.text;

    if (_isCodeMatch) {
      if (_newPassword == _newPassword2) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);

        print(_newPassword);

        pr.style(message: "Updating Password");
        pr.show();
        http.post(urlResetPass, body: {
          "email": _email,
          "newPassword": _newPassword,
        }).then((res) {
          print("Password update : " + res.body);
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          if (res.body == "success") {
            pr.dismiss();
            _securityCodeController.text = "";
            _newPasswordController.text = "";
            _newPasswordController2.text = "";

            _removePrefsExceptTheme();

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            pr.dismiss();
          }
        }).catchError((err) {
          pr.dismiss();
          print(err);
        });
      } else {
        Toast.show('Password doesn\'t match', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      Toast.show('Enter Security Code', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _removePrefsExceptTheme() async {
    bool theme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    theme = prefs.getBool(_themePreferenceKey); //get theme value
    prefs.clear(); //clear preferences
    prefs.setBool(_themePreferenceKey, theme); //put back theme in preferences
  }

  void _cancel() async {
    _removePrefsExceptTheme();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  void _checkCode() {
    _secureCode = _securityCodeController.text;

    _loadCode().then((onValue) {
      if (_secureCode == onValue) {
        _isCodeMatch = true;

        Toast.show('Correct Code', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {});
      } else {
        _isCodeMatch = false;
        Toast.show('Wrong Code', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  Future<String> _loadCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString('secureCode');
    print('Reset Pass : saved secure code : ' + code);
    return code;
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}
