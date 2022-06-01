import 'package:flutter/material.dart';
import 'map.dart';
import 'favorite_page.dart';
import 'settings_page.dart';
import 'globals.dart' as globals;
import 'list_view_page.dart';

class BottomNavPage extends StatefulWidget {
  @override
  State<BottomNavPage> createState() => BottomNavPageState();
}

class BottomNavPageState extends State<BottomNavPage> {
  int currentIndex = 0;
  final screens = [
    Map(),
    const ListViewPage(),
    const FavoritePage(),
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
          ]),
    );
  }
}
