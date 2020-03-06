import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hitchhiker/acceptedTripPage.dart';
import 'package:hitchhiker/trip.dart';
import 'package:hitchhiker/passenger.dart';
import 'package:hitchhiker/profilePage.dart';
import 'package:hitchhiker/passengerTripPage.dart';

class PassengerMainPage extends StatefulWidget {
  final Passenger passenger;
  final Trip trip;

  const PassengerMainPage({Key key, this.passenger,this.trip}) : super(key: key);

  @override
  _PassengerMainPageState createState() => _PassengerMainPageState();
}

class _PassengerMainPageState extends State<PassengerMainPage> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      PassengerTripPage(passenger: widget.passenger),
      AcceptedTripPage(passenger: widget.passenger),
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
            icon: Icon(Icons.motorcycle),
            title: Text("Accepted Trip"),
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
