import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/login/GoogleSignInProvider.dart';
import 'package:flutter_applicationdemo/Map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:settings_ui/settings_ui.dart';
import 'ManageAccountPage.dart';
import 'package:provider/provider.dart';
import 'Venue.dart';
import 'globals.dart';
import 'Map.dart';
import 'package:flutter_applicationdemo/login/user.dart';
import 'HomePage.dart';

// Standard color of app
Color _backgroundColor = const Color.fromARGB(255, 190, 146, 160);

// Color status of priceRange
Color _colorContainerLow = Colors.yellow;
Color _colorContainerMedium = _backgroundColor;
Color _colorContainerHigh = _backgroundColor;

// Standard
@override
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List likedVenuesList = LOGGED_IN_USER.likedVenuesList;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // No appbar provided to the Scaffold, only a body with a
        // CustomScrollView.
        body: CustomScrollView(
          slivers: [
            // Add the app bar to the CustomScrollView.
            SliverAppBar(
              // Provide a standard title.
              title: Text("Liked places"),
              // Allows the user to reveal the app bar if they begin scrolling
              // back up the list of items.
              pinned: true,
              floating: true,
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 50,
              backgroundColor: const Color.fromARGB(255, 190, 146, 160),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              )
            ),
            // Next, create a SliverList
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                    (context, index) => ListTile(title: Text('Item #$index'), trailing: IconButton(icon: Icon(Icons.favorite, color: Colors.red), onPressed: (){
                      setState(() {
                      });
                      print("tabort");
                    },), onTap: (){
                      setState(() {
                      });
                      print("gå till venue");
                    },),
                // Builds 1000 ListTiles
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

