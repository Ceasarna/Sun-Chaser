import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/camera.dart';
import 'Map.dart';
import 'FavoritePage.dart';
import 'SettingsPage.dart';
import 'globals.dart' as globals;
import 'ListViewPage.dart';

class BottomNavPage extends StatefulWidget {
  @override
  State<BottomNavPage> createState() => BottomNavPageState();
}

class BottomNavPageState extends State<BottomNavPage> {
  int currentIndex = 0;
  final screens = [
    Map(),
    ListViewPage(),
    FavoritePage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: globals.BACKGROUNDCOLOR,
          selectedItemColor: globals.ITEMCOLOR,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_sharp),
              label: "List View",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Liked",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ]),
    );
  }
}
