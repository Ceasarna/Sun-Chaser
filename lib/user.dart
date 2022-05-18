import 'package:flutter_applicationdemo/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Venue.dart';
import 'mysql.dart';

class user{
  late int userID;
  late String username;
  late String email;
  late List<int> likedVenuesList;

  user(int userID, String username, String email){
    this.userID = userID;
    this.username = username;
    this.email = email;
    likedVenuesList = List.empty(growable: true);
    getFavoriteVenues();
  }

  user emptyUser(){
    return user(0, "", "");
  }
  int getID(){
    return userID;
  }

  Future<void> getFavoriteVenues() async{
    var db = mysql();
    await db.getConnection().then((conn) async {
      String sql = "select venue_id from maen0574.userFavorites where user_id = '$userID'";
      await conn.query(sql).then((results){
        for(var row in results){
          likedVenuesList.add(row[0]);
        }
      });
    });
  }
}

