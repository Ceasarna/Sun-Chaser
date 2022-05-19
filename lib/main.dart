import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_applicationdemo/login/GoogleSignInProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_applicationdemo/login/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';

import 'Map.dart';
import 'HomePage.dart';
import 'Venue.dart';
import 'mysql.dart';
import 'package:flutter_applicationdemo/login/user.dart';
import 'login/user.dart';
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadAllVenues();

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
Future<void> loadAllVenues() async{
  VENUES = [];
  var db = mysql();
  await db.getConnection().then((conn) async {
    String sql = "select venueName, venueID, latitude, longitude from maen0574.venue";
    await conn.query(sql).then((results){
      for(var row in results){
        VENUES.add(Venue(row[0], row[1], VenueType.restaurant, LatLng(row[2], row[3])));
      }
    });
  });
}