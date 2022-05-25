import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_applicationdemo/ShadowDetector.dart';
import 'package:flutter_applicationdemo/login/GoogleSignInProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_applicationdemo/login/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'Map.dart';
import 'HomePage.dart';
import 'Venue.dart';
import 'mysql.dart';
import 'package:flutter_applicationdemo/login/User.dart';
import 'login/User.dart';
import 'globals.dart' as globals;

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

Future loadAllVenues() async {

  Uri venueDataURI = Uri.parse(
      'https://group-4-75.pvt.dsv.su.se/target/weather-0.0.4-SNAPSHOT.war/venue');

  final response = await http.get(venueDataURI);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var _allVenuesTemp = [];

    addValidVenues(data, _allVenuesTemp);

    var count = 0;
    for (Venue vdata in _allVenuesTemp) {
      count++;
      //print(count.toString() + ': ' + vdata.toString());
      globals.VENUES.add(vdata);
    }
  } else {
    throw const HttpException("Problem fetching the weather data");
  }
}

void addValidVenues(data, List<dynamic> _allVenuesTemp) {
  for (var i = 0; i < data.values.first.length; i++) {
    if (!data.values.first[i]['name'].contains('©') &&
        !data.values.first[i]['name'].contains('¶') &&
        !data.values.first[i]['name'].contains('¥') &&
        !data.values.first[i]['name'].contains('Ã') &&
        !data.values.first[i]['name'].contains('Â') &&
        !data.values.first[i]['address'].contains('©') &&
        !data.values.first[i]['address'].contains('¶') &&
        !data.values.first[i]['address'].contains('¥') &&
        !data.values.first[i]['address'].contains('Ã')) {
      _allVenuesTemp.add(Venue.fromJson(data.values.first[i], i));
    } else {
      continue;
    }
  }
}

/*
Future<void> loadAllVenues() async {
  globals.VENUES = [];
  var db = mysql();
  await db.getConnection().then((conn) async {
    String sql =
        "select venueName, venueID, latitude, longitude from maen0574.venue";
    await conn.query(sql).then((results) {
      for (var row in results) {
        globals.VENUES.add(Venue(
            row[0], row[1], VenueType.restaurant, LatLng(row[2], row[3])));
      }
    });
  });

var sd = ShadowDetector();
await sd.evaluateShadowsForAllVenues(globals.VENUES);
}
*/
