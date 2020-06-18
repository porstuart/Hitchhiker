import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/driver.dart';
import 'package:hitchhiker/addTripPage.dart';
import 'package:hitchhiker/driverTripPage.dart';
import 'package:hitchhiker/driverHistoryPage.dart';
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
      DriverHistoryPage(driver: widget.driver),
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
        SystemUiOverlayStyle(statusBarColor: Colors.indigo[400]));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Posted Trip"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            title: Text("Add Trip"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text("History Trip"),
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
