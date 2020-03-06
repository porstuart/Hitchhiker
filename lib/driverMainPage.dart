import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/driver.dart';
import 'package:hitchhiker/addTripPage.dart';
import 'package:hitchhiker/driverTripPage.dart';
import 'package:hitchhiker/driverProfilePage.dart';

class DriverMainPage extends StatefulWidget {
  final Driver driver;

  const DriverMainPage({Key key, this.driver}) : super(key: key);

  @override
  _DriverMainPageState createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      DriverTripPage(driver: widget.driver),
      AddTripPage(driver: widget.driver),
      DriverProfilePage(driver: widget.driver),
    ];
  }

  String $pagetitle = "Hitchhiker";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Trip"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            title: Text("Posted Trip"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
