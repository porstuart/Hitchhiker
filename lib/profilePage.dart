import 'package:flutter/material.dart';
import 'package:hitchhiker/passenger.dart';

class ProfilePage extends StatefulWidget {
  final Passenger passenger;

  ProfilePage({Key key, this.passenger}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
