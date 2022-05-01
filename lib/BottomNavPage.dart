import 'package:flutter/material.dart';
import 'Map.dart';
import 'FavoritePage.dart';
import 'SettingsPage.dart';


class BottomNavPage extends StatefulWidget {
  @override
  State<BottomNavPage> createState() => BottomNavPageState();
}

class BottomNavPageState extends State<BottomNavPage> {

  int currentIndex = 0;
  final screens =[
    Map(),
    FavoritePage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 190, 146, 160),
        selectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (index) => setState( () => currentIndex = index),
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
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

