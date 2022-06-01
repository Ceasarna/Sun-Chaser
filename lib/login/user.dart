import 'package:flutter_applicationdemo/venue.dart';
import 'package:flutter_applicationdemo/mysql.dart';
import 'package:flutter_applicationdemo/globals.dart' as globals;


class User{
  late int userID;
  late String username;
  late String email;
  late List<Venue> likedVenuesList;

  User(this.userID, this.username, this.email){
    likedVenuesList = List.empty(growable: true);
    getFavoriteVenues();
  }

  User emptyUser(){
    return User(0, "", "");
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
          Venue? venue = globals.getVenueByID(row[0]);
          if(venue != null){
            likedVenuesList.add(venue);
          }
        }
      });
    });
  }
}

