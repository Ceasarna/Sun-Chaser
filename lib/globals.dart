import 'Venue.dart';
import 'package:flutter_applicationdemo/login/user.dart';
import '../login/user.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'user.dart';
import 'HomePage.dart';
import 'main.dart';

user LOGGED_IN_USER = user(0, "", "");
Color BACKGROUNDCOLOR = const Color.fromARGB(255, 190, 146, 160);
Color ITEMCOLOR = const Color.fromARGB(255, 0, 0, 0);
Color BUTTONCOLOR = const Color.fromARGB(204, 172, 123, 132);
Color PINKBACKGROUND = const Color.fromARGB(255, 240, 229, 229);
Color TEXTCOLOR = const Color.fromARGB(255, 79, 98, 114);
Color SHADOWCOLOR = const Color.fromARGB(255, 0, 0, 0);
Color TEXTWHITE = const Color.fromARGB(0, 0, 0, 0);
late List<Venue> VENUES;
