import 'package:flutter/material.dart';
import 'package:hitchhiker/passenger.dart';
import 'package:hitchhiker/profilePage.dart';
import 'package:hitchhiker/trip.dart';

class MainScreen extends StatefulWidget {
  final Passenger passenger;

  const MainScreen({Key key, this.passenger}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      Trip(),
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
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        backgroundColor: Colors.teal[50],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Trip"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
