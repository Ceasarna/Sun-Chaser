import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_applicationdemo/shadow_detector.dart';
import 'package:flutter_applicationdemo/login/google_sign_in_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'bottom_nav_page.dart';
import 'weather_data.dart';
import 'venue.dart';
import 'mysql.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadAllVenues();
  await fetchWeather();
  await weatherInstance();
  await loadAllVenuesSQL();

  runApp(MyApp());
}

Future weatherInstance() async{
  WeatherData weather = WeatherData(3, 12);
  globals.forecast = weather;

}

Future fetchWeather() async {
  WeatherData tempWeather = WeatherData(0, 0);
  Uri weatherDataURI = Uri.parse(
      'https://group-4-75.pvt.dsv.su.se/target/info.war/weather');

  final response = await http.get(weatherDataURI);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    tempWeather = WeatherData.fromJson(data);

    globals.forecast = tempWeather;
  } else {
    throw const HttpException("Problem fetching the weather data");
  }
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
        home: BottomNavPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Future loadAllVenues() async {
  Uri venueDataURI = Uri.parse(
      'https://group-4-75.pvt.dsv.su.se/target/info.war/venue');

  final response = await http.get(venueDataURI);

  if (response.statusCode == 200) {
    addVenues(response);

    // var sd = ShadowDetector();
    // await sd.evaluateShadowsForAllVenues(seventyFiveVenues);
  } else {
    throw const HttpException("Problem fetching the venue data");
  }
}

void addVenues(http.Response response) {
  var data = json.decode(response.body);
  var _allVenuesTemp = [];

  addValidVenues(data, _allVenuesTemp);

  for (Venue venue in _allVenuesTemp) {
    if(!globals.venueAlreadyAdded(venue.venueName)){
      globals.VENUES.add(venue);
    }
  }
}

void addValidVenues(data, List<dynamic> _allVenuesTemp) {
  for (var i = 0; i < data.values.first.length; i++) {
    if (data.values.first[i]['name'] == null) {
      continue;
    } else if (data.values.first[i]['address'].contains('null')) {
      continue;
    } else if (!data.values.first[i]['name'].contains('©') &&
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

Future<void> loadAllVenuesSQL() async{
  var db = mysql();
  await db.getConnection().then((conn) async {
    String sql = "select venueName, venueID, latitude, longitude from maen0574.venue";
    await conn.query(sql).then((results){
      for(var row in results){
        globals.VENUES.add(Venue(row[1], row[0], "Dalagatan", "2", LatLng(row[2], row[3])));
      }
    });
    sql = "select venueID, north, east, west, south from maen0574.seatingArea";
    await conn.query(sql).then((results){
      for(var row in results){
        globals.getVenueByID(row[0])?.assignSeatingArea(OutdoorSeatingArea(northPoint: row[1], eastPoint: row[2], westPoint: row[3], southPoint: row[4]));
      }
    });
  });
}
