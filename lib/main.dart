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

import 'BottomNavPage.dart';
import 'Map.dart';
import 'WeatherData.dart';
import 'Venue.dart';
import 'mysql.dart';
import 'package:flutter_applicationdemo/login/User.dart';
import 'login/User.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadAllVenues();
  await fetchWeather();
  // await createVenue();
  // await setWeather();

  runApp(MyApp());
}

setWeather() {
  WeatherData weather = WeatherData(4, 15);
  globals.forecast = weather;
}

createVenue() {
  Venue venue = Venue(00, 'Restaurang Aira', 'Biskopsvägen', '9', const LatLng(59.32117929060902, 18.123636884658502));
  globals.VENUES.add(venue);
}

Future fetchWeather() async {
  WeatherData tempWeather = WeatherData(0, 0);
  Uri weatherDataURI = Uri.parse(
      'https://group-4-75.pvt.dsv.su.se/target/info.war/weather');

  final response = await http.get(weatherDataURI);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    tempWeather = WeatherData.fromJson(data);
    print(data);

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
    globals.VENUES.add(venue);
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
