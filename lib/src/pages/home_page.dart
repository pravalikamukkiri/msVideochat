import 'package:flutter/material.dart';
import 'package:teamsclone/src/pages/index.dart';
import 'package:teamsclone/src/pages/message.dart';
import './register.dart';
import './message.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Register();
  }
}