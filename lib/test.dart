import 'package:flutter/material.dart';
import 'package:hitchhiker/passenger.dart';

class TestPage extends StatefulWidget {
  final Passenger passenger;
  TestPage({Key key, this.passenger}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white
    );
  }
}