import 'package:flutter_applicationdemo/weather_data.dart';

import 'venue.dart';
import 'package:flutter_applicationdemo/login/user.dart';
import '../login/user.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'home_page.dart';
import 'venue.dart';
import 'main.dart';

User LOGGED_IN_USER = User(0, "", "");
Color BACKGROUNDCOLOR = const Color.fromARGB(255, 190, 146, 160);
Color ITEMCOLOR = const Color.fromARGB(255, 0, 0, 0);
Color BUTTONCOLOR = const Color.fromARGB(204, 172, 123, 132);
Color PINKBACKGROUND = const Color.fromARGB(255, 240, 229, 229);
Color TEXTCOLOR = const Color.fromARGB(255, 79, 98, 114);
Color SHADOWCOLOR = const Color.fromARGB(255, 0, 0, 0);
Color TEXTWHITE = const Color.fromARGB(0, 0, 0, 0);
const double elevation = 5;
late List<Venue> VENUES = [];
late WeatherData forecast;

Venue? getVenueByID(int searchedVenueID){
  for(var V in VENUES){
    if(V.venueID == searchedVenueID){
      return V;
    }
  }return null;
}

bool venueAlreadyAdded(String venueName){
  for(var V in VENUES){
    if(V.venueName.compareTo(venueName) == 0){
      return true;
    }
  }
  return false;
}