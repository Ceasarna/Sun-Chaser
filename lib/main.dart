import 'dart:async';

import 'package:flutter/material.dart';


import 'Map.dart';
import 'HomePage.dart';
import 'user.dart';
import 'globals.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Flutter Google Maps Demo',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Map()));
        },
        label: const Text('To Karta'),
        icon: const Icon(Icons.directions_boat),
        ),
    );
  }

}*/
