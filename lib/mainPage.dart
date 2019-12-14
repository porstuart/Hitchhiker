import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/passenger.dart';
import 'package:hitchhiker/profilePage.dart';
import 'package:hitchhiker/tripPage.dart';

class MainPage extends StatefulWidget {
  final Passenger passenger;

  const MainPage({Key key, this.passenger}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TripPage(passenger: widget.passenger),
      ProfilePage(passenger: widget.passenger),
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
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
