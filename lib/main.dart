import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_applicationdemo/login/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';

import 'Map.dart';
import 'HomePage.dart';
import 'login/user.dart';
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        title: 'Flutter Google Maps Demo',
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
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
